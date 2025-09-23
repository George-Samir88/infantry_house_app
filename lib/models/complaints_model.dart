import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  final String userId; // who sent it
  final List<String> complaints; // ["taste", "high_price"]
  final String note; // optional extra text
  final String? imageUrl; // optional photo/check upload
  final DateTime createdAt; // when it was created

  ComplaintModel({
    required this.userId,
    required this.complaints,
    this.note = "",
    this.imageUrl,
    required this.createdAt,
  });

  // Convert Firestore -> Model
  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      userId: map['userId'] ?? '',
      complaints: List<String>.from(map['complaints'] ?? []),
      note: map['note'] ?? '',
      imageUrl: map['imageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert Model -> Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'complaints': complaints,
      'note': note,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
