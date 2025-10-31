import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../utils/map_firebase_error.dart';
import '../models/academy_model.dart';

part 'academies_state.dart';

class AcademiesCubit extends Cubit<AcademiesState> {
  AcademiesCubit({
    required this.loc,
    required this.departmentId,
    required this.canManage,
  }) : super(AcademyInitial());
  final S loc;
  final String departmentId;
  final bool canManage;

  ///----------------Variables--------------
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String _rootCollectionName = "screens_ar";
  final String _academiesCollectionName = "academies";
  int selectedAcademyIndex = 0;
  int currentSelectedCategoryIndex = 0;
  String? selectedAcademyTitle;
  double rotationAngle = 0.0;

  ///----------------Functions--------------
  void changeSelectedAcademyIndex({required int index}) {
    selectedAcademyIndex = index;
    emit(AcademyChangeCurrentSelectedIndexState());
  }

  void changeCategoryIndex({required int index}) {
    selectedAcademyIndex = 0;
    currentSelectedCategoryIndex = index;
    triggerRotation();
    emit(AcademyChangeCurrentCategoryIndexState());
  }

  void initialRotation() {
    Future.delayed(Duration(milliseconds: 200), () {
      rotationAngle += 360; // Rotates once when opened
      emit(AcademyInitialAnimationState());
    });
  }

  void triggerRotation() {
    rotationAngle += 360;
    emit(AcademyTriggerAnimationState());
  }

  ///-------------Academy CRUD operations---------------
  Future<void> createAcademy({
    required String academyNameAr,
    required String academyNameEn,
  }) async {
    try {
      emit(AcademyCreateLoadingState());

      // ✅ Step 1: Check Internet Connection
      if (!await hasInternetConnection()) return;

      // ✅ Step 2: Prepare the Academy Model
      final newAcademy = AcademyModel(
        id: "",
        academyNameAr: academyNameAr.trim(),
        academyNameEn: academyNameEn.trim(),
        createdAt: DateTime.now(),
        updatedAt:  null,
        offers: [], // empty by default
      );

      // ✅ Step 3: Get reference for new document
      final docRef =
          firestore
              .collection(_rootCollectionName)
              .doc(departmentId)
              .collection(_academiesCollectionName)
              .doc();

      // ✅ Step 4: Add to Firestore
      await docRef.set(newAcademy.toMap());

      // ✅ Step 5: Update document with its ID
      await docRef.update({'id': docRef.id});

      // ✅ Step 6: Emit success
      emit(AcademyCreateSuccessState());
    } on FirebaseException catch (e) {
      // 🟥 Handle Firestore-specific errors
      emit(
        AcademyCreateFailureState(
          failure: localizeFirestoreError(loc: loc, code: e.code),
        ),
      );
    } on Exception catch (e) {
      // 🟧 Handle general errors
      emit(AcademyCreateFailureState(failure: e.toString()));
    }
  }

  // void resetCategorySelection() {
  //   if (mapBetweenCategoriesAndActivities.isNotEmpty) {
  //     selectedCategory = mapBetweenCategoriesAndActivities.keys.first;
  //     currentSelectedCategoryIndex = 0;
  //     selectedAcademyIndex = 0;
  //   } else {
  //     mapBetweenCategoriesAndActivities.clear();
  //   }
  //   emit(AcademyResetCategorySelectionState());
  // }

  ///-------- Category CRUD Operations --------
  // void addNewCategory({required String newCategoryName}) {
  //   ///here i updated code because when deleting all items of map 'selectedCategory' variable still assigned to the last value as it was before deleting all items of map
  //   if (mapBetweenCategoriesAndActivities.isNotEmpty) {
  //     mapBetweenCategoriesAndActivities[newCategoryName] = [];
  //   } else if (mapBetweenCategoriesAndActivities.isEmpty) {
  //     mapBetweenCategoriesAndActivities[newCategoryName] = [];
  //     selectedCategory = mapBetweenCategoriesAndActivities.keys.first;
  //   }
  //   emit(AcademyAddNewCategoryState());
  // }

  // void removeExistingCategory({required String categoryTitle}) {
  //   mapBetweenCategoriesAndActivities.remove(categoryTitle);
  //   resetCategorySelection();
  //   emit(AcademyRemoveCategoryState());
  // }

  ///-------- Activity CRUD Operations --------
  // void addNewItem({required AcademiesItemModel newActivity}) {
  //   mapBetweenCategoriesAndActivities[selectedCategory]!.add(newActivity);
  //   emit(AcademyAddNewItemState());
  // }

  // void removeExistingItem({required AcademiesItemModel activity}) {
  //   if (mapBetweenCategoriesAndActivities[selectedCategory]!.isNotEmpty) {
  //     mapBetweenCategoriesAndActivities[selectedCategory]!.remove(activity);
  //     selectedAcademyIndex = 0;
  //   }
  //   emit(AcademyRemoveItemState());
  // }

  // void updateDailyActivityItem({
  //   required String title,
  //   required String description,
  //   required String trainerName,
  //   required String activityImage,
  //   required String price,
  // }) {
  //   // Get the current item
  //   var currentItem =
  //   mapBetweenCategoriesAndActivities[selectedCategory]![selectedAcademyIndex];
  //
  //   // Only update the field if it's different
  //   var updatedItem = currentItem.copyWith(
  //     title: title != currentItem.title ? title : null,
  //     description: description != currentItem.description ? description : null,
  //     trainerName: trainerName != currentItem.trainerName ? trainerName : null,
  //     activityImage:
  //     activityImage != currentItem.activityImage ? activityImage : null,
  //     price: price != currentItem.price ? price : null,
  //   );
  //
  //   // Replace the item in the list
  //   mapBetweenCategoriesAndActivities[selectedCategory]![selectedAcademyIndex] =
  //       updatedItem;
  //   emit(AcademyUpdateItemState());
  // }
  ///---------------- Helper Functions ----------------

  Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // ✅ Check if ANY active connection exists
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (!hasConnection) {
      emit(AcademyNoInternetConnectionState(message: loc.unavailable));
    }

    return hasConnection;
  }
}
