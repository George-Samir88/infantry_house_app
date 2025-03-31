class DailyActivityItemModel {
  final String title;
  final String description;
  final String trainerName;
  final String activityImage;
  final String price;

  DailyActivityItemModel({
    required this.trainerName,
    required this.activityImage,
    required this.price,
    required this.title,
    required this.description,
  });

  DailyActivityItemModel copyWith({
    String? title,
    String? description,
    String? trainerName,
    String? activityImage,
    String? price,
  }) {
    return DailyActivityItemModel(
      title: title ?? this.title,
      description: description ?? this.description,
      trainerName: trainerName ?? this.trainerName,
      activityImage: activityImage ?? this.activityImage,
      price: price ?? this.price,
    );
  }
}
