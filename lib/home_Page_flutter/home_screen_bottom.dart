import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:virtual_eye/chatbot/chat_home.dart';
import 'package:virtual_eye/chatbot/chat_view_model.dart';
import 'package:virtual_eye/home_Page_flutter/HomeButton.dart';
import 'package:virtual_eye/main.dart';
import 'package:virtual_eye/object_detection/ml_kit_object_detection.dart'; // Verified correct import
import 'package:virtual_eye/l10n/app_localizations.dart';
import 'package:virtual_eye/services/check_accessibility.dart';
import 'package:virtual_eye/color_detection/color_detection_screen.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    final Uri googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the map.';
    }
  }
}

class HomeScreenBottom extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final VoidCallback startListening;
  final VoidCallback stopListening;
  final String selectedLanguage;

  const HomeScreenBottom({
    super.key,
    required this.cameras,
    required this.startListening,
    required this.stopListening,
    required this.selectedLanguage,
  });

  @override
  _HomeScreenBottomState createState() => _HomeScreenBottomState();
}

class _HomeScreenBottomState extends State<HomeScreenBottom> {
  final FlutterTts _flutterTts = FlutterTts();
  bool isEnable = true;

  @override
  void initState() {
    super.initState();
    _playWelcomeMessage();
    _isAccessibilityEnabled();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _isAccessibilityEnabled() async {
    try {
      bool result = await AccessibilityChecker.isAccessibilityEnabled();
      if (mounted) setState(() => isEnable = result);
    } catch (e) {
      debugPrint("Error checking accessibility: $e");
    }
  }

  Future<void> _playWelcomeMessage() async {
    try {
      if (!mounted) return;
      final localization = AppLocalizations.of(navigatorKey.currentContext!);
      String langCode = localization?.localeName ?? "en";

      await _flutterTts.stop();

      if (langCode == "zh") {
        await _flutterTts.setLanguage("cmn-Hant-TW");
      } else if (langCode == "hi" || langCode == "en") {
        await _flutterTts.setLanguage("$langCode-IN");
      } else {
        await _flutterTts.setLanguage(langCode);
      }

      await _flutterTts.speak(localization?.welcomeMessage ?? "Welcome to Virtual Eye");
      await _flutterTts.awaitSpeakCompletion(true);
    } catch (e) {
      debugPrint("TTS Error: $e");
    }
  }

  Future<void> _openDefaultMusicPlayer() async {
    Uri uri = Platform.isAndroid
        ? Uri.parse("intent:#Intent;action=android.intent.action.MUSIC_PLAYER;end")
        : Uri.parse("music://");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse('https://music.youtube.com/'), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching music player: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final String objectText = localizations?.objectDetection ?? "Object Detection";
    final String mapText = localizations?.map ?? "Map";
    final String chatText = localizations?.chatbot ?? "Chatbot";
    final String colorText = localizations?.colorDetector ?? "Color Detector";
    final String musicText = localizations?.voiceCommandOpenMusic ?? "Music"; // Safely get music text

    if (widget.cameras == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        widget.stopListening();
        widget.startListening();
      },
      child: Scaffold(
        backgroundColor: Colors.white38,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Transform.rotate(
                    origin: const Offset(30, -60),
                    angle: 2.4,
                    child: Container(
                      margin: const EdgeInsets.only(left: 75, top: 40),
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(80),
                        gradient: const LinearGradient(
                          begin: Alignment.bottomLeft,
                          colors: [Color(0xffFD8BAB), Color(0xFF28265B)],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          localizations?.virtualEye ?? "Virtual Eye",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          localizations?.headingDetail ?? "AI Assistant for visually impaired",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Column(
                            children: [
                              // ROW 1: Object + Map
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CategoryW(
                                    image: 'images/object.jpg',
                                    text: objectText,
                                    color: Colors.white,
                                    isEnabled: isEnable,
                                    onDoubleTap: () async {
                                      await _flutterTts.stop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          // ---> UPDATED: Calling the renamed MLKitObjectDetection class <---
                                          builder: (context) =>
                                              MLKitObjectDetection(cameras: widget.cameras!),
                                        ),
                                      );
                                    },
                                  ),
                                  CategoryW(
                                    image: 'images/map-locator.png',
                                    text: mapText,
                                    color: Colors.white,
                                    isEnabled: isEnable,
                                    onDoubleTap: () async {
                                      await _flutterTts.stop();
                                      await MapUtils.openMap(25.31668000, 83.01041000);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // ROW 2: Chatbot + Color Detection
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CategoryW(
                                    image: 'images/chatbot.png',
                                    text: chatText,
                                    color: Colors.white,
                                    isEnabled: isEnable,
                                    onDoubleTap: () async {
                                      await _flutterTts.stop();
                                      final chatViewModel = ChatViewModel();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatHome(viewModel: chatViewModel),
                                        ),
                                      );
                                    },
                                  ),
                                  CategoryW(
                                    image: 'images/color-wheel.png',
                                    text: colorText,
                                    color: Colors.white,
                                    isEnabled: isEnable,
                                    onDoubleTap: () async {
                                      await _flutterTts.stop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DominantColorScreen(cameras: widget.cameras!),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // ROW 3: Music Player
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  CategoryW(
                                    image: 'images/music.png', // CRITICAL: Ensure this image exists in your assets!
                                    text: musicText,
                                    color: Colors.white,
                                    isEnabled: isEnable,
                                    onDoubleTap: () async {
                                      await _flutterTts.stop();
                                      await _openDefaultMusicPlayer();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}