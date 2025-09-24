import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/complaints_model.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit() : super(RatingInitial());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<ComplaintModel> complaintsList = [];

  Future<void> submitRating({
    required String departmentId,
    required String subScreenId,
    required String buttonId,
    required String menuItemId,
    required int stars,
  }) async {
    emit(RatingSendRatingLoading());

    try {
      final menuItemRef = firestore
          .collection("screens_ar")
          .doc(departmentId)
          .collection("super_categories")
          .doc(subScreenId)
          .collection("Buttons")
          .doc(buttonId)
          .collection("menu_items")
          .doc(menuItemId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(menuItemRef);

        if (!snapshot.exists) {
          emit(RatingSendRatingFailure(failure: "Menu item not found"));
          throw FirebaseException(
            plugin: "Firestore",
            message: "Menu item not found",
          );
        }
        final data = snapshot.data() as Map<String, dynamic>;
        final int ratingCount = (data["ratingCount"] ?? 0) as int;
        final double averageRating = (data["averageRating"] ?? 0.0).toDouble();
        final int newCount = ratingCount + 1;
        double newAverage = ((averageRating * ratingCount) + stars) / newCount;

        // تأكد إن المتوسط مش هيعدي 5 أو يقل عن 0
        newAverage = newAverage.clamp(0.0, 5.0);
        transaction.update(menuItemRef, {
          "ratingCount": newCount,
          "averageRating": newAverage,
        });
        emit(RatingSendRatingSuccess());
      });
    } on FirebaseException catch (e) {
      emit(RatingSendRatingFailure(failure: e.code));
    } catch (e) {
      emit(RatingSendRatingFailure(failure: e.toString()));
    }
  }

  Future<void> submitComplaint({
    required String itemId,
    required ComplaintModel complaint,
    required String departmentId,
    required String subScreenId,
    required String buttonId,
  }) async {
    emit(RatingSubmitComplaintsLoading());

    try {
      final batch = firestore.batch();

      // Reference for complaint doc (auto-ID inside feedback collection)
      final feedbackRef =
          firestore
              .collection("menu_items_complaint")
              .doc(itemId)
              .collection("feedback")
              .doc(); // generate new doc ID

      // Reference for menu item doc
      final menuItemRef = firestore
          .collection("screens_ar")
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenId)
          .collection('Buttons')
          .doc(buttonId)
          .collection('menu_items')
          .doc(itemId);

      // Add complaint in batch
      batch.set(feedbackRef, complaint.toMap());

      // Update hasFeedback in batch
      batch.update(menuItemRef, {"hasFeedback": true});

      // Commit atomic batch
      await batch.commit();

      emit(RatingSubmitComplaintsSuccess());
    } on FirebaseException catch (e) {
      emit(RatingSubmitComplaintsFailure(failure: e.code));
    } catch (e) {
      emit(RatingSubmitComplaintsFailure(failure: e.toString()));
    }
  }

  Future<void> getComplaints({required String itemId}) async {
    emit(RatingGetComplaintsLoading());

    try {
      final snapshot =
          await firestore
              .collection("menu_items_complaint")
              .doc(itemId)
              .collection("feedback")
              .get();

      if (snapshot.docs.isEmpty) {
        complaintsList.clear();
        emit(RatingGetComplaintsSuccess());
        return;
      }

      final complaints =
          snapshot.docs
              .map((doc) {
                try {
                  return ComplaintModel.fromMap(doc.data());
                } catch (e) {
                  // لو doc فيه مشكلة في parsing بيتشال
                  return null;
                }
              })
              .whereType<ComplaintModel>()
              .toList();
      complaintsList = complaints;
      emit(RatingGetComplaintsSuccess());
    } on FirebaseException catch (e) {
      emit(RatingGetComplaintsFailure(failure: e.code));
    } catch (e) {
      emit(RatingGetComplaintsFailure(failure: e.toString()));
    }
  }
}
