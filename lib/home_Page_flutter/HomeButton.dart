import 'package:flutter/material.dart';

class CategoryW extends StatelessWidget {
  final String image;
  final String text;
  final Color color;
  final VoidCallback? onDoubleTap; // Callback for double tap
  final bool isEnabled;

  const CategoryW({
    super.key,
    required this.image,
    required this.text,
    required this.color,
    required this.onDoubleTap,
    required this.isEnabled// Make it required for double tap action
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onDoubleTap : null,
      onDoubleTap: isEnabled ? null : onDoubleTap, // Trigger the double tap action
      child: Container(
        height: 200,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFF494C8A),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF00000B),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20), // Adjust the height as needed
            ClipOval(
              child: Image.asset(
                image,
                width: 120,
                height: 120,
                fit: BoxFit.cover, // Ensures the image fits within the circular area
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              // onDoubleTap: onDoubleTap,
              child: Text(
                text,
                style: TextStyle(color: color, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}