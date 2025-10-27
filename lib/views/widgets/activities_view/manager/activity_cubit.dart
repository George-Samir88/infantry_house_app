import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../../../../helper_functions/collection_exists.dart';
import '../../../../utils/map_firebase_error.dart';
import '../../general_template/models/carousel_models.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit({
    required this.loc,
    required this.departmentId,
    required this.canManage,
  }) : super(ActivityInitial());

  ///-----------------Variables-----------
  int currentCarouselIndex = 0;
  final S loc;
  final String departmentId;
  final bool canManage;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String rootCollectionName = "screens_ar";
  final String _carouselCollectionName = "carousel_items";
  List<CarouselItemModel> carouselCache = [];
  List<CarouselItemModel> carouselItemList = [];

  ///-----------------Functions-----------
  ///--------------Carousel CRUD operations--------------
  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(ActivityChangeCarouselIndexState());
  }

  Future<void> listenToCarousel() async {
    emit(ActivityGetCarouselLoadingState());
    if (!await hasInternetConnection()) return;
    try {
      final collectionPath = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection(_carouselCollectionName);

      final exists = await collectionExists(collectionRef: collectionPath);

      if (!exists) {
        carouselCache = [];
        emit(ActivityGetCarouselEmptyState());
        return;
      }

      // 🔹 replace snapshots() with one-time get()
      final snapshot = await collectionPath.get();

      try {
        carouselItemList =
            snapshot.docs.map((doc) => CarouselItemModel.fromDoc(doc)).toList();

        if (carouselItemList.isEmpty) {
          emit(ActivityGetCarouselEmptyState());
        } else {
          emit(ActivityGetCarouselSuccessState());
        }
      } on FirebaseException catch (e) {
        emit(
          ActivityGetCarouselFailureState(
            failure: localizeFirestoreError(loc: loc, code: e.code),
          ),
        );
      } catch (e) {
        emit(ActivityGetCarouselFailureState(failure: e.toString()));
      }
    } on FirebaseException catch (e) {
      emit(
        ActivityGetCarouselFailureState(
          failure: localizeFirestoreError(loc: loc, code: e.code),
        ),
      );
    } catch (e) {
      emit(ActivityGetCarouselFailureState(failure: e.toString()));
    }
  }

  Future<void> createCarouselItem({required String imageUrl}) async {
    try {
      emit(ActivityCreateCarouselLoadingState());
      if (!await hasInternetConnection()) return;

      // Create a new document reference
      final docRef =
          firestore
              .collection(rootCollectionName)
              .doc(departmentId)
              .collection(_carouselCollectionName)
              .doc(); // generate unique ID

      final newItem = CarouselItemModel(
        uid: docRef.id,
        imageUrl: imageUrl.trim(),
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(newItem.toMap());

      // ✅ Update local list
      carouselItemList.add(newItem);

      emit(ActivityCreateCarouselSuccessState());
    } on FirebaseException catch (e) {
      emit(
        ActivityCreateCarouselFailureState(
          failure: localizeFirestoreError(loc: loc, code: e.code),
        ),
      );
    } on Exception catch (e) {
      emit(ActivityCreateCarouselFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteCarouselItem({required String carouselItemId}) async {
    try {
      emit(ActivityDeleteLoadingCarouselState());
      if (!await hasInternetConnection()) return;

      // 🔥 Step 1: delete from Firestore
      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection(_carouselCollectionName)
          .doc(carouselItemId)
          .delete();

      // 🔥 Step 2: update local list
      carouselItemList.removeWhere((item) => item.uid == carouselItemId);

      emit(ActivityDeleteSuccessCarouselState());
    } on FirebaseException catch (e) {
      emit(
        ActivityDeleteFailureCarouselState(
          failure: localizeFirestoreError(loc: loc, code: e.code),
        ),
      );
    } catch (e) {
      emit(ActivityDeleteFailureCarouselState(failure: e.toString()));
    }
  }

  // List<Widget> carouselItems = [
  //   CustomCarouselItem(
  //     imagePath: 'assets/images/coffee.jpg',
  //     isPickedImage: false,
  //   ),
  //   CustomCarouselItem(
  //     imagePath: 'assets/images/coffee2.jpg',
  //     isPickedImage: false,
  //   ),
  // ];

  // ///-----------------------Carousel Items Crud Operations-----------------------
  // void addCarouselItem({required CustomCarouselItem customCarouselItem}) {
  //   carouselItems.add(customCarouselItem);
  //   emit(ActivityCreateCarouselLoadingState());
  // }
  //
  // void removeCarouselItem({required int index}) {
  //   carouselItems.removeAt(index);
  //   emit(ActivityRemoveLoadingCarouselState());
  // }

  ///---------------- Helper Functions ----------------

  Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // ✅ Check if ANY active connection exists
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (!hasConnection) {
      emit(ActivityNoInternetConnectionState(message: loc.unavailable));
    }

    return hasConnection;
  }
}
