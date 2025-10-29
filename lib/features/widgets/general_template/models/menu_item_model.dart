class MenuItemModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String image;
  final String price;
  final String descriptionAr;
  final String descriptionEn;
  final double averageRating;
  final int ratingCount;
  final String menuButtonId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool hasFeedback;

  MenuItemModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.image,
    required this.price,
    required this.averageRating,
    required this.ratingCount,
    required this.menuButtonId,
    required this.createdAt,
    required this.updatedAt,
    required this.hasFeedback,
    required this.descriptionAr,
    required this.descriptionEn,
  });

  /// Convert Firestore/JSON map to model
  factory MenuItemModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return MenuItemModel(
      id: id ?? map['id'] ?? '',
      descriptionAr: map['description_ar'] ?? '',
      descriptionEn: map['description_en'] ?? '',
      hasFeedback: map['hasFeedback'] ?? false,
      titleAr: map['title_ar'] ?? '',
      titleEn: map['title_en'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '',
      averageRating: (map['averageRating'] ?? 0).toDouble(),
      ratingCount: (map['ratingCount'] ?? 0).toInt(),
      menuButtonId: map['menuButtonId'] ?? '',
      createdAt:
          map['createdAt'] is DateTime
              ? map['createdAt']
              : DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt:
          map['updatedAt'] is DateTime
              ? map['updatedAt']
              : DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert model to Firestore/JSON map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_ar': titleAr,
      'title_en': titleEn,
      'image': image,
      'price': price,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'menuButtonId': menuButtonId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'hasFeedback': hasFeedback,
    };
  }

  /// Clone with updated values
  MenuItemModel copyWith({
    String? id,
    String? titleAr,
    String? titleEn,
    String? image,
    String? price,
    double? averageRating,
    int? ratingCount,
    String? menuButtonId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? descriptionAr,
    String? descriptionEn,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionAr ?? this.descriptionEn,
      titleAr: titleAr ?? this.titleAr,
      titleEn: titleEn ?? this.titleEn,
      image: image ?? this.image,
      price: price ?? this.price,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      menuButtonId: menuButtonId ?? this.menuButtonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasFeedback: hasFeedback,
    );
  }

  @override
  String toString() {
    return 'MenuItemModel(id: $id, title_ar: $titleAr,title_en: $titleEn price: $price, avgRating: $averageRating, ratingCount: $ratingCount)';
  }
}
