import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String userId;
  final String username;
  final double stars;
  final DateTime? timestamp;

  RatingModel({
    required this.userId,
    required this.username,
    required this.stars,
    this.timestamp,
  });

  // تحويل من Firestore document إلى كائن UserRating
  factory RatingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final starsValue = data['stars'] ?? 0;

    return RatingModel(
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      stars: (starsValue is int) ? starsValue.toDouble() : starsValue as double,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
    );
  }

  // تحويل كائن UserRating إلى خريطة لتخزينها في Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'stars': stars,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }
}
