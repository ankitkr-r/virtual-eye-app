import 'dart:io';

import 'package:flutter/foundation.dart';
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

  static const Set<String> _humanLabels = {
    'person', 'human', 'man', 'woman', 'boy', 'girl',
    'child', 'people', 'face', 'body', 'pedestrian',
    'selfie', 'portrait',
  };

  @override
  void initState() {
    super.initState();
    initializeCamera(null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeTts();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.dispose();
    flutterTts.stop();
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

  String _normaliseLabel(String raw) {
    final lower = raw.toLowerCase().trim();
    if (_humanLabels.contains(lower)) return 'Person';
    return raw[0].toUpperCase() + raw.substring(1);
  }

  Future<void> _captureAndDetect() async {
    if (_isDetecting ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    await flutterTts.setLanguage(_localeToTtsLang[locale] ?? 'en-IN');

    setState(() => _isDetecting = true);

    try {
      await flutterTts.speak(l10n.capturingImage);

      final XFile photo = await _controller!.takePicture();

      await flutterTts.speak(l10n.processingImage);

      // 🔥 THE MAGIC HAPPENS HERE: We send the photo to the background Chef!
      final List<ImageLabel> labels = await DetectionIsolate.processImageInIsolate(photo.path);

      if (_isDisposed || !mounted) return;

      if (labels.isNotEmpty) {
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
        appBar: AppBar(title: Text(localizations?.objectDetection ?? "Detection")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations?.objectDetection ?? "Detection")),
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
                label: localizations?.switchCameraLabel ?? "Switch Camera",
                child: FloatingActionButton(
                  heroTag: "switch_cam",
                  mini: true,
                  onPressed: toggleCamera,
                  child: const Icon(Icons.flip_camera_ios, semanticLabel: null),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// 🧠 THE BACKGROUND WORKER (THE CHEF)
// ──────────────────────────────────────────────────────────────────────────
class DetectionIsolate {
  static Future<List<ImageLabel>> processImageInIsolate(String imagePath) async {
    // compute() spawns a background thread so the UI doesn't freeze
    return await compute(_heavyObjectDetection, imagePath);
  }

  static Future<List<ImageLabel>> _heavyObjectDetection(String imagePath) async {
    final options = ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      // This heavy math happens off the main thread now
      return await imageLabeler.processImage(inputImage);
    } catch (e) {
      debugPrint("Background Thread Error: $e");
      return [];
    } finally {
      imageLabeler.close(); // Clean up memory
    }
  }
}