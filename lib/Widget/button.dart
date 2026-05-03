import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final VoidCallback onTap; // Renamed from onDoubleTap for clarity
  final String text;
  final bool isLoading;

  const MyButtons({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Material(
        color: Colors.blue, // Background color goes here
        borderRadius: BorderRadius.circular(30), // Rounded corners
        child: InkWell(
          borderRadius: BorderRadius.circular(30), // Clip ripple to corners
          onTap: isLoading ? null : onTap,
          child: Container(
            height: 50, // Fixed height for consistency
            alignment: Alignment.center,
            width: double.infinity, // Takes full width
            child: isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}