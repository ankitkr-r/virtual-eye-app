// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get home => '首頁';

  @override
  String get virtualEye => '虛擬之眼';

  @override
  String get services => '服務';

  @override
  String get language => '語言';

  @override
  String get logOut => '登出';

  @override
  String get colorDetector => '顏色偵測器';

  @override
  String get welcomeMessage =>
      '歡迎使用我們的 App。點擊螢幕任何位置以發出指令。在選擇物體偵測、聊天機器人、地圖、服務、音樂和登出等選項前，請先說「開啟」。例如：開啟聊天機器人。';

  @override
  String get headingDetail => '點擊任意位置來給予指令，例如「開啟物體偵測」、「開啟地圖」';

  @override
  String get holdScreenMessage => '按住螢幕以提問。';

  @override
  String get listening => '正在聆聽...';

  @override
  String get recordingStopped => '錄音已經停止。';

  @override
  String get objectDetection => '物體偵測';

  @override
  String get realTimeObjectDetection => '即時物體偵測';

  @override
  String get map => '地圖';

  @override
  String get chatbot => '聊天機器人';

  @override
  String get call => '撥打電話';

  @override
  String get police => '警察';

  @override
  String get fireDepartment => '消防局';

  @override
  String get ambulance => '救護車';

  @override
  String get ngo => '非政府組織';

  @override
  String get welcomeToServices => '歡迎使用服務。';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get changeLanguage => '更改語言';

  @override
  String get voiceAssistantChatbot => '語音助理聊天機器人';

  @override
  String get aiChatbot => '人工智慧聊天機器人';

  @override
  String get smartAssistantChatbot => '我是一個智慧助理聊天機器人';

  @override
  String get chatbotTitle => '虛擬之眼助手';

  @override
  String get userSaid => '您說';

  @override
  String get aiSaid => '虛擬之眼說';

  @override
  String get aiTypingLabel => '虛擬之眼正在輸入...';

  @override
  String get chatInputHint => '輸入您的訊息...';

  @override
  String get sendButtonLabel => '發送訊息';

  @override
  String get confirmLogout => '確認登出';

  @override
  String get logoutConfirmationMessage => '您確定要登出嗎？';

  @override
  String get no => '否';

  @override
  String get yes => '是';

  @override
  String get internetOffMessage => '看起來您尚未連接到網際網路。';

  @override
  String get turnOnInternet => '開啟網際網路';

  @override
  String get phoneDialerError => '無法啟動電話撥號器';

  @override
  String get voiceCommandOpenMusic => '開啟音樂';

  @override
  String get ttsOpeningMusic => '正在開啟音樂播放器。';

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
