import 'package:flutter/material.dart';

import 'custom_dots_indicator.dart';

class DotsIndicator extends StatelessWidget {
  const DotsIndicator({super.key, required this.currentIndex, required this.itemCount});
  final int currentIndex;
  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        itemCount,
            (index) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CustomDotsIndicator(isActive: currentIndex == index),
        ),
      ),
    );
  }
}