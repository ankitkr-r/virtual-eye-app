import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('zh')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @virtualEye.
  ///
  /// In en, this message translates to:
  /// **'Virtual Eye'**
  String get virtualEye;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @colorDetector.
  ///
  /// In en, this message translates to:
  /// **'Color Detector'**
  String get colorDetector;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our app. Tap anywhere to give a command. You have to say \'open\' before the option of object detection, chatbot, map, services, music, logout. Example: open chatbot.'**
  String get welcomeMessage;

  /// No description provided for @headingDetail.
  ///
  /// In en, this message translates to:
  /// **'Tap anywhere to give a command, such as \'open object detection\' or \'open map\''**
  String get headingDetail;

  /// No description provided for @holdScreenMessage.
  ///
  /// In en, this message translates to:
  /// **'Hold the screen to ask a question.'**
  String get holdScreenMessage;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @recordingStopped.
  ///
  /// In en, this message translates to:
  /// **'Recording stopped.'**
  String get recordingStopped;

  /// No description provided for @objectDetection.
  ///
  /// In en, this message translates to:
  /// **'Object Detection'**
  String get objectDetection;

  /// No description provided for @realTimeObjectDetection.
  ///
  /// In en, this message translates to:
  /// **'Real-time Object Detection'**
  String get realTimeObjectDetection;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get chatbot;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get police;

  /// No description provided for @fireDepartment.
  ///
  /// In en, this message translates to:
  /// **'Fire Department'**
  String get fireDepartment;

  /// No description provided for @ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get ambulance;

  /// No description provided for @ngo.
  ///
  /// In en, this message translates to:
  /// **'NGO'**
  String get ngo;

  /// No description provided for @welcomeToServices.
  ///
  /// In en, this message translates to:
  /// **'Welcome to services.'**
  String get welcomeToServices;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @voiceAssistantChatbot.
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant Chatbot'**
  String get voiceAssistantChatbot;

  /// No description provided for @aiChatbot.
  ///
  /// In en, this message translates to:
  /// **'AI Chatbot'**
  String get aiChatbot;

  /// No description provided for @smartAssistantChatbot.
  ///
  /// In en, this message translates to:
  /// **'I am a smart assistant chatbot'**
  String get smartAssistantChatbot;

  /// No description provided for @chatbotTitle.
  ///
  /// In en, this message translates to:
  /// **'Virtual Eye Assistant'**
  String get chatbotTitle;

  /// No description provided for @userSaid.
  ///
  /// In en, this message translates to:
  /// **'You said'**
  String get userSaid;

  /// No description provided for @aiSaid.
  ///
  /// In en, this message translates to:
  /// **'Virtual Eye said'**
  String get aiSaid;

  /// No description provided for @aiTypingLabel.
  ///
  /// In en, this message translates to:
  /// **'Virtual Eye is typing...'**
  String get aiTypingLabel;

  /// No description provided for @chatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get chatInputHint;

  /// No description provided for @sendButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get sendButtonLabel;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @logoutConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmationMessage;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @internetOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Looks like you are not connected to the internet.'**
  String get internetOffMessage;

  /// No description provided for @turnOnInternet.
  ///
  /// In en, this message translates to:
  /// **'Turn on internet'**
  String get turnOnInternet;

  /// No description provided for @phoneDialerError.
  ///
  /// In en, this message translates to:
  /// **'Could not launch phone dialer'**
  String get phoneDialerError;

  /// No description provided for @voiceCommandOpenMusic.
  ///
  /// In en, this message translates to:
  /// **'open music'**
  String get voiceCommandOpenMusic;

  /// No description provided for @ttsOpeningMusic.
  ///
  /// In en, this message translates to:
  /// **'Opening your music player.'**
  String get ttsOpeningMusic;

  /// No description provided for @objectDetectionReady.
  ///
  /// In en, this message translates to:
  /// **'Object detection is ready. Tap anywhere on the screen to capture and detect objects.'**
  String get objectDetectionReady;

  /// No description provided for @switchCameraLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch Camera'**
  String get switchCameraLabel;

  /// No description provided for @captureButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get captureButtonLabel;

  /// No description provided for @captureButtonHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to take a photo and detect objects'**
  String get captureButtonHint;

  /// No description provided for @captureAndDetect.
  ///
  /// In en, this message translates to:
  /// **'Capture & Detect'**
  String get captureAndDetect;

  /// No description provided for @capturingImage.
  ///
  /// In en, this message translates to:
  /// **'Taking photo...'**
  String get capturingImage;

  /// No description provided for @processingImage.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get processingImage;

  /// No description provided for @noObjectsFound.
  ///
  /// In en, this message translates to:
  /// **'No objects detected. Please try pointing the camera at a different object.'**
  String get noObjectsFound;

  /// No description provided for @errorProcessing.
  ///
  /// In en, this message translates to:
  /// **'Sorry, there was a problem detecting objects. Please try again.'**
  String get errorProcessing;

  /// No description provided for @objectDetectedFound.
  ///
  /// In en, this message translates to:
  /// **'I see {label} with confidence {confidence} percent.'**
  String objectDetectedFound(String label, int confidence);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
