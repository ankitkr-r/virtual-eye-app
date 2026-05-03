import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Added only this import
import 'package:virtual_eye/splash_page/splash_screen.dart';
import 'package:virtual_eye/l10n/app_localizations.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// --- 1. GLOBAL LOCALE NOTIFIER (The Fix) ---
// This variable controls the language for the whole app.
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Added only this line to load your hidden Gemini key securely
  await dotenv.load(fileName: ".env");

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCT9W6uf0cD-Qat3b2WaTdWgsSbcPtPDu4',
        appId: '1:586829411860:web:860537265a60461c161901',
        messagingSenderId: '586829411860',
        projectId: 'virtual-eye-ankit-2025',
        authDomain: 'virtual-eye-ankit-2025.firebaseapp.com',
        storageBucket: 'virtual-eye-ankit-2025.firebasestorage.app',
        measurementId: 'G-BL6Y78FJ2Z',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  if (kIsWeb) {
    try {
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
    } catch (e) {
      debugPrint("Persistence warning: $e");
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- 2. LISTEN TO LANGUAGE CHANGES ---
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          title: 'Virtual Eye',

          // Connect the locale here
          locale: locale,

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('hi'), // Hindi
            Locale('zh'), // Chinese
          ],
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}