import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/complaints_model.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/rating_model.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit({required this.loc}) : super(RatingInitial());
  final S loc;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<ComplaintModel> complaintsList = [];
  List<RatingModel> ratingsList = [];

  Future<void> submitRating({
    required String departmentId,
    required String subScreenId,
    required String buttonId,
    required String menuItemId,
    required double stars,
    required String userId,
    required String userName,
  }) async {
    emit(RatingSendRatingLoading());
    if (!await _hasInternetConnection()) return;

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

      final feedbackCollectionRef = firestore
          .collection("feedback")
          .doc(menuItemId)
          .collection("rating");

      await firestore.runTransaction((transaction) async {
        final menuSnapshot = await transaction.get(menuItemRef);

        if (!menuSnapshot.exists) {
          emit(RatingSendRatingFailure(failure: "Menu item not found"));
          throw FirebaseException(
            plugin: "Firestore",
            message: "Menu item not found",
          );
        }

        final menuData = menuSnapshot.data() as Map<String, dynamic>;
        int ratingCount = (menuData["ratingCount"] ?? 0) as int;
        double averageRating = (menuData["averageRating"] ?? 0.0).toDouble();

        // البحث عن تقييم المستخدم الحالي
        final userQuery =
            await feedbackCollectionRef
                .where("userId", isEqualTo: userId)
                .limit(1)
                .get();

        if (userQuery.docs.isEmpty) {
          transaction.update(menuItemRef, {"hasFeedback": true});
          // المستخدم لم يقيم قبل كده → إنشاء UserRating جديد
          final feedbackRef = feedbackCollectionRef.doc();
          final newRating = RatingModel(
            userId: userId,
            username: userName,
            stars: stars,
            timestamp: DateTime.now(),
          );

          transaction.set(feedbackRef, newRating.toMap());

          ratingCount += 1;
          averageRating =
              ((averageRating * (ratingCount - 1)) + stars) / ratingCount;
        } else {
          // المستخدم قيم قبل كده → تحديث تقييمه باستخدام UserRating
          final existingDoc = userQuery.docs.first;
          final oldStars = (existingDoc.data()["stars"] ?? 0);

          final updatedRating = RatingModel(
            userId: userId,
            username: userName,
            stars: stars,
            timestamp: DateTime.now(),
          );

          transaction.update(existingDoc.reference, updatedRating.toMap());

          // تحديث المتوسط بعد تعديل التقييم القديم
          averageRating =
              ((averageRating * ratingCount) - oldStars + stars.toInt()) /
              ratingCount;
        }

        // تأكد أن المتوسط بين 0 و 5
        averageRating = averageRating.clamp(0.0, 5.0);

        // تحديث بيانات العنصر
        transaction.update(menuItemRef, {
          "ratingCount": ratingCount,
          "averageRating": averageRating,
        });

        emit(RatingSendRatingSuccess());
      });
    } on FirebaseException catch (e) {
      emit(RatingSendRatingFailure(failure: e.code));
    } catch (e) {
      emit(RatingSendRatingFailure(failure: e.toString()));
    }
  }

  Future<void> getRatings({required String menuItemId}) async {
    emit(RatingGetRatingLoading());
    if (!await _hasInternetConnection()) return;

    try {
      final feedbackCollectionRef = firestore
          .collection("feedback")
          .doc(menuItemId)
          .collection("rating");

      final querySnapshot = await feedbackCollectionRef.get();

      // تحويل المستندات إلى قائمة UserRating
      final ratings =
          querySnapshot.docs
              .map((doc) => RatingModel.fromFirestore(doc))
              .toList();
      ratingsList = ratings;
      emit(RatingGetRatingSuccess());
    } on FirebaseException catch (e) {
      emit(RatingGetRatingFailure(failure: e.code));
    } catch (e) {
      emit(RatingGetRatingFailure(failure: e.toString()));
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
    if (!await _hasInternetConnection()) return;

    try {
      final batch = firestore.batch();

      // Reference for complaint doc (auto-ID inside feedback collection)
      final feedbackRef =
          firestore
              .collection("feedback")
              .doc(itemId)
              .collection("menu_items_complaint")
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
    if (!await _hasInternetConnection()) return;

    try {
      final snapshot =
          await firestore
              .collection("feedback")
              .doc(itemId)
              .collection("menu_items_complaint")
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

  ///---------------- Helper Functions ----------------

  Future<bool> _hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // ✅ Check if ANY active connection exists
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (!hasConnection) {
      emit(RatingNoInternetConnectionState(message: loc.unavailable));
    }

    return hasConnection;
  }
}
