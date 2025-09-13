import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';
import 'package:infantry_house_app/utils/custom_carousel_item.dart';

part 'department_state.dart';

///App Structure Naming

// Department → القسم الرئيسي (زي "الأغذية والمشروبات" أو "الأزياء").
// 🔹 الاسم في الكود: Department
//
// SubScreen → الشاشة الفرعية اللي جوه القسم (زي "باراديس" أو "فنادق").
// 🔹 الاسم في الكود: SubScreen
//
// Carousel → السلايدر اللي بيعرض صور أو عروض.
// 🔹 الاسم في الكود: Carousel
//
// MenuTitle → عنوان القائمة اللي فوق الأزرار (مثلاً "اختر الفئة").
// 🔹 الاسم في الكود: MenuTitle
//
// MenuButton → الأزرار اللي بتظهر جوه الـ SubScreen وتفلتر/تغير المحتوى.
// 🔹 الاسم في الكود: MenuButton
//
// ItemList → الليستة أو الجريد اللي بتعرض العناصر بعد ما تضغط زرار.
// 🔹 الاسم في الكود: ItemList
//
// ItemCard → الكارد/العنصر الواحد اللي جوه الـ ItemList.
// 🔹 الاسم في الكود: ItemCard

class DepartmentCubit extends Cubit<DepartmentState> {
  DepartmentCubit() : super(DepartmentInitial());

  ///-------------Variables-------------
  //selected department
  String selectedDepartment = 'food and beverage';

  //document id to screen name mapping
  Map<String, String> departmentsMap = {};

  //selected subScreen title
  String selectedSubScreen = '';
  Map<String, String> subScreenMap = {};

  //Carousel tracking
  int currentCarouselIndex = 0;

  //MenuTitle
  String menuTitle = '';

  //Menu Item List
  List<MenuItemModel> menuItemsList = [];

  //root collection name
  String rootCollectionName = "screens_ar";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///-------------Functions-------------

  String? findDocIdByDepartmentName() {
    return departmentsMap.entries
            .firstWhere(
              (entry) => entry.value == selectedDepartment,
              orElse: () => const MapEntry("", ""), // avoid crash if not found
            )
            .key
            .isEmpty
        ? null
        : departmentsMap.entries
            .firstWhere((entry) => entry.value == selectedDepartment)
            .key;
  }

