class MenuButtonModel {
  final String? uid;
  final String? buttonTitle;
  final String? createdAt;
  final String? updatedAt;

  MenuButtonModel({
    required this.uid,
    required this.buttonTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuButtonModel.fromMap(Map<String, dynamic> map) {
    return MenuButtonModel(
      uid: map['uid'] as String?,
      buttonTitle: map['button_title'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'button_title': buttonTitle,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
