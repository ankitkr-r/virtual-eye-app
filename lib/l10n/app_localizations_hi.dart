// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get home => 'मुख्य पृष्ठ';

  @override
  String get virtualEye => 'वर्चुअल आई';

  @override
  String get services => 'सेवाएँ';

  @override
  String get language => 'भाषा';

  @override
  String get logOut => 'लॉग आउट';

  @override
  String get colorDetector => 'रंग पहचान';

  @override
  String get welcomeMessage =>
      'हमारे ऐप में आपका स्वागत है। कमांड देने के लिए कहीं भी क्लिक करें। ऑब्जेक्ट डिटेक्शन, चैटबॉट, मैप, सेवाएं, संगीत और लॉगआउट जैसे विकल्पों का उपयोग करने के लिए पहले \'ओपन\' बोलें। जैसे कि \'ओपन चैटबॉट\'।';

  @override
  String get headingDetail =>
      'किसी भी स्थान पर क्लिक करें और कमांड दें जैसे \'ऑब्जेक्ट डिटेक्शन खोलें\' या \'नक्शा खोलें\'';

  @override
  String get holdScreenMessage => 'स्क्रीन को दबाए रखें और प्रश्न पूछें।';

  @override
  String get listening => 'बोलें...';

  @override
  String get recordingStopped => 'रिकॉर्डिंग बंद हो गई है।';

  @override
  String get objectDetection => 'ऑब्जेक्ट डिटेक्शन';

  @override
  String get realTimeObjectDetection => 'वास्तविक समय वस्तु पहचान';

  @override
  String get map => 'नक्शा';

  @override
  String get chatbot => 'चैटबॉट';

  @override
  String get call => 'कॉल करें';

  @override
  String get police => 'पुलिस';

  @override
  String get fireDepartment => 'फायर विभाग';

  @override
  String get ambulance => 'एम्बुलेंस';

  @override
  String get ngo => 'एनजीओ';

  @override
  String get welcomeToServices => 'सेवाओं में आपका स्वागत है।';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get changeLanguage => 'भाषा बदलें';

  @override
  String get voiceAssistantChatbot => 'वॉयस असिस्टेंट चैटबोट';

  @override
  String get aiChatbot => 'एआई चैटबोट';

  @override
  String get smartAssistantChatbot => 'मैं एक स्मार्ट असिस्टेंट चैटबोट हूँ';

  @override
  String get chatbotTitle => 'वर्चुअल आई असिस्टेंट';

  @override
  String get userSaid => 'आपने कहा';

  @override
  String get aiSaid => 'वर्चुअल आई ने कहा';

  @override
  String get aiTypingLabel => 'वर्चुअल आई टाइप कर रहा है...';

  @override
  String get chatInputHint => 'अपना संदेश टाइप करें...';

  @override
  String get sendButtonLabel => 'संदेश भेजें';

  @override
  String get confirmLogout => 'लॉगआउट की पुष्टि करें';

  @override
  String get logoutConfirmationMessage =>
      'क्या आप वाकई लॉग आउट करना चाहते हैं?';

  @override
  String get no => 'नहीं';

  @override
  String get yes => 'हाँ';

  @override
  String get internetOffMessage => 'लगता है कि आप इंटरनेट से कनेक्ट नहीं हैं।';

  @override
  String get turnOnInternet => 'इंटरनेट चालू करें';

  @override
  String get phoneDialerError => 'फोन डायलर लॉन्च नहीं किया जा सका';

  @override
  String get voiceCommandOpenMusic => 'संगीत खोलो';

  @override
  String get ttsOpeningMusic => 'म्यूजिक प्लेयर खोल रही हूँ।';

  @override
  String get objectDetectionReady =>
      'ऑब्जेक्ट डिटेक्शन तैयार है। कैप्चर करने के लिए स्क्रीन पर कहीं भी टैप करें।';

  @override
  String get switchCameraLabel => 'कैमरा बदलें';

  @override
  String get captureButtonLabel => 'फोटो लें';

  @override
  String get captureButtonHint =>
      'फोटो लेने और वस्तुओं को पहचानने के लिए दो बार टैप करें';

  @override
  String get captureAndDetect => 'फोटो लें और पहचानें';

  @override
  String get capturingImage => 'फोटो ले रहा है...';

  @override
  String get processingImage => 'छवि की जांच हो रही है...';

  @override
  String get noObjectsFound =>
      'कोई वस्तु नहीं मिली। कृपया कैमरे को किसी अन्य वस्तु की ओर करें।';

  @override
  String get errorProcessing =>
      'क्षमा करें, वस्तुओं को पहचानने में कोई समस्या हुई। कृपया पुनः प्रयास करें।';

  @override
  String objectDetectedFound(String label, int confidence) {
    return 'मुझे $confidence प्रतिशत विश्वास के साथ $label दिख रहा है।';
  }
}