  Future<List<String>> getDepartmentsNames() async {
    try {
      emit(DepartmentGetDepartmentsNamesLoadingState());
      final querySnapshot = await firestore
          .collection(rootCollectionName)
          .get(GetOptions(source: Source.server));

      final screenNames =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>?; // Safe cast
                return data?['screen_name'] as String?;
              })
              .where(
                (name) => name != null && name.isNotEmpty,
              ) // Filter null/empty
              .cast<String>()
              .toList();
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final name = data?['screen_name'] as String?;
        if (name != null && name.isNotEmpty) {
          departmentsMap[name] = doc.id;
        }
      }
      emit(DepartmentGetDepartmentsNamesSuccessState());
      return screenNames;
    } on FirebaseException catch (e) {
      // Firestore-specific error
      emit(
        DepartmentGetDepartmentsNamesFailureState(
          error: "Firestore error: ${e.message}",
        ),
      );
      return [];
    } catch (e) {
      // Any other error
      emit(DepartmentGetDepartmentsNamesFailureState(error: e.toString()));
      return [];
    }
  }

  Future<List<String>> getAllSubScreenNames() async {
    final String departmentId = departmentsMap[selectedDepartment]!;
    try {
      emit(DepartmentGetSubScreensNamesLoadingState());
      final querySnapshot = await firestore
          .collection(rootCollectionName)
          .doc(departmentId) // 🔹 dynamic parent doc
          .collection('super_categories')
          .get(GetOptions(source: Source.server));

      final superCategoryNames =
          querySnapshot.docs
              .map((doc) {
                final data = doc.data() as Map<String, dynamic>?;
                final name = data?['super_cat_name'] as String?;
                return name?.trim();
              })
              .where(
                (name) => name != null && name.isNotEmpty,
              ) // filter out bad data
              .cast<String>()
              .toList();
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>?;
        final name = data?['super_cat_name'] as String?;
        if (name != null && name.isNotEmpty) {
          subScreenMap[name] = doc.id;
        }
      }

      emit(DepartmentGetSubScreensNamesSuccessState());
      return superCategoryNames;
    } on FirebaseException catch (e) {
      // 🔹 Firestore-specific errors (e.g., permission denied, unavailable, etc.)
      emit(
        DepartmentGetSubScreensNamesFailureState(
          error:
              "Firestore error while fetching super categories: ${e.message}",
        ),
      );
      return [];
    } on Exception catch (e) {
      // 🔹 Any other Dart/Flutter exceptions
      emit(DepartmentGetSubScreensNamesFailureState(error: e.toString()));
      return [];
    }
  }

  Future<void> createSubScreen(String superCatName) async {
    try {
      final String departmentId = departmentsMap[selectedDepartment]!;
      emit(DepartmentCreateSubScreensNamesLoadingState());

      final docRef = await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .add({
            'super_cat_name': superCatName.trim(),
            'created_at': DateTime.now(),
          });
      await getAllSubScreenNames();
      emit(DepartmentCreateSubScreensNamesSuccessState(docReference: docRef));
    } on FirebaseException catch (e) {
      emit(
        DepartmentCreateSubScreensNamesFailureState(
          failure: "Firestore error while creating sub screen: ${e.message}",
        ),
      );
    } on Exception catch (e) {
      emit(DepartmentCreateSubScreensNamesFailureState(failure: e.toString()));
    }
  }

  Future<void> updateSubScreen({
    required String subScreenName,
    required String newSuperCatName,
  }) async {
    try {
      final String departmentId = departmentsMap[selectedDepartment]!;
      final String subScreenId = subScreenMap[subScreenName]!;
      emit(DepartmentUpdateSubScreensNamesLoadingState());

      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenId)
          .update({
            'super_cat_name': newSuperCatName.trim(),
            'updated_at': DateTime.now(),
          });

      emit(DepartmentUpdateSubScreensNamesSuccessState());
    } on FirebaseException catch (e) {
      emit(
        DepartmentUpdateSubScreensNamesFailureState(
          failure: "Firestore error while updating sub screen: ${e.message}",
        ),
      );
    } on Exception catch (e) {
      emit(DepartmentUpdateSubScreensNamesFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteSubScreen({required String subScreenName}) async {
    try {
      String departmentId = departmentsMap[selectedDepartment]!;
      String subScreenId = subScreenMap[subScreenName]!;
      emit(DepartmentDeleteSubScreensNamesLoadingState());

      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenId)
          .delete();
      getAllSubScreenNames();
      emit(DepartmentDeleteSubScreensNamesSuccessState());
    } on FirebaseException catch (e) {
      emit(
        DepartmentDeleteSubScreensNamesFailureState(
          failure: "Firestore error while deleting sub screen: ${e.message}",
        ),
      );
    } catch (e) {
      emit(
        DepartmentDeleteSubScreensNamesFailureState(
          failure: "Unexpected error: $e",
        ),
      );
    }
  }

  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(DepartmentChangeCarouselIndexState());
  }

  // Carousel CRUD Operations
  void addCarouselItem({required CustomCarouselItem customCarouselItem}) {
    emit(DepartmentAddNewCarouselState());
  }

  void removeCarouselItem({required int index}) {
    emit(DepartmentRemoveCarouselState());
  }

  // Initialization
  void initializeState() {
    emit(DepartmentInitializationState());
  }

  List<String> getScreenKeys() {
    return [];
  }

  int selectedButtonCategoryIndex = 0;
  bool isEmptyMenuItems = true;

  // Screens CRUD Operations
  void addNewScreen({required String screenTitle}) {
    ///i have a problem here that when deleting all departments
    ///selectedScreen variable remains the last value
    ///which is cause to error when adding new carousel or buttons or items before reinitialize selectedScreen automatically

    emit(DepartmentAddNewCategoryState());
  }

  void removeScreen({required String screenTitle}) {
    emit(DepartmentRemoveCategoryState());
  }

  void resetScreenSelection() {
    emit(DepartmentResetCategorySelectionState());
  }

  void changeSelectedScreen({required String buttonCategoryTitle}) {
    selectedSubScreen = buttonCategoryTitle;

    emit(DepartmentChangeScreenState());
  }

  // Buttons CRUD Operations
  void addNewButton({required String screenName, required String buttonTitle}) {
    emit(DepartmentAddNewButtonState());
  }

  void removeButton({required String screenName, required String buttonTitle}) {
    emit(DepartmentRemoveButtonState());
  }

  void editButtonName({required String newCategoryTitle}) {
    emit(DepartmentEditButtonNameState());
  }

  void resetButtonSelection({required String screenName}) {
    emit(DepartmentResetMenuSelection());
  }

  void updateSelectedList({
    required String screenName,
    required String buttonTitle,
  }) {
    emit(DepartmentUpdateSelectedListState());
  }

  // Items CRUD Operations
  void addItem({
    required String screenName,
    required MenuItemModel menuItemModel,
    required String buttonTitle,
  }) {
    emit(DepartmentAddNewItemState());
  }

  void removeItem({
    required String screenName,
    required String buttonTitle,
    required int indexOfItemInList,
  }) {
    emit(DepartmentRemoveItemState());
  }

  void updateItem({
    required String buttonTitle,
    required int listIndex,
    required String screenName,
    String? newTitle,
    String? newImage,
    String? newPrice,
  }) {
    // final item =
    //     newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle]![listIndex];
    // if (newImage != null && item.image != newImage) {
    //   item.image = newImage;
    // }
    // if (newTitle != null && item.title != newTitle) {
    //   item.title = newTitle;
    // }
    // if (newPrice != null && item.price != newPrice) {
    //   item.price = newPrice;
    // }
    emit(DepartmentUpdateItemState());
  }
}
