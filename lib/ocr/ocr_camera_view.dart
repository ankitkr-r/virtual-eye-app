import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../object_detection/text_recognition_isolate.dart';
class OcrCameraView extends StatefulWidget {
  const OcrCameraView({super.key});

  @override
  State<OcrCameraView> createState() => _OcrCameraViewState();
}

class _OcrCameraViewState extends State<OcrCameraView> {
  CameraController? _controller;
  final FlutterTts _flutterTts = FlutterTts();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller!.initialize();
    if (!mounted) return;
    setState(() {});

    // Voice guidance for the user
    await _flutterTts.speak("OCR mode active. Tap anywhere to read text in front of you.");
  }

  Future<void> _captureAndRead() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) return;

    setState(() => _isProcessing = true);
    await _flutterTts.speak("Scanning text...");

    try {
      // 1. Capture the image
      final XFile image = await _controller!.takePicture();

      // 2. Process it in our background Isolate
      final String recognizedText = await TextRecognitionIsolate.processImageInIsolate(image.path);

      // 3. Read it out loud
      if (recognizedText.trim().isEmpty) {
        await _flutterTts.speak("No text detected. Please try again.");
      } else {
        await _flutterTts.speak("I found the following text: $recognizedText");
      }
    } catch (e) {
      await _flutterTts.speak("Error reading text.");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GestureDetector(
      onTap: _captureAndRead, // Entire screen is a button
      child: Scaffold(
        appBar: AppBar(title: const Text("Read Text")),
        body: Stack(
          children: [
            CameraPreview(_controller!),
            if (_isProcessing)
              const Center(child: CircularProgressIndicator(color: Colors.white)),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Text(
                "Tap to Read",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24, backgroundColor: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}