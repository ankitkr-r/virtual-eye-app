import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:virtual_eye/color_detection/color_detection_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:camera/camera.dart';
import 'package:virtual_eye/Widget/popup_for_language_selection.dart';
import 'package:virtual_eye/Widget/ve_snack_bar.dart';
import 'package:virtual_eye/chatbot/chat_home.dart';
import 'package:virtual_eye/chatbot/chat_view_model.dart';
import 'package:virtual_eye/home_Page_flutter/home_screen_bottom.dart';
import 'package:virtual_eye/home_Page_flutter/services_bottom.dart';
import 'package:virtual_eye/login_signup/login_page.dart';
import 'package:virtual_eye/main.dart';
import 'package:virtual_eye/services/authentication.dart';
import '../object_detection/ml_kit_object_detection.dart'; // Verified Import
import 'package:virtual_eye/l10n/app_localizations.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myIndex = 0;
  List<CameraDescription>? cameras;

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  bool _isListening = false;
  String _command = '';
  String selectedLanguage = "en";

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
    initializeCameras();
    _initSpeech();
  }

  @override
  void dispose() {
    flutterTts.stop();
    _speechToText.stop();
    super.dispose();
  }

  Future<void> initializeCameras() async {
    try {
      cameras = await availableCameras();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (val) => setState(() => _isListening = false),
    );
    if (!available && mounted) {
      VESnackBar.errorShow(context, "Speech recognition unavailable");
    }
  }

  // --- VOICE LOGIC ---
  Future<void> _handleVoiceTap() async {
    if (_isListening) {
      _stopListening();
    } else {
      await _playListeningInstruction();
      _startListening();
    }
  }

  void _startListening() async {
    setState(() => _isListening = true);
    await _speechToText.listen(onResult: (val) {
      setState(() {
        _command = val.recognizedWords.toLowerCase();
        if (val.finalResult) {
          _stopListening(); // Stop listening before processing to prevent audio feedback loops
          _handleVoiceCommand(_command);
        }
      });
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  void _handleVoiceCommand(String command) {
    final loc = AppLocalizations.of(context);
    final String spokenText = command.toLowerCase();

    // 1. Services
    if (spokenText.contains(loc?.services?.toLowerCase() ?? 'services') || spokenText.contains('service')) {
      setState(() => myIndex = 1);
    }

    // 2. Home
    else if (spokenText.contains(loc?.home?.toLowerCase() ?? 'home') || spokenText.contains('home')) {
      setState(() => myIndex = 0);
    }

    // 3. Music
    else if (spokenText.contains(loc?.voiceCommandOpenMusic?.toLowerCase() ?? 'music') || spokenText.contains('music')) {
      _openDefaultMusicPlayer(loc?.ttsOpeningMusic ?? "Opening your music player.");
    }

    // 4. Object Detection
    else if (spokenText.contains(loc?.objectDetection?.toLowerCase() ?? 'detection') ||
        spokenText.contains('object') ||
        spokenText.contains('identify')) {
      if (cameras != null) {
        // FIXED: Route now points to MLKitObjectDetection instead of RealTimeObjectDetection
        Navigator.push(context, MaterialPageRoute(builder: (context) => MLKitObjectDetection(cameras: cameras!)));
      }
    }

    // 5. Map
    else if (spokenText.contains(loc?.map?.toLowerCase() ?? 'map') || spokenText.contains('map') || spokenText.contains('location')) {
      MapUtils.openMap(25.31668000, 83.01041000);
    }

    // 6. Chatbot
    else if (spokenText.contains(loc?.chatbot?.toLowerCase() ?? 'chatbot') ||
        spokenText.contains('chat') ||
        spokenText.contains('assistant')) {
      final chatViewModel = ChatViewModel();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatHome(viewModel: chatViewModel))
      );
    }

    // 7. Color Detection
    else if (spokenText.contains('color') ||
        spokenText.contains('colour') ||
        spokenText.contains('रंग') ||
        spokenText.contains('颜色')) {
      if (cameras != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DominantColorScreen(cameras: cameras!)));
      }
    } // FIXED: Added this missing closing brace that was breaking the code block

    // 8. Logout
    else if (spokenText.contains(loc?.logOut?.toLowerCase().replaceAll(' ', '') ?? 'logout') ||
        spokenText.contains('logout') ||
        spokenText.contains('log out')) {
      _showLogoutConfirmationDialog();
    }
  }

  Future<void> _openDefaultMusicPlayer(String ttsAnnouncement) async {
    await flutterTts.speak(ttsAnnouncement);
    await Future.delayed(const Duration(milliseconds: 500));

    Uri uri;
    if (Platform.isAndroid) {
      uri = Uri.parse("intent:#Intent;action=android.intent.action.MUSIC_PLAYER;end");
    } else {
      uri = Uri.parse("music://");
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(Uri.parse('https://music.youtube.com/'), mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Error launching music player: $e");
      if (mounted) {
        VESnackBar.errorShow(context, "Could not open music player");
      }
    }
  }

  // --- LANGUAGE LOGIC ---
  Future<void> onSubmit(String changedLanguage) async {
    Navigator.pop(context);

    try {
      var userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        FirebaseFirestore.instance.doc('users/$userId').update({
          "languageCode": changedLanguage
        });
      }

      localeNotifier.value = Locale(changedLanguage);

      setState(() {
        selectedLanguage = changedLanguage;
      });

      print("Language updated to: $changedLanguage");

    } catch (error) {
      VESnackBar.errorShow(context, "Error updating language");
    }
  }

  Future<void> _showLanguageSelectionDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PopUpForLanguageSelection(
          onSubmit: onSubmit,
          initialLanguage: AppLocalizations.of(context)?.localeName ?? "en",
          changingLanguage: false,
        );
      },
    );
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final loc = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(loc?.confirmLogout ?? "Logout?"),
          content: Text(loc?.logoutConfirmationMessage ?? "Are you sure?"),
          actions: <Widget>[
            TextButton(
              child: Text(loc?.no ?? "No"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(loc?.yes ?? "Yes"),
              onPressed: () async {
                await AuthServices().signOut();
                if (mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                }
              },
            ),
          ],
        );
      },
    );
  }

  get localisation => AppLocalizations.of(context);
  String get getLanguageType => localisation?.localeName ?? "en";

  Future<void> _playListeningInstruction() async {
    String lang = getLanguageType;
    if(lang == "zh") {
      await flutterTts.setLanguage("cmn-Hant-TW");
    } else {
      await flutterTts.setLanguage("$lang-IN");
    }
    await flutterTts.speak(localisation?.listening ?? "Listening");
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    List<Widget> currentScreens = [];
    if (cameras != null) {
      currentScreens = [
        HomeScreenBottom(
            cameras: cameras!,
            startListening: _startListening,
            stopListening: _stopListening,
            selectedLanguage: selectedLanguage
        ),
        const ServicesBottom(showBackButton: false),
        Container(),
        Container()
      ];
    }

    return GestureDetector(
      onTap: _handleVoiceTap,
      // Wrap the Scaffold body in an ExcludeSemantics if needed, but Flutter handles BottomNavBar well natively.
      child: Scaffold(
        body: cameras == null
            ? const Center(child: CircularProgressIndicator())
            : currentScreens[myIndex],

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF404165),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          currentIndex: (myIndex > 1) ? 0 : myIndex,
          onTap: (index) {
            if (index == 0 || index == 1) {
              setState(() => myIndex = index);
            } else if (index == 2) {
              _showLanguageSelectionDialog();
            } else if (index == 3) {
              _showLogoutConfirmationDialog();
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: localizations?.home ?? "Home"
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.phone),
                label: localizations?.services ?? "Services"
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.language),
                label: localizations?.language ?? "Language"
            ),
            BottomNavigationBarItem(
                icon: const Icon(Icons.logout),
                label: localizations?.logOut ?? "Logout"
            ),
          ],
        ),
      ),
    );
  }
}