import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DominantColorScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const DominantColorScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _DominantColorScreenState createState() => _DominantColorScreenState();
}

class _DominantColorScreenState extends State<DominantColorScreen> {
  late CameraController _controller;
  final FlutterTts _flutterTts = FlutterTts();

  bool _isProcessing = false;
  String _topColorInfo = "Analyzing...";
  List<MapEntry<String, double>> _colorPercentages = [];
  String _lastSpokenColor = "";

  // Expanded color dictionary for better blind assistance
  final Map<String, Color> _knownColors = {
    "Red": Colors.red,
    "Green": Colors.green,
    "Blue": Colors.blue,
    "Yellow": Colors.yellow,
    "Orange": Colors.orange,
    "Purple": Colors.purple,
    "Pink": Colors.pink,
    "Brown": Colors.brown,
    "Black": Colors.black,
    "White": Colors.white,
    "Grey": Colors.grey,
    "Cyan": Colors.cyan,
    "Maroon": const Color(0xFF800000),
    "Navy": const Color(0xFF000080),
  };

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.cameras[0],
      ResolutionPreset.low, // Lower resolution for faster processing
      enableAudio: false,
    );

    await _controller.initialize();
    if (!mounted) return;
    setState(() {});

    _controller.startImageStream((CameraImage image) {
      if (_isProcessing) return;
      _isProcessing = true;
      _processCameraImage(image);
    });
  }

  void _processCameraImage(CameraImage image) {
    // Histogram to store frequency of color names
    Map<String, int> colorHistogram = {};
    int totalPixelsSampled = 0;
    const int step = 15; // Sample every 15th pixel for performance

    final int width = image.width;
    final int height = image.height;

    // Process YUV420 (Common for Android)
    for (int y = 0; y < height; y += step) {
      for (int x = 0; x < width; x += step) {
        final int index = y * width + x;
        final int uvIndex = (y ~/ 2) * (image.planes[1].bytesPerRow) + (x ~/ 2) * (image.planes[1].bytesPerPixel!);

        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];

        // Convert YUV to RGB
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);

        String colorName = _getNearestColorName(r, g, b);
        colorHistogram[colorName] = (colorHistogram[colorName] ?? 0) + 1;
        totalPixelsSampled++;
      }
    }

    // Calculate Percentages
    var sortedList = colorHistogram.entries.map((entry) {
      return MapEntry(entry.key, (entry.value / totalPixelsSampled) * 100);
    }).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (mounted) {
      setState(() {
        _colorPercentages = sortedList.take(3).toList(); // Keep top 3
        _topColorInfo = _colorPercentages.isNotEmpty
            ? "${_colorPercentages[0].key} (${_colorPercentages[0].value.toStringAsFixed(0)}%)"
            : "Unknown";
      });

      // Voice logic: Speak if a color is dominant (>40%) and changed
      if (_colorPercentages.isNotEmpty) {
        String mainColor = _colorPercentages[0].key;
        double percentage = _colorPercentages[0].value;

        if (mainColor != _lastSpokenColor && percentage > 45) {
          _flutterTts.speak("Mostly $mainColor");
          _lastSpokenColor = mainColor;
        }
      }
    }

    // Delay next frame to save battery/CPU
    Future.delayed(const Duration(milliseconds: 800), () {
      _isProcessing = false;
    });
  }

  String _getNearestColorName(int r, int g, int b) {
    String closestName = "Unknown";
    double minDistance = double.infinity;

    _knownColors.forEach((name, color) {
      double distance = sqrt(
          pow(r - color.red, 2) +
              pow(g - color.green, 2) +
              pow(b - color.blue, 2)
      );
      if (distance < minDistance) {
        minDistance = distance;
        closestName = name;
      }
    });
    return closestName;
  }

  @override
  void dispose() {
    _controller.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Virtual Eye: Color Detector")),
      body: Stack(
        children: [
          CameraPreview(_controller),

          // Result Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _topColorInfo,
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ..._colorPercentages.skip(1).map((e) => Text(
                    "${e.key}: ${e.value.toStringAsFixed(0)}%",
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}