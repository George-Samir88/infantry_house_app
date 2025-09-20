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
  StreamSubscription? _menuItem;

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

  Future<bool> collectionExists({
    required CollectionReference collectionRef,
  }) async {
    final snapshot = await collectionRef.limit(1).get();
    return snapshot.docs.isNotEmpty;
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
  Future<void> listenToSubScreens() async {
    emit(DepartmentGetSubScreensNamesLoadingState());
    _subScreensSub?.cancel();
    subScreensList.clear();
    final collectionPath = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories');

    if (!await collectionExists(collectionRef: collectionPath)) {
      emit(DepartmentGetSubScreensNamesEmptyState());
      return;
    }

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
                changeSelectedSubScreen(
                  subScreenButtonId: subScreensList.first.uid,
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
      final docRef =
          firestore
              .collection(rootCollectionName)
              .doc(departmentId)
              .collection('super_categories')
              .doc();
      if (subScreensList.isEmpty) {
        selectedSubScreenID = docRef.id;
      }
      await docRef.set(newSubScreen.toMap());
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
        subScreensList.clear();
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

  Future<void> changeSelectedSubScreen({
    required String subScreenButtonId,
    required int index,
  }) async {
    selectedSubScreenID = subScreenButtonId;
    selectedSubScreenIndex = index;
    emit(DepartmentChangeSubScreenState());
    menuButtonList.clear();
    menuItemsList.clear();
    // شغل الـ listeners الخاصة بالـ subScreen الجديد
    await listenToCarousel();
    await listenToMenuTitle();
    await listenToMenuButtons();
    await listenToMenuItems();
  }

  ///--------------Carousel CRUD operations--------------
  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(DepartmentChangeCarouselIndexState());
  }

  Future<void> listenToCarousel() async {
    emit(DepartmentGetCarouselLoadingState());
    _carouselSub?.cancel();
    final collectionPath = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('carousel_items');
    final exists = await collectionExists(collectionRef: collectionPath);
    if (!exists || subScreensList.isEmpty) {
      emit(DepartmentGetCarouselEmptyState());
      return;
    }
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

  Future<void> listenToMenuTitle() async {
    emit(DepartmentGetMenuTitleLoadingState());
    _menuTitleSub?.cancel();
    final collectionPath = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('sub_title_name');

    if (!await collectionExists(collectionRef: collectionPath) ||
        subScreensList.isEmpty) {
      emit(DepartmentGetMenuTitleEmptyState());
      return;
    }

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
    listenToMenuItems();
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

  Future<void> listenToMenuButtons() async {
    emit(DepartmentGetMenuButtonLoadingState());
    _menuButtonsSub?.cancel();
    final collectionPath = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('Buttons');
    if (!await collectionExists(collectionRef: collectionPath) ||
        subScreensList.isEmpty) {
      menuButtonList.clear();
      menuItemsList.clear();
      emit(DepartmentGetMenuButtonEmptyState());
      return;
    }

    _menuButtonsSub = collectionPath.snapshots().listen(
      (snapshot) {
        try {
          menuButtonList =
              snapshot.docs
                  .map((doc) => MenuButtonModel.fromMap(doc.data()))
                  .toList();
          if (menuButtonList.isEmpty) {
            selectedMenuButtonId = null;
            menuItemsList = [];
            emit(DepartmentGetMenuButtonEmptyState());
            return;
          }
          changeMenuButtonIndex(index: 0, buttonId: menuButtonList.first.uid!);
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
          emit(DepartmentGetMenuButtonFailureState(failure: error.toString()));
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
      final MenuItemModel menuItemModel = MenuItemModel(
        id: "",
        title: title,
        image: imagePath,
        price: price,
        averageRating: 0.0,
        ratingCount: 0,
        menuButtonId: selectedMenuButtonId!,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      final collectionRef = await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(selectedMenuButtonId)
          .collection('menu_items')
          .add(menuItemModel.toMap());
      await collectionRef.update({"id": collectionRef.id});
      // اعمل document جديد (Firestore هيولد uid)

      emit(DepartmentCreateMenuItemSuccessState(menuItem: menuItemModel));
    } on FirebaseException catch (e) {
      emit(DepartmentCreateMenuItemFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentCreateMenuItemFailureState(failure: e.toString()));
    }
  }

  Future<void> listenToMenuItems() async {
    emit(DepartmentGetMenuItemLoadingState());
    _menuItem?.cancel();
    final collectionPath = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('Buttons')
        .doc(selectedMenuButtonId)
        .collection('menu_items');

    if (!await collectionExists(collectionRef: collectionPath) ||
        subScreensList.isEmpty ||
        menuButtonList.isEmpty) {
      emit(DepartmentGetMenuItemEmptyState());
      return;
    }

    _menuItem = firestore
        .collection(rootCollectionName)
        .doc(departmentId)
        .collection('super_categories')
        .doc(selectedSubScreenID)
        .collection('Buttons')
        .doc(selectedMenuButtonId)
        .collection('menu_items')
        .snapshots()
        .listen(
          (snapshot) {
            try {
              menuItemsList =
                  snapshot.docs
                      .map(
                        (doc) => MenuItemModel.fromMap(doc.data(), id: doc.id),
                      )
                      .toList();
              emit(DepartmentGetMenuItemSuccessState(menuItem: menuItemsList));
            } on FirebaseException catch (e) {
              emit(DepartmentGetMenuItemFailureState(failure: e.code));
            } catch (e) {
              emit(DepartmentGetMenuItemFailureState(failure: e.toString()));
            }
          },
          onError: (error) {
            if (error is FirebaseException) {
              emit(DepartmentGetMenuItemFailureState(failure: error.code));
            } else {
              emit(
                DepartmentGetMenuItemFailureState(failure: error.toString()),
              );
            }
          },
        );
  }

  Future<void> updateMenuItem({
    required String itemId,
    String? title,
    String? price,
    String? image,
  }) async {
    try {
      emit(DepartmentUpdateMenuItemLoadingState());

      final Map<String, dynamic> updates = {
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (title != null) updates['title'] = title;
      if (price != null) updates['price'] = price;
      if (image != null) updates['image'] = image;

      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(selectedMenuButtonId)
          .collection('menu_items')
          .doc(itemId)
          .update(updates);

      emit(DepartmentUpdateMenuItemSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentUpdateMenuItemFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentUpdateMenuItemFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteMenuItem({required String itemId}) async {
    try {
      emit(DepartmentDeleteMenuItemLoadingState());

      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(selectedMenuButtonId)
          .collection('menu_items')
          .doc(itemId)
          .delete();

      emit(DepartmentDeleteMenuItemSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentDeleteMenuItemFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentDeleteMenuItemFailureState(failure: e.toString()));
    }
  }

  ///--------------close the cubit--------------
  @override
  Future<void> close() {
    _subScreensSub?.cancel();
    _menuTitleSub?.cancel();
    _menuButtonsSub?.cancel();
    _carouselSub?.cancel();
    _menuItem?.cancel();
    return super.close();
  }
}
