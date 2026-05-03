import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:virtual_eye/Widget/button.dart';
import 'package:virtual_eye/Widget/ve_snack_bar.dart';
import 'package:virtual_eye/Widget/ve_text_form_field.dart';
import 'package:virtual_eye/home_Page_flutter/homepage.dart';
import 'package:virtual_eye/login_signup/fingerprint_auth.dart';
import 'package:virtual_eye/login_signup/signup.dart';
import 'package:virtual_eye/main.dart';
import 'package:virtual_eye/services/authentication.dart';
import 'package:virtual_eye/services/validator.dart';
import 'package:virtual_eye/services/check_accessibility.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool _passVisibility = true; // Changed to true so password is hidden by default
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final VoiceFingerprintAuth voiceFingerprintAuth = VoiceFingerprintAuth();
  bool isEnable = true;

  @override
  void initState() {
    super.initState();
    voiceFingerprintAuth.announceInitialPrompt();
    _isAccessibilityEnabled();
  }

  // WEB-SAFE ACCESSIBILITY CHECK
  Future<void> _isAccessibilityEnabled() async {
    if (kIsWeb) return;
    try {
      // Note: Make sure AccessibilityChecker is also updated for null safety if needed
      // bool accessible = await AccessibilityChecker.isAccessibilityEnabled();
      // if (mounted) setState(() => isEnable = accessible);
    } catch (e) {
      debugPrint("Accessibility check failed: $e");
    }
  }

  void loginUser() async {
    if (isLoading) return; // Prevent multiple clicks

    setState(() {
      isLoading = true;
      validateMode = AutovalidateMode.onUserInteraction;
    });

    FocusManager.instance.primaryFocus!.unfocus();

    try {
      if (_formKey.currentState!.validate()) {
        String res = await AuthServices().loginUser(
          email: emailController.text,
          password: passwordController.text,
        );

        if (res == "Success") {
          var userId = FirebaseAuth.instance.currentUser!.uid;

          // Try-Catch specific for Firestore to prevent hanging
          try {
            DocumentSnapshot userDoc = await FirebaseFirestore.instance.doc('users/$userId').get();
            if (userDoc.exists) {
              var data = userDoc.data() as Map<String, dynamic>;
              if (data.containsKey('languageCode') && mounted) {
                // Set the language from the database
// NEW (Fix)
                if (mounted) {
                  localeNotifier.value = Locale(data['languageCode']);
                }              }
            }
          } catch (firestoreError) {
            debugPrint("Firestore Warning: $firestoreError");
          }

          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        } else {
          if (mounted) VESnackBar.errorShow(context, res);
        }
      }
    } catch (e) {
      if (mounted) VESnackBar.errorShow(context, "Login Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void loginWithVoiceAndFingerprint() async {
    // If on web, voice auth might not work well, so we can skip or show message
    if (kIsWeb) return;

    try {
      voiceFingerprintAuth.startListening((String recognizedWords) async {
        if (recognizedWords.toLowerCase().contains('fingerprint')) {
          voiceFingerprintAuth.stopListening();
          bool isAuthenticated = await voiceFingerprintAuth.authenticate(context);
          if (isAuthenticated && mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        }
      });
    } catch (e) {
      if (mounted) VESnackBar.errorShow(context, 'Auth error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: loginWithVoiceAndFingerprint,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: SingleChildScrollView(
                    child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: height / 2.7,
                            child: Image.asset("images/login.jpg"),
                          ),
                          Form(
                              key: _formKey,
                              autovalidateMode: validateMode,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                      children: [
                                        VETextFormField(
                                            textEditingController: emailController,
                                            hintText: 'Enter Your Email',
                                            icon: Icons.person,
                                            suffixOnPressed: () {}, // Fixed null check if required
                                            textInputType: TextInputType.emailAddress,
                                            validator: Validator.validEmail
                                        ),
                                        const SizedBox(height: 10),
                                        VETextFormField(
                                            validator: Validator.validatePassword,
                                            textEditingController: passwordController,
                                            hintText: 'Enter Your Password',
                                            textInputType: TextInputType.text,
                                            icon: Icons.lock,
                                            passVisibility: _passVisibility,
                                            showSuffixIcon: true,
                                            suffixOnPressed: () {
                                              setState(() => _passVisibility = !_passVisibility);
                                            }
                                        )
                                      ]
                                  )
                              )
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Forget Password?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue))
                              )
                          ),

                          // --- UPDATED BUTTON CALL ---
                          MyButtons(
                              isLoading: isLoading,
                              onTap: loginUser, // Changed from onDoubleTap to onTap
                              text: "Log In"
                          ),

                          SizedBox(height: height / 15),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? ", style: TextStyle(fontSize: 16)),
                                GestureDetector(
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpScreen())),
                                    child: const Text("SignUp", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue))
                                )
                              ]
                          )
                        ]
                    )
                )
            )
        )
    );
  }
}