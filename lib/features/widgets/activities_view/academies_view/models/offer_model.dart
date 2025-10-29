import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel {
  final String id;
  final String offerNameAr;
  final String offerNameEn;
  final String offerDescriptionAr;
  final String offerDescriptionEn;
  final int numberOfLessons;
  final String duration; // مثال: week, month, quarter
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  OfferModel({
    required this.id,
    required this.offerNameAr,
    required this.offerNameEn,
    required this.offerDescriptionAr,
    required this.offerDescriptionEn,
    required this.numberOfLessons,
    required this.duration,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 🟢 Convert from Firestore Map to Model
  factory OfferModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return OfferModel(
      id: id ?? data['id'] ?? '',
      offerNameAr: data['offerNameAr'] ?? '',
      offerNameEn: data['offerNameEn'] ?? '',
      offerDescriptionAr: data['offerDescriptionAr'] ?? '',
      offerDescriptionEn: data['offerDescriptionEn'] ?? '',
      numberOfLessons: data['numberOfLessons'] ?? 0,
      duration: data['duration'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      createdAt: (data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: (data['updatedAt'] is Timestamp)
          ? (data['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// 🔵 Convert Model to Map (for Firestore upload)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'offerNameAr': offerNameAr,
      'offerNameEn': offerNameEn,
      'offerDescriptionAr': offerDescriptionAr,
      'offerDescriptionEn': offerDescriptionEn,
      'numberOfLessons': numberOfLessons,
      'duration': duration,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  /// 🟡 Copy with (for updates)
  OfferModel copyWith({
    String? id,
    String? offerNameAr,
    String? offerNameEn,
    String? offerDescriptionAr,
    String? offerDescriptionEn,
    int? numberOfLessons,
    String? duration,
    double? price,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OfferModel(
      id: id ?? this.id,
      offerNameAr: offerNameAr ?? this.offerNameAr,
      offerNameEn: offerNameEn ?? this.offerNameEn,
      offerDescriptionAr: offerDescriptionAr ?? this.offerDescriptionAr,
      offerDescriptionEn: offerDescriptionEn ?? this.offerDescriptionEn,
      numberOfLessons: numberOfLessons ?? this.numberOfLessons,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
