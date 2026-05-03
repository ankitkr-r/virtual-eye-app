import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:virtual_eye/Widget/ve_snack_bar.dart';
import 'package:virtual_eye/l10n/app_localizations.dart';
import 'package:virtual_eye/main.dart';
// Removed: Color Detection import

class ServicesBottom extends StatefulWidget {
  final bool showBackButton;
  const ServicesBottom({super.key, this.showBackButton = true});

  @override
  State<ServicesBottom> createState() => _ServicesBottomState();
}

class _ServicesBottomState extends State<ServicesBottom> {
  // Contacts Data
  List<Map<String, String>> getContacts(BuildContext context) {
    return [
      {'name': AppLocalizations.of(context)?.police ?? "Police", 'number': '112'},
      {'name': AppLocalizations.of(context)?.fireDepartment ?? "Fire Dept", 'number': '+911234567890'},
      {'name': AppLocalizations.of(context)?.ambulance ?? "Ambulance", 'number': '+919876543210'},
      {'name': AppLocalizations.of(context)?.ngo ?? "NGO", 'number': '+919327547207'},
    ];
  }

  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  void showError(String errorMessage) {
    VESnackBar.errorShow(context, errorMessage);
  }

  get localisation => AppLocalizations.of(navigatorKey.currentContext!);
  String get getLanguageType => localisation?.localeName ?? "en";

  Future<void> setLanguage() async {
    String selectedLanguage = getLanguageType;
    if(selectedLanguage == "zh") {
      await _flutterTts.setLanguage("cmn-Hant-TW");
    } else {
      await _flutterTts.setLanguage("$selectedLanguage-IN");
    }
  }

  Future<bool> isLanguageAvailable() async {
    String selectedLanguage = getLanguageType;
    if(selectedLanguage == "zh") {
      return await _flutterTts.isLanguageAvailable("cmn-Hant-TW");
    } else {
      return await _flutterTts.isLanguageAvailable("$selectedLanguage-IN");
    }
  }

  Future<void> _initializeTTS() async {
    try {
      setLanguage();
      await _flutterTts.setPitch(1);
      await _playServiceMessage();
    } catch (e) {
      debugPrint("Error initializing TTS: $e");
    }
  }

  Future<void> _playServiceMessage() async {
    try {
      bool isAvailable = await isLanguageAvailable();
      if (isAvailable) {
        await _flutterTts.speak(localisation?.welcomeToServices ?? "");
      }
    } catch (e) {
      debugPrint("Error playing welcome message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            localizations?.services ?? "Services",
            style: const TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF404165),
          automaticallyImplyLeading: widget.showBackButton
      ),
      // REVERTED: Directly returning ListView.builder (No Column, No Card)
      body: ListView.builder(
        itemCount: getContacts(context).length,
        itemBuilder: (context, index) {
          final contact = getContacts(context)[index];
          return ListTile(
            title: Text(contact['name'] ?? ""),
            subtitle: Text(contact['number']!),
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://tse1.mm.bing.net/th?id=OIP.8um7Q6EtY4wdtOT-DS0q2gHaHa&pid=Api&P=0&h=180',
              ),
            ),
            trailing: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
              child: Text(localizations?.call ?? "Call"),
              onPressed: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: contact['number']);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  showError(localizations?.phoneDialerError ?? "Cannot dial");
                }
              },
            ),
          );
        },
      ),
    );
  }
}