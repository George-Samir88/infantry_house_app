import 'package:flutter/material.dart';

class CustomPopularItem extends StatelessWidget {
  const CustomPopularItem({
    super.key,
    required this.title,
    required this.price,
    required this.photoPath,
    required this.rating,
  });

  final String title, price, photoPath;
  final double rating;

  String get getTitle => title;
  String get getPrice => price;
  String get getPhotoPath => photoPath;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 6,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 100,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.brown,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.yellow,
                        size: 12,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: -10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                photoPath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: -10,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '\$$price',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
