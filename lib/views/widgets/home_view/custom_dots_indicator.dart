import 'package:flutter/material.dart';

class CustomDotsIndicator extends StatelessWidget {
  const CustomDotsIndicator({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isActive ? 32 : 8,
      height: 8,
      decoration: ShapeDecoration(
        color: isActive ? Colors.brown[800] : Colors.grey.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}
