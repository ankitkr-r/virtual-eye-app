// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get virtualEye => 'Virtual Eye';

  @override
  String get services => 'Services';

  @override
  String get language => 'Language';

  @override
  String get logOut => 'Log Out';

  @override
  String get colorDetector => 'Color Detector';

  @override
  String get welcomeMessage =>
      'Welcome to our app. Tap anywhere to give a command. You have to say \'open\' before the option of object detection, chatbot, map, services, music, logout. Example: open chatbot.';

  @override
  String get headingDetail =>
      'Tap anywhere to give a command, such as \'open object detection\' or \'open map\'';

  @override
  String get holdScreenMessage => 'Hold the screen to ask a question.';

  @override
  String get listening => 'Listening...';

  @override
  String get recordingStopped => 'Recording stopped.';

  @override
  String get objectDetection => 'Object Detection';

  @override
  String get realTimeObjectDetection => 'Real-time Object Detection';

  @override
  String get map => 'Map';

  @override
  String get chatbot => 'Chatbot';

  @override
  String get call => 'Call';

  @override
  String get police => 'Police';

  @override
  String get fireDepartment => 'Fire Department';

  @override
  String get ambulance => 'Ambulance';

  @override
  String get ngo => 'NGO';

  @override
  String get welcomeToServices => 'Welcome to services.';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get voiceAssistantChatbot => 'Voice Assistant Chatbot';

  @override
  String get aiChatbot => 'AI Chatbot';

  @override
  String get smartAssistantChatbot => 'I am a smart assistant chatbot';

  @override
  String get chatbotTitle => 'Virtual Eye Assistant';

  @override
  String get userSaid => 'You said';

  @override
  String get aiSaid => 'Virtual Eye said';

  @override
  String get aiTypingLabel => 'Virtual Eye is typing...';

  @override
  String get chatInputHint => 'Type your message...';

  @override
  String get sendButtonLabel => 'Send message';

  @override
  String get confirmLogout => 'Confirm Logout';

  @override
  String get logoutConfirmationMessage => 'Are you sure you want to log out?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get internetOffMessage =>
      'Looks like you are not connected to the internet.';

  @override
  String get turnOnInternet => 'Turn on internet';

  @override
  String get phoneDialerError => 'Could not launch phone dialer';

  @override
  String get voiceCommandOpenMusic => 'open music';

  @override
  String get ttsOpeningMusic => 'Opening your music player.';

  @override
  String get objectDetectionReady =>
      'Object detection is ready. Tap anywhere on the screen to capture and detect objects.';

  @override
  String get switchCameraLabel => 'Switch Camera';

  @override
  String get captureButtonLabel => 'Take Photo';

  @override
  String get captureButtonHint =>
      'Double tap to take a photo and detect objects';

  @override
  String get captureAndDetect => 'Capture & Detect';

  @override
  String get capturingImage => 'Taking photo...';

  @override
  String get processingImage => 'Processing image...';

  @override
  String get noObjectsFound =>
      'No objects detected. Please try pointing the camera at a different object.';

  @override
  String get errorProcessing =>
      'Sorry, there was a problem detecting objects. Please try again.';

  @override
  String objectDetectedFound(String label, int confidence) {
    return 'I see $label with confidence $confidence percent.';
  }
}
