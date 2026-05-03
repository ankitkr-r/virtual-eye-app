import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:speech_to_text/speech_to_text.dart'; // Full package name
import 'package:flutter_tts/flutter_tts.dart';
import 'package:virtual_eye/Widget/ve_snack_bar.dart'; // Import Text-to-Speech package

class VoiceFingerprintAuth {
  final LocalAuthentication auth = LocalAuthentication();
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();

  bool isListening = false;

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void startListening(Function(String) onResult) async {
    bool available = await speechToText.initialize();
    if (available) {
      isListening = true;
      speechToText.listen(onResult: (result) {
        onResult(result.recognizedWords); // Get the recognized words as string
      });
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }

  void stopListening() {
    speechToText.stop();
    isListening = false;
  }

  Future<bool> authenticate(BuildContext context) async {
    await speak("Apply your fingerprint to authenticate"); // Speak when starting authentication
    bool authenticated = false;
    try {
      bool canCheckBiometrics = await auth.canCheckBiometrics;
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!canCheckBiometrics || !isDeviceSupported) {
        VESnackBar.errorShow(context, 'Biometric authentication not available.');
        return false;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Apply your fingerprint to authenticate',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }

    if (authenticated) {
      return true; // Authentication successful
    } else {
      VESnackBar.errorShow(context, 'Authentication failed');
      return false;
    }
  }

  // Method to announce the initial prompt when the app starts
  Future<void> announceInitialPrompt() async {
    await speak("Click anywhere and say fingerprint for authentication");
    // Only start listening after the TTS is done
  }
}


