import 'package:flutter/material.dart';

class VETextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextInputType textInputType;
  final bool passVisibility;
  final IconData icon;
  final String hintText;
  final void Function()? suffixOnPressed;
  final bool showSuffixIcon;
  final String? Function(String? name) validator;

  const VETextFormField({
    super.key,
    required this.textEditingController,
    required this.textInputType,
    this.passVisibility = true,
    required this.icon,
    required this.hintText,
    this.suffixOnPressed,
    this.showSuffixIcon = false,
    required this.validator
  });
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      style: const TextStyle(fontSize: 20),
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: !passVisibility,
      decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: const Color(0xFFedf0f8),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
          suffixIcon: showSuffixIcon ? IconButton(
            icon: passVisibility
                ? const Icon(Icons.visibility_off)
                : const Icon(Icons.visibility),
            onPressed: suffixOnPressed,
          ) : null),
    );
  }

}