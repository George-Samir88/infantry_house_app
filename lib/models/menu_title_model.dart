class MenuTitleModel {
  final String? menuTitle;
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
  factory MenuTitleModel.fromMap(Map<String, dynamic> map) {
    return MenuTitleModel(
      menuTitle: map['menu_title'] as String?,
      uid: map['uid'] as String?,
      createdAt: map['created_at'] as DateTime?,
      updatedAt: map['updated_at'] as DateTime?,
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
