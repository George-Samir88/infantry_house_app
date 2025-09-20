class MenuItemModel {
  final String id;
  final String title;
  final String image;
  final String price;
  final double averageRating;
  final int ratingCount;
  final String menuButtonId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuItemModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.averageRating,
    required this.ratingCount,
    required this.menuButtonId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert Firestore/JSON map to model
  factory MenuItemModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return MenuItemModel(
      id: id ?? map['id'] ?? '',
      title: map['title'] ?? '',
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
      'title': title,
      'image': image,
      'price': price,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'menuButtonId': menuButtonId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Clone with updated values
  MenuItemModel copyWith({
    String? id,
    String? title,
    String? image,
    String? price,
    double? averageRating,
    int? ratingCount,
    String? menuButtonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      menuButtonId: menuButtonId ?? this.menuButtonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'MenuItemModel(id: $id, title: $title, price: $price, avgRating: $averageRating, ratingCount: $ratingCount)';
  }
}
