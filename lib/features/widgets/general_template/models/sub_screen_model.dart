import 'package:cloud_firestore/cloud_firestore.dart';

class SubScreenModel {
  final String subScreenArName;
  final String subScreenEnName;
  final DateTime createdAt;
  final String uid;
  final DateTime? updatedAt;

  SubScreenModel({
    required this.subScreenArName,
    required this.subScreenEnName,
    required this.createdAt,
    required this.uid,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'sub_screen_ar_name': subScreenArName,
      'sub_screen_en_name': subScreenEnName,
      'created_at': createdAt,
      'uid': uid,
      'updated_at': updatedAt,
    };
  }

  factory SubScreenModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SubScreenModel(
      subScreenArName: data['sub_screen_ar_name'] ?? '',
      subScreenEnName: data['sub_screen_en_name'] ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      uid: data['uid'] ?? doc.id,
      // fallback للـ docId
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  /// ✅ copyWith لتحديث أي فيلد
  SubScreenModel copyWith({
    String? subScreenArName,
    String? subScreenEnName,
    DateTime? createdAt,
    String? uid,
    DateTime? updatedAt,
  }) {
    return SubScreenModel(
      subScreenArName: subScreenArName ?? this.subScreenArName,
      subScreenEnName: subScreenEnName ?? this.subScreenEnName,
      createdAt: createdAt ?? this.createdAt,
      uid: uid ?? this.uid,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
