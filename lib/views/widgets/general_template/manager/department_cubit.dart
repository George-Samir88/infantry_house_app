import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';

import '../../../../models/carousel_models.dart';
import '../../../../models/menu_title_model.dart';
import '../../../../models/sub_screen_model.dart';

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
  DepartmentCubit({required this.departmentId}) : super(DepartmentInitial()) {
    getAllWidgetsData();
  }

  final String departmentId;

  ///-------------Variables-------------
  //selected department
  String selectedDepartment = 'FoodAndBeverage';

  //selected subScreen title
  String selectedSubScreen = '';
  Map<String, String> subScreenMap = {};
  String? selectedSubScreenID;
  int selectedSubScreenIndex = 0;
  List<SubScreenModel> subScreensList = [];

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

  Future<void> getAllWidgetsData() async {
    await getAllSubScreens();
    await getMenuTitle();
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

  ///--------------SubScreens CRUD operations--------------
  Future<void> getAllSubScreens() async {
    try {
      emit(DepartmentGetSubScreensNamesLoadingState());

      final querySnapshot = await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .get(GetOptions(source: Source.server));

      // رجع list of models
      final subScreens =
          querySnapshot.docs.map((doc) => SubScreenModel.fromDoc(doc)).toList();
      if (subScreens.isNotEmpty) {
        selectedSubScreenID = subScreens[0].uid;
        // لو عايز تحتفظ بالـ map name → id
        subScreenMap.clear();
        for (var sub in subScreens) {
          subScreenMap[sub.subScreenName] = sub.uid;
        }
      }
      subScreensList = subScreens;
      emit(DepartmentGetSubScreensNamesSuccessState());
    } on FirebaseException catch (e) {
      emit(
        DepartmentGetSubScreensNamesFailureState(
          error: "Firestore error while fetching sub screens: ${e.message}",
        ),
      );
    } on Exception catch (e) {
      emit(DepartmentGetSubScreensNamesFailureState(error: e.toString()));
    }
  }

  Future<void> createSubScreen({required String superCatName}) async {
    try {
      emit(DepartmentCreateSubScreensNamesLoadingState());

      // Step 1: جهز الـ model
      final newSubScreen = SubScreenModel(
        subScreenName: superCatName.trim(),
        createdAt: DateTime.now(),
        uid: "", // هنحدثه بعدين بالـ doc.id
        updatedAt: null,
      );

      // Step 2: add doc بالـ model
      final docRef = await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .add(newSubScreen.toMap());
      // Step 3: update uid field
      await docRef.update({'uid': docRef.id});
      // Step 4: add menu title
      final MenuTitleModel menuTitleModel = MenuTitleModel(
        menuTitle: null,
        uid: null,
        createdAt: DateTime.now(),
        updatedAt: null,
      );
      final menuTitleDocRef = await docRef
          .collection('sub_title_name')
          .add(menuTitleModel.toMap());
      await menuTitleDocRef.update({'uid': menuTitleDocRef.id});
      if (subScreensList.isEmpty) {
        selectedSubScreenID = docRef.id;
      }
      emit(DepartmentCreateSubScreensNamesSuccessState(docReference: docRef));
      await getAllSubScreens();
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
    required String newSuperCatName,
    required String subScreenUID,
  }) async {
    try {
      emit(DepartmentUpdateSubScreensNamesLoadingState());

      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenUID)
          .update({
            'super_cat_name': newSuperCatName.trim(),
            'updated_at': DateTime.now(),
          });
      emit(DepartmentUpdateSubScreensNamesSuccessState());
      await getAllSubScreens();
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

  Future<void> deleteSubScreen({required String subScreenUID}) async {
    try {
      emit(DepartmentDeleteSubScreensNamesLoadingState());

      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenUID)
          .delete();
      emit(DepartmentDeleteSubScreensNamesSuccessState());
      await getAllSubScreens();
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

  void changeSelectedSubScreen({
    required String subScreenButtonId,
    required int index,
  }) async {
    selectedSubScreenID = subScreenButtonId;
    selectedSubScreenIndex = index;
    emit(DepartmentChangeSubScreenState());
    await getMenuTitle();
  }

  ///--------------Carousel CRUD operations--------------
  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(DepartmentChangeCarouselIndexState());
  }

  Future<List<CarouselItemModel>> getCarouselItems() async {
    try {
      emit(DepartmentGetCarouselLoadingState());

      final querySnapshot =
          await firestore
              .collection(rootCollectionName)
              .doc(departmentId)
              .collection('super_categories')
              .doc(selectedSubScreenID)
              .collection('carousel_items')
              .get();

      final items =
          querySnapshot.docs
              .map((doc) => CarouselItemModel.fromDoc(doc))
              .toList();

      emit(DepartmentGetCarouselSuccessState());
      return items;
    } on FirebaseException catch (e) {
      emit(
        DepartmentGetCarouselFailureState(
          failure:
              "Firestore error while fetching carousel items: ${e.message}",
        ),
      );
      return [];
    } catch (e) {
      emit(DepartmentGetCarouselFailureState(failure: e.toString()));
      return [];
    }
  }

  Future<void> createCarouselItem({required String imageUrl}) async {
    try {
      emit(DepartmentCreateCarouselLoadingState());

      // Create a new document reference
      final docRef =
          firestore
              .collection(rootCollectionName)
              .doc(departmentId)
              .collection('super_categories')
              .doc(selectedSubScreenID)
              .collection('carousel_items')
              .doc(); // generate unique ID

      final newItem = CarouselItemModel(
        uid: docRef.id,
        imageUrl: imageUrl.trim(),
        createdAt: DateTime.now(),
      );

      // Save to Firestore
      await docRef.set(newItem.toMap());

      emit(DepartmentCreateCarouselSuccessState());
    } on FirebaseException catch (e) {
      emit(
        DepartmentCreateCarouselFailureState(
          failure: "Firestore error while creating carousel item: ${e.message}",
        ),
      );
    } on Exception catch (e) {
      emit(DepartmentCreateCarouselFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteCarouselItem({
    required String departmentId,
    required String subScreenId,
    required String carouselItemId,
  }) async {
    try {
      emit(DepartmentRemoveCarouselLoadingState());

      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenId)
          .collection('carousel_items')
          .doc(carouselItemId)
          .delete();

      emit(DepartmentRemoveCarouselSuccessState());
    } on FirebaseException catch (e) {
      emit(
        DepartmentRemoveCarouselFailureState(
          failure: "Firestore error while deleting carousel item: ${e.message}",
        ),
      );
    } catch (e) {
      emit(DepartmentRemoveCarouselFailureState(failure: e.toString()));
    }
  }

  ///--------------MenuTitle CRUD operations--------------
  Future<void> getMenuTitle() async {
    try {
      emit(DepartmentGetMenuTitleLoadingState());

      final querySnapshot = await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('sub_title_name') // 👈 عشان احنا متأكدين انه واحد بس
          .get(GetOptions(source: Source.server));
      if (querySnapshot.docs.isEmpty) {
        emit(
          DepartmentGetMenuTitleFailureState(
            failure: "No menu_title document found",
          ),
        );
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      final menuTitleModel = MenuTitleModel.fromMap(data);

      emit(DepartmentGetMenuTitleSuccessState(menuTitleModel: menuTitleModel));
    } on FirebaseException catch (e) {
      emit(
        DepartmentGetMenuTitleFailureState(
          failure: "Firestore error while fetching menu_title: ${e.message}",
        ),
      );
    } catch (e) {
      emit(DepartmentGetMenuTitleFailureState(failure: e.toString()));
    }
  }

  Future<void> updateMenuTitle({required String? menuTitle}) async {
    try {
      emit(DepartmentUpdateMenuTitleLoadingState());

      // ننشئ reference لوثيقة جديدة داخل sub_title_name
      final querySnapshot =
          await firestore
              .collection(rootCollectionName)
              .doc(departmentId)
              .collection('super_categories')
              .doc(selectedSubScreenID)
              .collection('sub_title_name')
              .get(); // 👈 هنسيب Firestore يختار ID

      final newMenuModel = MenuTitleModel(
        menuTitle: menuTitle,
        uid: querySnapshot.docs.first.id,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;

        await docRef.update({
          'menu_title': menuTitle,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }
      emit(DepartmentUpdateMenuTitleSuccessState(model: newMenuModel));
    } on FirebaseException catch (e) {
      emit(
        DepartmentUpdateMenuTitleFailureState(
          failure: "Firestore error while creating menu_title: ${e.message}",
        ),
      );
    } catch (e) {
      emit(DepartmentUpdateMenuTitleFailureState(failure: e.toString()));
    }
  }

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
