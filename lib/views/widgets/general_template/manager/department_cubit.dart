import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';

import '../../../../models/carousel_models.dart';
import '../../../../models/menu_button_model.dart';
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
  DepartmentCubit({required this.departmentId}) : super(DepartmentInitial());

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
  List<CarouselItemModel> carouselItemsList = [];

  //MenuTitle
  String menuTitle = '';

  //Menu Buttons
  List<MenuButtonModel> menuButtonList = [];
  int selectedButtonIndex = 0; // Track selected button index
  String? selectedMenuButtonId;

  //Menu Item List
  List<MenuItemModel> menuItemsList = [];

  //root collection name
  String rootCollectionName = "screens_ar";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  ///------------Listeners--------------
  StreamSubscription? _subScreensSub;
  StreamSubscription? _menuTitleSub;
  StreamSubscription? _menuButtonsSub;
  StreamSubscription? _carouselSub;

  ///-------------Functions-------------

  Future<void> deleteCollection(CollectionReference colRef) async {
    const int batchSize = 400; // أقل من 500 عشان الأمان
    QuerySnapshot snapshot;
    do {
      snapshot = await colRef.limit(batchSize).get();
      if (snapshot.docs.isEmpty) break;
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } while (snapshot.docs.length >= batchSize);
  }

  Future<List<String>> getDepartmentsNames() async {
    try {
      emit(DepartmentGetDepartmentsNamesLoadingState());
      final querySnapshot =
          await firestore.collection(rootCollectionName).get();

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
      emit(DepartmentGetDepartmentsNamesFailureState(error: e.code));
      return [];
    } catch (e) {
      // Any other error
      emit(DepartmentGetDepartmentsNamesFailureState(error: e.toString()));
      return [];
    }
  }

  ///--------------SubScreens CRUD operations--------------
  void listenToSubScreens() {
    emit(DepartmentGetSubScreensNamesLoadingState());
    _subScreensSub?.cancel();

    _subScreensSub = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .orderBy("created_at", descending: false)
        .snapshots()
        .listen(
          (snapshot) {
            try {
              subScreensList =
                  snapshot.docs
                      .map((doc) => SubScreenModel.fromDoc(doc))
                      .toList();
              // اختار أول SubScreen لو مفيش selected
              if (subScreensList.isNotEmpty && selectedSubScreenID == null) {
                selectedSubScreenID = subScreensList[0].uid;
                changeSelectedSubScreen(
                  subScreenButtonId: selectedSubScreenID!,
                  index: 0,
                );
              }

              emit(DepartmentGetSubScreensNamesSuccessState());
            } on FirebaseException catch (e) {
              emit(DepartmentGetSubScreensNamesFailureState(error: e.code));
            } catch (e) {
              emit(
                DepartmentGetSubScreensNamesFailureState(error: e.toString()),
              );
            }
          },
          onError: (error) {
            if (error is FirebaseException) {
              emit(DepartmentGetSubScreensNamesFailureState(error: error.code));
            } else {
              emit(
                DepartmentGetSubScreensNamesFailureState(
                  error: error.toString(),
                ),
              );
            }
          },
        );
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
      emit(DepartmentCreateSubScreensNamesSuccessState(docReference: docRef));
      if (subScreensList.isNotEmpty) {
        changeSelectedSubScreen(
          subScreenButtonId: subScreensList.first.uid,
          index: 0,
        );
      }
    } on FirebaseException catch (e) {
      emit(DepartmentCreateSubScreensNamesFailureState(failure: e.code));
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
    } on FirebaseException catch (e) {
      emit(DepartmentUpdateSubScreensNamesFailureState(failure: e.code));
    } on Exception catch (e) {
      emit(DepartmentUpdateSubScreensNamesFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteSubScreen({required String subScreenUID}) async {
    try {
      emit(DepartmentDeleteSubScreensNamesLoadingState());

      final subScreenDocRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenUID);
      await deleteCollection(subScreenDocRef.collection('sub_title_name'));
      await deleteCollection(subScreenDocRef.collection('Buttons'));

      // امسح الـdoc نفسه
      await subScreenDocRef.delete();
      if (subScreensList.isNotEmpty) {
        changeSelectedSubScreen(
          subScreenButtonId: subScreensList.first.uid,
          index: 0,
        );
      } else {
        selectedSubScreenID = null;
      }
      emit(DepartmentDeleteSubScreensNamesSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentDeleteSubScreensNamesFailureState(failure: e.code));
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
  }) {
    selectedSubScreenID = subScreenButtonId;
    selectedSubScreenIndex = index;
    emit(DepartmentChangeSubScreenState());

    // شغل الـ listeners الخاصة بالـ subScreen الجديد
    listenToMenuTitle();
    listenToMenuButtons();
    listenToCarousel();
  }

  ///--------------Carousel CRUD operations--------------
  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(DepartmentChangeCarouselIndexState());
  }

  void listenToCarousel() {
    emit(DepartmentGetCarouselLoadingState());
    _carouselSub?.cancel();

    _carouselSub = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('carousel_items')
        .snapshots()
        .listen(
          (snapshot) {
            try {
              carouselItemsList =
                  snapshot.docs
                      .map((doc) => CarouselItemModel.fromDoc(doc))
                      .toList();

              emit(DepartmentGetCarouselSuccessState());
            } on FirebaseException catch (e) {
              emit(DepartmentGetCarouselFailureState(failure: e.code));
            } catch (e) {
              emit(DepartmentGetCarouselFailureState(failure: e.toString()));
            }
          },
          onError: (error) {
            if (error is FirebaseException) {
              emit(DepartmentGetCarouselFailureState(failure: error.code));
            } else {
              emit(
                DepartmentGetCarouselFailureState(failure: error.toString()),
              );
            }
          },
        );
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
      emit(DepartmentCreateCarouselFailureState(failure: e.code));
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
      emit(DepartmentRemoveCarouselFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentRemoveCarouselFailureState(failure: e.toString()));
    }
  }

  ///--------------MenuTitle CRUD operations--------------

  void listenToMenuTitle() {
    emit(DepartmentGetMenuTitleLoadingState());
    _menuTitleSub?.cancel();

    _menuTitleSub = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('sub_title_name')
        .snapshots()
        .listen(
          (snapshot) {
            try {
              if (snapshot.docs.isEmpty) {
                emit(DepartmentGetMenuTitleEmptyState());
                return;
              }
              final data = snapshot.docs.first.data();
              final menuTitleModel = MenuTitleModel.fromMap(data);
              emit(
                DepartmentGetMenuTitleSuccessState(
                  menuTitleModel: menuTitleModel,
                ),
              );
            } on FirebaseException catch (e) {
              emit(DepartmentGetMenuTitleFailureState(failure: e.code));
            } catch (e) {
              emit(DepartmentGetMenuTitleFailureState(failure: e.toString()));
            }
          },
          onError: (error) {
            if (error is FirebaseException) {
              emit(DepartmentGetMenuTitleFailureState(failure: error.code));
            } else {
              emit(
                DepartmentGetMenuTitleFailureState(failure: error.toString()),
              );
            }
          },
        );
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

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;

        await docRef.update({
          'menu_title': menuTitle,
          'updated_at': DateTime.now(),
        });
      }
      emit(DepartmentUpdateMenuTitleSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentUpdateMenuTitleFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentUpdateMenuTitleFailureState(failure: e.toString()));
    }
  }

  ///--------------MenuButtons CRUD operations--------------
  void changeMenuButtonIndex({required int index, required String buttonId}) {
    selectedMenuButtonId = buttonId;
    selectedButtonIndex = index;
    emit(DepartmentChangeMenuButtonIndexState());
  }

  Future<void> createMenuButton({required String buttonTitle}) async {
    try {
      emit(DepartmentCreateMenuButtonLoadingState());

      final docRef =
          firestore
              .collection(rootCollectionName)
              .doc(departmentId)
              .collection('super_categories')
              .doc(selectedSubScreenID)
              .collection('Buttons')
              .doc(); // 👈 هنخلي Firestore يولد ID

      final newButton = MenuButtonModel(
        uid: docRef.id,
        buttonTitle: buttonTitle.trim(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: null,
      );

      await docRef.set(newButton.toMap());

      emit(DepartmentCreateMenuButtonSuccessState(menuButton: newButton));
    } on FirebaseException catch (e) {
      emit(DepartmentCreateMenuButtonFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentCreateMenuButtonFailureState(failure: e.toString()));
    }
  }

  void listenToMenuButtons() {
    emit(DepartmentGetMenuButtonLoadingState());
    _menuButtonsSub?.cancel();

    _menuButtonsSub = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('Buttons')
        .snapshots()
        .listen(
          (snapshot) {
            try {
              menuButtonList =
                  snapshot.docs
                      .map((doc) => MenuButtonModel.fromMap(doc.data()))
                      .toList();

              emit(DepartmentGetMenuButtonSuccessState());
            } on FirebaseException catch (e) {
              emit(DepartmentGetMenuButtonFailureState(failure: e.code));
            } catch (e) {
              emit(DepartmentGetMenuButtonFailureState(failure: e.toString()));
            }
          },
          onError: (error) {
            if (error is FirebaseException) {
              emit(DepartmentGetMenuButtonFailureState(failure: error.code));
            } else {
              emit(
                DepartmentGetMenuButtonFailureState(failure: error.toString()),
              );
            }
          },
        );
  }

  Future<void> updateMenuButton({
    required String buttonId,
    required String newTitle,
  }) async {
    try {
      emit(DepartmentUpdateMenuButtonLoadingState());

      final docRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(buttonId);

      await docRef.update({
        'button_title': newTitle.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      emit(DepartmentUpdateMenuButtonSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentUpdateMenuButtonFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentUpdateMenuButtonFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteMenuButton({required String buttonId}) async {
    try {
      emit(DepartmentDeleteMenuButtonLoadingState());

      final docRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(buttonId);

      await docRef.delete();

      emit(DepartmentDeleteMenuButtonSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentDeleteMenuButtonFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentDeleteMenuButtonFailureState(failure: e.toString()));
    }
  }

  ///--------------MenuItems CRUD operations--------------
  Future<void> createMenuItem({
    required String title,
    required String price,
    required String imagePath,
  }) async {
    try {
      emit(DepartmentCreateMenuItemLoadingState());

      // Reference للـ collection بتاع الـ menu items
      final collectionRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedMenuButtonId)
          .collection('Buttons')
          .doc(selectedMenuButtonId)
          .collection('menu_items');

      // اعمل document جديد (Firestore هيولد uid)
      final docRef = collectionRef.doc();
      // crreate menu item model
      final MenuItemModel menuItemModel = MenuItemModel(
        id: docRef.id,
        title: title,
        image: imagePath,
        price: price,
        averageRating: 0.0,
        ratingCount: 0,
        menuButtonId: selectedMenuButtonId!,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await docRef.set(menuItemModel.toMap());

      emit(DepartmentCreateMenuItemSuccessState(menuItem: menuItemModel));
    } on FirebaseException catch (e) {
      emit(DepartmentCreateMenuItemFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentCreateMenuItemFailureState(failure: e.toString()));
    }
  }

  ///--------------close the cubit--------------
  @override
  Future<void> close() {
    _subScreensSub?.cancel();
    _menuTitleSub?.cancel();
    _menuButtonsSub?.cancel();
    _carouselSub?.cancel();
    return super.close();
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
