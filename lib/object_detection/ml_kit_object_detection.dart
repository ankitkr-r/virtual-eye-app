import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:virtual_eye/l10n/app_localizations.dart';

class MLKitObjectDetection extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MLKitObjectDetection({super.key, required this.cameras});

  @override
  State<MLKitObjectDetection> createState() => _MLKitObjectDetectionState();
}

class _MLKitObjectDetectionState extends State<MLKitObjectDetection> {
  CameraController? _controller;
  FlutterTts flutterTts = FlutterTts();

  bool _isDetecting = false;
  bool _isDisposed = false;

  late ImageLabeler _imageLabeler;

  // ── Locale → TTS language code map ──────────────────────────────────────
  static const Map<String, String> _localeToTtsLang = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'bn': 'bn-IN',
    'ta': 'ta-IN',
    'te': 'te-IN',
    'mr': 'mr-IN',
    'gu': 'gu-IN',
    'kn': 'kn-IN',
    'ml': 'ml-IN',
    'pa': 'pa-IN',
    'ur': 'ur-PK',
    'fr': 'fr-FR',
    'de': 'de-DE',
    'es': 'es-ES',
    'zh': 'zh-CN',
    'ar': 'ar-SA',
    'ja': 'ja-JP',
    'ko': 'ko-KR',
    'pt': 'pt-BR',
    'ru': 'ru-RU',
  };

  // Labels that represent a human — catches all ML Kit variants
  static const Set<String> _humanLabels = {
    'person',
    'human',
    'man',
    'woman',
    'boy',
    'girl',
    'child',
    'people',
    'face',
    'body',
    'pedestrian',
    'selfie',
    'portrait',
  };

  @override
  void initState() {
    super.initState();

    // Use a lower confidence threshold so human labels aren't filtered out
    final options = ImageLabelerOptions(confidenceThreshold: 0.5);
    _imageLabeler = ImageLabeler(options: options);

    initializeCamera(null);
    // TTS is initialized after first build so we can read the locale
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-init TTS whenever locale changes (called on first build too)
    _initializeTts();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.dispose();
    flutterTts.stop();
    _imageLabeler.close();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    final locale = Localizations.localeOf(context).languageCode;
    final ttsLang = _localeToTtsLang[locale] ?? 'en-IN';

    await flutterTts.setLanguage(ttsLang);
    await flutterTts.setPitch(1.05);
    await flutterTts.setVolume(1.0);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.awaitSpeakCompletion(true);

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted && !_isDisposed) {
      final l10n = AppLocalizations.of(context)!;
      await flutterTts.speak(l10n.objectDetectionReady);
    }
  }

  void toggleCamera() {
    if (_controller == null) return;
    final lensDir = _controller!.description.lensDirection;
    CameraDescription newDesc = widget.cameras.firstWhere(
          (desc) =>
      desc.lensDirection ==
          (lensDir == CameraLensDirection.front
              ? CameraLensDirection.back
              : CameraLensDirection.front),
    );
    initializeCamera(newDesc);
  }

  void initializeCamera(CameraDescription? description) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      description ?? widget.cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (!mounted) return;
      await _controller!.setFocusMode(FocusMode.auto);
      setState(() {});
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  /// Normalise a raw ML Kit label so human variants are unified.
  String _normaliseLabel(String raw) {
    final lower = raw.toLowerCase().trim();
    if (_humanLabels.contains(lower)) return 'Person'; // ← unified human label
    // Capitalise first letter for natural speech
    return raw[0].toUpperCase() + raw.substring(1);
  }

  Future<void> _captureAndDetect() async {
    if (_isDetecting ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;

    // Re-apply TTS language in case user switched locale mid-session
    final locale = Localizations.localeOf(context).languageCode;
    final ttsLang = _localeToTtsLang[locale] ?? 'en-IN';
    await flutterTts.setLanguage(ttsLang);

    setState(() => _isDetecting = true);

    try {
      await flutterTts.speak(l10n.capturingImage);

      final XFile photo = await _controller!.takePicture();

      await flutterTts.speak(l10n.processingImage);

      final inputImage = InputImage.fromFilePath(photo.path);
      final List<ImageLabel> labels =
      await _imageLabeler.processImage(inputImage);

      if (_isDisposed || !mounted) return;

      if (labels.isNotEmpty) {
        // De-duplicate after normalisation (e.g. "Man" + "Person" → one "Person")
        final seen = <String>{};
        final foundLabels = <String>[];
        int highestConfidence = 0;

        for (final label in labels) {
          final normalised = _normaliseLabel(label.label);
          if (seen.add(normalised)) {
            foundLabels.add(normalised);
            if (foundLabels.length == 1) {
              highestConfidence = (label.confidence * 100).toInt();
            }
          }
          if (foundLabels.length == 2) break;
        }

        final objectsSpoken = foundLabels.join(' and ');
        await flutterTts.speak('$objectsSpoken with $highestConfidence percent confidence');
      } else {
        await flutterTts.speak(l10n.noObjectsFound);
      }
    } catch (e) {
      debugPrint("Inference Error: $e");
      if (mounted) await flutterTts.speak(l10n.errorProcessing);
    } finally {
      if (mounted && !_isDisposed) {
        setState(() => _isDetecting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar:
        AppBar(title: Text(localizations?.objectDetection ?? "Detection")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar:
      AppBar(title: Text(localizations?.objectDetection ?? "Detection")),
      body: GestureDetector(
        onTap: _isDetecting ? null : _captureAndDetect,
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(_controller!),
            ),
            if (_isDetecting)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            Positioned(
              top: 20,
              right: 20,
              child: Semantics(
                button: true,
                label:
                localizations?.switchCameraLabel ?? "Switch Camera",
                child: FloatingActionButton(
                  heroTag: "switch_cam",
                  mini: true,
                  onPressed: toggleCamera,
                  child:
                  const Icon(Icons.flip_camera_ios, semanticLabel: null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}