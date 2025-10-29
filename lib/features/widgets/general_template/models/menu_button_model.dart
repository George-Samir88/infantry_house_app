class MenuButtonModel {
  final String? uid;
  final String? buttonTitleAr;
  final String? buttonTitleEn;
  final String? createdAt;
  final String? updatedAt;

  MenuButtonModel({
    required this.uid,
    required this.buttonTitleAr,
    required this.buttonTitleEn,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuButtonModel.fromMap(Map<String, dynamic> map) {
    return MenuButtonModel(
      uid: map['uid'] as String?,
      buttonTitleAr: map['button_title_ar'] as String?,
      buttonTitleEn: map['button_title_en'] as String?,
      createdAt: map['created_at'] as String?,
      updatedAt: map['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'button_title_ar': buttonTitleAr,
      'button_title_en': buttonTitleEn,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  MenuButtonModel copyWith({
    String? uid,
    String? buttonTitleAr,
    String? buttonTitleEn,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) {
    return MenuButtonModel(
      uid: uid ?? this.uid,
      buttonTitleAr: buttonTitleAr ?? this.buttonTitleAr,
      buttonTitleEn: buttonTitleEn ?? this.buttonTitleEn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
