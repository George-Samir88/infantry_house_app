import 'package:flutter/material.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    super.key,
    this.isActive = false,
    required this.imagePath,
  });

  final String imagePath;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 600,
      ),
      child: Container(
        width: 103,
        height: 62,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1.50,
                color: isActive ? const Color(0xFF34A853) : Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          shadows: [
            BoxShadow(
              //belong to the color of the internal box
              color: isActive ? const Color(0xFF34A853) : Colors.grey,
              //belong to the blur of the internal box
              blurRadius: 4,
              //the same but the offset is the dimension with regards to x and y dimension
              offset: const Offset(0, 0),
              //radius of the internal box
              spreadRadius: 0,
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
              child: Image.asset(
                imagePath,
              )),
        ),
      ),
    );
  }
}