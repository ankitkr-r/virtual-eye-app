import 'package:flutter/material.dart';
import 'package:virtual_eye/Widget/button.dart';
import 'package:virtual_eye/Widget/ve_snack_bar.dart';
import 'package:virtual_eye/Widget/ve_text_form_field.dart';
import 'package:virtual_eye/home_Page_flutter/homepage.dart';
import 'package:virtual_eye/services/authentication.dart';
import 'package:virtual_eye/services/validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool _passVisibility = true; // Hidden by default
  final _formKey = GlobalKey<FormState>();

  void signUpUser() async {
    if (isLoading) return; // Prevent double clicks

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Call Authentication Service
      String res = await AuthServices().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      );

      if (!mounted) return; // Safety check

      if (res == "success") { // Note: AuthServices usually returns lowercase "success"
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        VESnackBar.errorShow(context, res);
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: height / 10),

              const Text(
                  "Create Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),

              SizedBox(height: height / 20),

              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Name Field
                      VETextFormField(
                        textEditingController: nameController,
                        hintText: 'Enter your name',
                        icon: Icons.person,
                        textInputType: TextInputType.name,
                        validator: (val) => val!.isEmpty ? "Enter Name" : null,
                      ),
                      const SizedBox(height: 15),

                      // Email Field
                      VETextFormField(
                        textEditingController: emailController,
                        hintText: 'Enter your email',
                        icon: Icons.email,
                        textInputType: TextInputType.emailAddress,
                        validator: Validator.validEmail,
                      ),
                      const SizedBox(height: 15),

                      // Password Field
                      VETextFormField(
                        textEditingController: passwordController,
                        hintText: 'Enter your password',
                        icon: Icons.lock,
                        textInputType: TextInputType.visiblePassword,
                        validator: Validator.validatePassword,
                        showSuffixIcon: true,
                        passVisibility: _passVisibility,
                        suffixOnPressed: () {
                          setState(() {
                            _passVisibility = !_passVisibility;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- FIX: UPDATED TO onTap ---
              MyButtons(
                  isLoading: isLoading,
                  onTap: signUpUser, // Changed from onDoubleTap
                  text: "Sign Up"
              ),

              const SizedBox(height: 20),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                        "Log In",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
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