import 'package:flutter/material.dart';

class CustomCarouselItem extends StatelessWidget {
  const CustomCarouselItem({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.8;
        double height = width * 0.2;

        return Container(
          width: width,
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                blurRadius: 8,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/coffee2.jpg',
              fit: BoxFit.cover,
              width: width,
              height: height,
            ),
          ),
        );
      },
    );
  }
}
