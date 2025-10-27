import 'package:cloud_firestore/cloud_firestore.dart';

class MenuTitleModel {
  String? menuTitle;
  final String? uid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MenuTitleModel({
    required this.menuTitle,
    required this.uid,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert Firestore/JSON Map → Model
  factory MenuTitleModel.fromMap(Map<String, dynamic> data) {
    return MenuTitleModel(
      menuTitle: data['menu_title'] as String?,
      uid: data['uid'] as String?,
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate(),
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
    );
  }

  /// Convert Model → Map (to save in Firestore/JSON)
  Map<String, dynamic> toMap() {
    return {
      'menu_title': menuTitle,
      'uid': uid,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
