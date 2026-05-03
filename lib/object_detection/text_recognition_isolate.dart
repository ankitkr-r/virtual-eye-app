import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognitionIsolate {

  static Future<String> processImageInIsolate(String imagePath) async {
    // compute runs the function on a separate background thread
    return await compute(_heavyTextRecognition, imagePath);
  }

  static Future<String> _heavyTextRecognition(String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      debugPrint("OCR Error: $e");
      return "";
    } finally {
      textRecognizer.close();
    }
  }
}