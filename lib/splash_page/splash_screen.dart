import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_eye/home_Page_flutter/homepage.dart';
import 'package:virtual_eye/login_signup/login_page.dart';
import 'package:virtual_eye/main.dart';
import 'package:virtual_eye/utils/connection_status_singleton.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final isLoading = true;
  final connectionStatus = ConnectionStatusSingleton.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('images/app_logo.png'))
          ]
      )
    );
  }

  @override
  void initState() {
    super.initState();
    connectionStatus.initialize();
    connectionStatus.myStream.listen((event) {
      splashLoad();
    });
  }

  void navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    ));
  }

  void navigateToLoginScreen() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ));
  }

  splashLoad() async {
    if (connectionStatus.hasConnection) {
      if (FirebaseAuth.instance.currentUser != null) {
        var userId = FirebaseAuth.instance.currentUser!.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.doc('users/$userId').get();
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          if (data.containsKey('languageCode')) // NEW (Fix)
            localeNotifier.value = Locale(data['languageCode']);
        }
        navigateToHomeScreen();
      } else {
        navigateToLoginScreen();
      }
    }
  }
}