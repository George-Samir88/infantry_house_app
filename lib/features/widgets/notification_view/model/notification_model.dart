import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String body;
  final String image;
  final String topic;
  final String type;
  final String offerId;
  final DateTime createdAt;

  NotificationModel({
    required this.title,
    required this.body,
    required this.image,
    required this.topic,
    required this.type,
    required this.offerId,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      image: map['image'] ?? '',
      topic: map['topic'] ?? '',
      type: map['type'] ?? '',
      offerId: map['offerId'] ?? '',
      createdAt: (map['timestamp'] is Timestamp)
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'topic': topic,
      'type': type,
      'offerId': offerId,
      'timestamp': Timestamp.fromDate(createdAt),
    };
  }
}
