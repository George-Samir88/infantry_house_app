import 'package:cloud_firestore/cloud_firestore.dart';

class AppComplaintsModel {
  final String id;
  final String name;
  final String phone;
  final String message;
  final DateTime? timestamp;

  AppComplaintsModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.message,
    this.timestamp,
  });

  // Convert from Firestore document
  factory AppComplaintsModel.fromDoc(Map<String, dynamic> data, String docId) {
    return AppComplaintsModel(
      id: docId,
      name: data['name'] ?? 'Anonymous',
      phone: data['phone'] ?? '',
      message: data['message'] ?? '',
      timestamp:
          data['timestamp'] != null
              ? (data['timestamp'] as Timestamp).toDate()
              : null,
    );
  }

  // Convert to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'name': name.trim(),
      'phone': phone.trim(),
      'message': message.trim(),
      'timestamp': timestamp ?? DateTime.now(),
    };
  }
}
