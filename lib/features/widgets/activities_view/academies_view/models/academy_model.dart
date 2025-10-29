import 'package:cloud_firestore/cloud_firestore.dart';
import 'offer_model.dart';

class AcademyModel {
  final String id;
  final String academyNameAr;
  final String academyNameEn;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OfferModel> offers;

  AcademyModel({
    required this.id,
    required this.academyNameAr,
    required this.academyNameEn,
    required this.createdAt,
    required this.updatedAt,
    required this.offers,
  });

  /// 🟢 Convert from Firestore Document to Model
  factory AcademyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AcademyModel(
      id: doc.id,
      academyNameAr: data['academyNameAr'] ?? '',
      academyNameEn: data['academyNameEn'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      offers: (data['offers'] as List<dynamic>?)
          ?.map((offer) =>
          OfferModel.fromMap(Map<String, dynamic>.from(offer)))
          .toList() ??
          [],
    );
  }

  /// 🔵 Convert Model to Map (for Firestore upload)
  Map<String, dynamic> toMap() {
    return {
      'academyNameAr': academyNameAr,
      'academyNameEn': academyNameEn,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'offers': offers.map((o) => o.toMap()).toList(),
    };
  }

  /// 🟡 Copy with (for updates)
  AcademyModel copyWith({
    String? id,
    String? academyNameAr,
    String? academyNameEn,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OfferModel>? offers,
  }) {
    return AcademyModel(
      id: id ?? this.id,
      academyNameAr: academyNameAr ?? this.academyNameAr,
      academyNameEn: academyNameEn ?? this.academyNameEn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      offers: offers ?? this.offers,
    );
  }
}
