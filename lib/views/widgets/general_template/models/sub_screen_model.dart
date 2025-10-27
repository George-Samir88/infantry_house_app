import 'package:cloud_firestore/cloud_firestore.dart';


class SubScreenModel {
  final String subScreenName;
  final DateTime createdAt;
  final String uid;
  final DateTime? updatedAt;

  SubScreenModel({
    required this.subScreenName,
    required this.createdAt,
    required this.uid,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'super_cat_name': subScreenName,
      'created_at': createdAt,
      'uid': uid,
      'updated_at': updatedAt,
    };
  }

  factory SubScreenModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SubScreenModel(
      subScreenName: data['super_cat_name'] ?? '',
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      uid: data['uid'] ?? doc.id, // fallback للـ docId
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  /// ✅ copyWith لتحديث أي فيلد
  SubScreenModel copyWith({
    String? subScreenName,
    DateTime? createdAt,
    String? uid,
    DateTime? updatedAt,
  }) {
    return SubScreenModel(
      subScreenName: subScreenName ?? this.subScreenName,
      createdAt: createdAt ?? this.createdAt,
      uid: uid ?? this.uid,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
