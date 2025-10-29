import 'package:cloud_firestore/cloud_firestore.dart';

class CarouselItemModel {
  final String uid;
  final String imageUrl;
  final DateTime createdAt;

  CarouselItemModel({
    required this.uid,
    required this.imageUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {'image_url': imageUrl, 'created_at': createdAt};
  }

  factory CarouselItemModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CarouselItemModel(
      uid: doc.id,
      imageUrl: data['image_url'] ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
