class AcademiesItemModel {
  final String title;
  final String description;
  final String trainerName;
  final String activityImage;
  final String price;

  AcademiesItemModel({
    required this.trainerName,
    required this.activityImage,
    required this.price,
    required this.title,
    required this.description,
  });

  AcademiesItemModel copyWith({
    String? title,
    String? description,
    String? trainerName,
    String? activityImage,
    String? price,
  }) {
    return AcademiesItemModel(
      title: title ?? this.title,
      description: description ?? this.description,
      trainerName: trainerName ?? this.trainerName,
      activityImage: activityImage ?? this.activityImage,
      price: price ?? this.price,
    );
  }
}
