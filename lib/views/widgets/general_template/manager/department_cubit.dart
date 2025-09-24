import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';

import '../../../../helper_functions/collection_exists.dart';
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
  DepartmentCubit({required this.canManage, required this.departmentId})
    : super(DepartmentInitial());

  final String departmentId;
  final bool canManage;

  ///-------------Variables-------------
  //selected subScreen title
  String selectedSubScreen = '';
  Map<String, String> subScreenMap = {};
  String? selectedSubScreenID;
  int? selectedSubScreenIndex = 0;
  List<SubScreenModel> subScreensList = [];

  //Carousel tracking
  int currentCarouselIndex = 0;
  List<CarouselItemModel> carouselItemsList = [];

  //MenuTitle
  MenuTitleModel? selectedMenuTitle;

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

  ///------------Cache Maps--------------

  Map<String, Map<MenuButtonModel, List<MenuItemModel>>> subScreenCache = {};
  Map<String, List<CarouselItemModel>> carouselCache = {};
  Map<String, MenuTitleModel?> menuTitleCache = {};

  ///-------------Functions-------------

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
              if (subScreensList.isNotEmpty) {
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
    emit(DepartmentDeleteSubScreensNamesLoadingState());

    try {
      final batch = firestore.batch();

      final subScreenDocRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenUID);

      // 🔹 Delete menu title (sub_title_name collection)
      final titlesSnapshot =
          await subScreenDocRef.collection('sub_title_name').get();
      for (var titleDoc in titlesSnapshot.docs) {
        batch.delete(titleDoc.reference);
      }

      // 🔹 Delete buttons + items (+ complaints if hasFeedback)
      final buttonsSnapshot = await subScreenDocRef.collection('Buttons').get();
      for (var buttonDoc in buttonsSnapshot.docs) {
        final itemsSnapshot =
            await buttonDoc.reference.collection('menu_items').get();

        for (var itemDoc in itemsSnapshot.docs) {
          final itemId = itemDoc.id;
          final data = itemDoc.data();

          final hasFeedback = data['hasFeedback'] == true;

          if (hasFeedback) {
            // ✅ Delete feedback docs
            final feedbackSnapshot =
                await firestore
                    .collection('menu_items_complaint')
                    .doc(itemId)
                    .collection('feedback')
                    .get();
            for (var fbDoc in feedbackSnapshot.docs) {
              batch.delete(fbDoc.reference);
            }

            // ✅ Delete complaint parent doc
            final complaintDocRef = firestore
                .collection('menu_items_complaint')
                .doc(itemId);
            batch.delete(complaintDocRef);
          }

          // ✅ Delete menu item
          batch.delete(itemDoc.reference);
        }

        // ✅ Delete button itself
        batch.delete(buttonDoc.reference);
      }

      // 🔹 Delete carousel
      final carouselSnapshot =
          await subScreenDocRef.collection('carousel_items').get();
      for (var carouselDoc in carouselSnapshot.docs) {
        batch.delete(carouselDoc.reference);
      }

      // 🔹 Delete the subScreen itself
      batch.delete(subScreenDocRef);

      // ✅ Execute everything atomically
      await batch.commit();

      // 🔹 Update local cache
      subScreensList.removeWhere((s) => s.uid == subScreenUID);

      if (subScreensList.isEmpty) {
        selectedSubScreenID = null;
        selectedSubScreenIndex = null;

        carouselItemsList.clear();
        selectedMenuTitle = null;
        menuButtonList.clear();
        menuItemsList.clear();

        emit(DepartmentAllSubScreensClearedState());
      } else {
        carouselItemsList.clear();
        selectedMenuTitle = null;
        menuButtonList.clear();
        menuItemsList.clear();

        final firstSubScreen = subScreensList.first;
        await changeSelectedSubScreen(
          subScreenButtonId: firstSubScreen.uid,
          index: 0,
        );
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

    // ✅ Menu Buttons + Items من الكاش
    if (subScreenCache.containsKey(subScreenButtonId)) {
      final buttonsMap = subScreenCache[subScreenButtonId]!;

      menuButtonList = buttonsMap.keys.toList();

      if (menuButtonList.isNotEmpty) {
        final firstButton = menuButtonList.first;
        selectedMenuButtonId = firstButton.uid;
        // menuItemsList = buttonsMap[firstButton] ?? [];
        changeMenuButtonIndex(index: 0, buttonId: selectedMenuButtonId!);
      } else {
        selectedMenuButtonId = null;
        menuItemsList = [];
      }

      emit(DepartmentGetMenuButtonSuccessState());
      emit(DepartmentGetMenuItemSuccessState(menuItem: menuItemsList));
    } else {
      await listenToMenuButtons();
    }
    // ✅ Carousel
    if (carouselCache.containsKey(subScreenButtonId)) {
      carouselItemsList = carouselCache[subScreenButtonId]!;
      emit(DepartmentGetCarouselSuccessState());
    } else {
      await listenToCarousel();
    }

    // ✅ Menu Title
    if (menuTitleCache.containsKey(subScreenButtonId)) {
      selectedMenuTitle = menuTitleCache[subScreenButtonId]!;
      emit(
        DepartmentGetMenuTitleSuccessState(menuTitleModel: selectedMenuTitle!),
      );
    } else {
      await listenToMenuTitle();
    }
  }

  ///--------------Carousel CRUD operations--------------
  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(DepartmentChangeCarouselIndexState());
  }

  Future<void> listenToCarousel() async {
    emit(DepartmentGetCarouselLoadingState());

    try {
      await _carouselSub
          ?.cancel(); // not really needed anymore, but safe to keep

      final collectionPath = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('carousel_items');

      final exists = await collectionExists(collectionRef: collectionPath);

      if (!exists || subScreensList.isEmpty) {
        carouselCache[selectedSubScreenID!] = [];
        emit(DepartmentGetCarouselEmptyState());
        return;
      }

      // 🔹 replace snapshots() with one-time get()
      final snapshot = await collectionPath.get();

      try {
        carouselItemsList =
            snapshot.docs.map((doc) => CarouselItemModel.fromDoc(doc)).toList();

        if (selectedSubScreenID != null) {
          carouselCache[selectedSubScreenID!] = carouselItemsList;
        }

        if (carouselItemsList.isEmpty) {
          emit(DepartmentGetCarouselEmptyState());
        } else {
          emit(DepartmentGetCarouselSuccessState());
        }
      } on FirebaseException catch (e) {
        emit(DepartmentGetCarouselFailureState(failure: e.code));
      } catch (e) {
        emit(DepartmentGetCarouselFailureState(failure: e.toString()));
      }
    } on FirebaseException catch (e) {
      emit(DepartmentGetCarouselFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentGetCarouselFailureState(failure: e.toString()));
    }
  }

  Future<void> createCarouselItem({required String imageUrl}) async {
    if (selectedSubScreenID == null) return;

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

      // ✅ Update local list
      carouselItemsList.add(newItem);

      // ✅ Update cache
      if (!carouselCache.containsKey(selectedSubScreenID)) {
        carouselCache[selectedSubScreenID!] = [];
      }
      carouselCache[selectedSubScreenID!]!.add(newItem);

      emit(DepartmentCreateCarouselSuccessState());
      emit(DepartmentGetCarouselSuccessState()); // عشان الـ UI يتبنى على طول
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

      // 🔥 Step 1: delete from Firestore
      await firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(subScreenId)
          .collection('carousel_items')
          .doc(carouselItemId)
          .delete();

      // 🔥 Step 2: update local list
      carouselItemsList.removeWhere((item) => item.uid == carouselItemId);

      // 🔥 Step 3: update cache
      if (carouselCache.containsKey(subScreenId)) {
        carouselCache[subScreenId]!.removeWhere(
          (item) => item.uid == carouselItemId,
        );
      }

      emit(DepartmentRemoveCarouselSuccessState());
      emit(DepartmentGetCarouselSuccessState()); // عشان الـ UI يrefresh على طول
    } on FirebaseException catch (e) {
      emit(DepartmentRemoveCarouselFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentRemoveCarouselFailureState(failure: e.toString()));
    }
  }

  ///--------------MenuTitle CRUD operations--------------

  Future<void> listenToMenuTitle() async {
    emit(DepartmentGetMenuTitleLoadingState());

    try {
      await _menuTitleSub?.cancel(); // safe to keep, even if not needed anymore

      final collectionPath = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('sub_title_name');

      final exists = await collectionExists(collectionRef: collectionPath);

      if (!exists || subScreensList.isEmpty) {
        menuTitleCache[selectedSubScreenID!] = null;
        emit(DepartmentGetMenuTitleEmptyState());
        return;
      }

      // 🔹 replace snapshots().listen with one-time get()
      final snapshot = await collectionPath.get();

      try {
        if (snapshot.docs.isEmpty) {
          menuTitleCache[selectedSubScreenID!] = null;
          emit(DepartmentGetMenuTitleEmptyState());
          return;
        }

        final data = snapshot.docs.first.data();
        final menuTitleModel = MenuTitleModel.fromMap(data);

        if (selectedSubScreenID != null) {
          selectedMenuTitle = menuTitleModel;
          menuTitleCache[selectedSubScreenID!] = menuTitleModel;
        }
        emit(
          DepartmentGetMenuTitleSuccessState(menuTitleModel: menuTitleModel),
        );
      } on FirebaseException catch (e) {
        emit(DepartmentGetMenuTitleFailureState(failure: e.code));
      } catch (e) {
        emit(DepartmentGetMenuTitleFailureState(failure: e.toString()));
      }
    } on FirebaseException catch (e) {
      emit(DepartmentGetMenuTitleFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentGetMenuTitleFailureState(failure: e.toString()));
    }
  }

  Future<void> updateMenuTitle({required String? menuTitle}) async {
    if (menuTitle == null || menuTitle.trim().isEmpty) {
      emit(
        DepartmentUpdateMenuTitleFailureState(
          failure: "Menu title cannot be empty",
        ),
      );
      return;
    }

    try {
      emit(DepartmentUpdateMenuTitleLoadingState());

      final subTitleCollection = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('sub_title_name');

      final querySnapshot = await subTitleCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
        // 🔥 لو فيه doc قديم -> نعمل update
        final docRef = querySnapshot.docs.first.reference;
        await docRef.update({
          'menu_title': menuTitle,
          'updated_at': DateTime.now(),
        });
      } else {
        // 🔥 لو مفيش -> نعمل create
        await subTitleCollection.add({
          'menu_title': menuTitle,
          'created_at': DateTime.now(),
        });
      }

      // 🔥 تحديث الكاش والـ state المحلي
      menuTitleCache[selectedSubScreenID!]?.menuTitle = menuTitle;

      emit(DepartmentUpdateMenuTitleSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentUpdateMenuTitleFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentUpdateMenuTitleFailureState(failure: e.toString()));
    }
  }

  ///--------------MenuButtons CRUD operations--------------

  /// تغيير الزرار
  Future<void> changeMenuButtonIndex({
    required int index,
    required String buttonId,
  }) async {
    selectedMenuButtonId = buttonId;
    selectedButtonIndex = index;
    emit(DepartmentChangeMenuButtonIndexState());

    final buttonsMap = subScreenCache[selectedSubScreenID];
    if (buttonsMap != null) {
      final selectedButton = buttonsMap.keys.firstWhereOrNull(
        (b) => b.uid == buttonId,
      );
      if (selectedButton != null) {
        menuItemsList = buttonsMap[selectedButton] ?? [];
      } else {
        menuItemsList = [];
      }
      menuItemsList = buttonsMap[selectedButton] ?? [];
      emit(DepartmentGetMenuItemSuccessState(menuItem: menuItemsList));
    } else {
      await listenToMenuItems();
    }
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
              .doc(); // Firestore يولد ID

      final newButton = MenuButtonModel(
        uid: docRef.id,
        buttonTitle: buttonTitle.trim(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: null,
      );

      await docRef.set(newButton.toMap());

      // ✅ تحديث الكاش
      final subScreenId = selectedSubScreenID!;
      subScreenCache.putIfAbsent(subScreenId, () => {});

      subScreenCache[subScreenId]![newButton] = [];

      emit(DepartmentCreateMenuButtonSuccessState(menuButton: newButton));
    } on FirebaseException catch (e) {
      emit(DepartmentCreateMenuButtonFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentCreateMenuButtonFailureState(failure: e.toString()));
    }
  }

  /// جلب الـ Menu Buttons + Items
  Future<void> listenToMenuButtons() async {
    emit(DepartmentGetMenuButtonLoadingState());

    try {
      await _menuButtonsSub?.cancel(); // no longer needed but safe to keep

      final collectionPath = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons');

      if (!await collectionExists(collectionRef: collectionPath)) {
        menuButtonList.clear();
        menuItemsList.clear();
        subScreenCache[selectedSubScreenID!] = {};
        emit(DepartmentGetMenuButtonEmptyState());
        return;
      }

      // 🔹 replace snapshots().listen with one-time get()
      final snapshot = await collectionPath.get();

      try {
        final buttons =
            snapshot.docs
                .map((doc) => MenuButtonModel.fromMap(doc.data()))
                .toList();

        if (buttons.isEmpty) {
          subScreenCache[selectedSubScreenID!] = {};
          selectedMenuButtonId = null;
          menuItemsList.clear();
          emit(DepartmentGetMenuButtonEmptyState());
          return;
        }

        // لف على الأزرار وهات الـ Items
        Map<MenuButtonModel, List<MenuItemModel>> tempMap = {};
        for (var button in buttons) {
          final itemsSnapshot =
              await firestore
                  .collection(rootCollectionName)
                  .doc(departmentId)
                  .collection('super_categories')
                  .doc(selectedSubScreenID)
                  .collection('Buttons')
                  .doc(button.uid!)
                  .collection('menu_items')
                  .get();

          final menuItems =
              itemsSnapshot.docs
                  .map((doc) => MenuItemModel.fromMap(doc.data(), id: doc.id))
                  .toList();

          tempMap[button] = menuItems;
        }

        // ✅ خزّن في الكاش
        subScreenCache[selectedSubScreenID!] = tempMap;

        // ✅ أول زرار افتراضي
        final firstButton = buttons.first;
        selectedMenuButtonId = firstButton.uid!;
        menuButtonList = buttons;
        menuItemsList = tempMap[firstButton] ?? [];

        emit(DepartmentGetMenuButtonSuccessState());
        emit(DepartmentGetMenuItemSuccessState(menuItem: menuItemsList));
      } on FirebaseException catch (e) {
        emit(DepartmentGetMenuButtonFailureState(failure: e.code));
      } catch (e) {
        emit(DepartmentGetMenuButtonFailureState(failure: e.toString()));
      }
    } on FirebaseException catch (e) {
      emit(DepartmentGetMenuButtonFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentGetMenuButtonFailureState(failure: e.toString()));
    }
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

      // ✅ تحديث في Firestore
      await docRef.update({
        'button_title': newTitle.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // ✅ تحديث الكاش
      final buttonsMap = subScreenCache[selectedSubScreenID];
      if (buttonsMap != null) {
        final oldEntry = buttonsMap.keys.firstWhereOrNull(
          (b) => b.uid == buttonId,
        );

        if (oldEntry != null) {
          final items = buttonsMap[oldEntry] ?? [];

          // زرار جديد بنفس الـ uid مع التايتل الجديد
          final updatedButton = MenuButtonModel(
            uid: oldEntry.uid,
            buttonTitle: newTitle.trim(),
            createdAt: oldEntry.createdAt,
            updatedAt: DateTime.now().toIso8601String(),
          );

          // شيل القديم وحط الجديد
          buttonsMap.remove(oldEntry);
          buttonsMap[updatedButton] = items;

          // لو عندك لستة buttons بتعرضها في الـ UI حدّثها برضه
          menuButtonList = buttonsMap.keys.toList();
        }
      }

      emit(DepartmentUpdateMenuButtonSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentUpdateMenuButtonFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentUpdateMenuButtonFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteMenuButton({required String buttonId}) async {
    emit(DepartmentDeleteMenuButtonLoadingState());

    try {
      final batch = firestore.batch();

      final docRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(buttonId);

      // ✅ هات كل الـ items المرتبطة بالزرار
      final itemsSnapshot = await docRef.collection('menu_items').get();

      for (var itemDoc in itemsSnapshot.docs) {
        final itemId = itemDoc.id;
        final data = itemDoc.data();

        final hasFeedback = data['hasFeedback'] == true;

        if (hasFeedback) {
          // ✅ امسح feedback docs
          final feedbackSnapshot =
              await firestore
                  .collection('menu_items_complaint')
                  .doc(itemId)
                  .collection('feedback')
                  .get();
          for (var fbDoc in feedbackSnapshot.docs) {
            batch.delete(fbDoc.reference);
          }

          // ✅ امسح complaint parent doc
          final complaintDocRef = firestore
              .collection('menu_items_complaint')
              .doc(itemId);
          batch.delete(complaintDocRef);
        }

        // ✅ امسح الـ item نفسه
        batch.delete(itemDoc.reference);
      }

      // ✅ في الآخر امسح الزرار نفسه
      batch.delete(docRef);

      // ✅ نفذ الحذف كله مع بعض
      await batch.commit();

      // ✅ تحديث الكاش
      final buttonsMap = subScreenCache[selectedSubScreenID];
      if (buttonsMap != null) {
        final toRemove = buttonsMap.keys.firstWhere((b) => b.uid == buttonId);

        buttonsMap.remove(toRemove);
        menuButtonList = buttonsMap.keys.toList();

        if (selectedMenuButtonId == buttonId) {
          if (menuButtonList.isNotEmpty) {
            selectedMenuButtonId = menuButtonList.first.uid;
            menuItemsList = buttonsMap[menuButtonList.first] ?? [];
          } else {
            selectedMenuButtonId = null;
            menuItemsList.clear();
          }
        }
      }

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

      // ✅ حضر الـ model
      final menuItemModel = MenuItemModel(
        id: "",
        title: title.trim(),
        image: imagePath,
        price: price,
        averageRating: 0.0,
        ratingCount: 0,
        menuButtonId: selectedMenuButtonId!,
        createdAt: DateTime.now(),
        updatedAt: null,
        hasFeedback: false,
      );

      // ✅ Reference للـ Firestore
      final docRef =
          firestore
              .collection(rootCollectionName)
              .doc(departmentId)
              .collection('super_categories')
              .doc(selectedSubScreenID)
              .collection('Buttons')
              .doc(selectedMenuButtonId)
              .collection('menu_items')
              .doc(); // Firestore يولد ID

      // ✅ خزّن في Firestore
      final newItem = menuItemModel.copyWith(id: docRef.id);
      await docRef.set(newItem.toMap());

      // ✅ حدّث الكاش
      final buttonsMap = subScreenCache[selectedSubScreenID];
      if (buttonsMap != null) {
        final selectedButton = buttonsMap.keys.firstWhere(
          (b) => b.uid == selectedMenuButtonId,
        );
        final currentItems = buttonsMap[selectedButton] ?? [];
        currentItems.add(newItem);
        buttonsMap[selectedButton] = currentItems;
      }

      // ✅ حدّث الـ list اللي UI بيستخدمها
      // menuItemsList.add(newItem);

      emit(DepartmentCreateMenuItemSuccessState(menuItem: newItem));
    } on FirebaseException catch (e) {
      emit(DepartmentCreateMenuItemFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentCreateMenuItemFailureState(failure: e.toString()));
    }
  }

  Future<void> listenToMenuItems() async {
    if (selectedMenuButtonId == null || selectedSubScreenID == null) return;

    emit(DepartmentGetMenuItemLoadingState());

    try {
      await _menuItem?.cancel(); // no longer needed but safe to keep

      final collectionPath = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(selectedMenuButtonId)
          .collection('menu_items');

      if (!await collectionExists(collectionRef: collectionPath)) {
        emit(DepartmentGetMenuItemEmptyState());
        return;
      }

      // 🔹 one-time fetch instead of snapshots().listen
      final snapshot = await collectionPath.get();

      try {
        final items =
            snapshot.docs
                .map((doc) => MenuItemModel.fromMap(doc.data(), id: doc.id))
                .toList();

        // ✅ تحديث الكاش
        final buttonsMap = subScreenCache[selectedSubScreenID];
        if (buttonsMap != null) {
          final selectedButton = buttonsMap.keys.firstWhereOrNull(
            (b) => b.uid == selectedMenuButtonId,
          );
          if (selectedButton != null) {
            buttonsMap[selectedButton] = items;
          }
        }

        menuItemsList = items;

        if (items.isEmpty) {
          emit(DepartmentGetMenuItemEmptyState());
        } else {
          emit(DepartmentGetMenuItemSuccessState(menuItem: menuItemsList));
        }
      } on FirebaseException catch (e) {
        emit(DepartmentGetMenuItemFailureState(failure: e.code));
      } catch (e) {
        emit(DepartmentGetMenuItemFailureState(failure: e.toString()));
      }
    } on FirebaseException catch (e) {
      emit(DepartmentGetMenuItemFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentGetMenuItemFailureState(failure: e.toString()));
    }
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

      if (title != null) updates['title'] = title.trim();
      if (price != null) updates['price'] = price;
      if (image != null) updates['image'] = image;

      // ✅ Firestore update
      final docRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(selectedMenuButtonId)
          .collection('menu_items')
          .doc(itemId);

      await docRef.update(updates);

      // ✅ Local update in cache
      final buttonsMap = subScreenCache[selectedSubScreenID];
      if (buttonsMap != null) {
        final selectedButton = buttonsMap.keys.firstWhere(
          (b) => b.uid == selectedMenuButtonId,
        );

        final currentItems = buttonsMap[selectedButton];
        if (currentItems != null) {
          final index = currentItems.indexWhere((item) => item.id == itemId);
          if (index != -1) {
            final oldItem = currentItems[index];
            final updatedItem = oldItem.copyWith(
              title: title ?? oldItem.title,
              price: price ?? oldItem.price,
              image: image ?? oldItem.image,
              updatedAt: DateTime.now(),
            );
            currentItems[index] = updatedItem;
            buttonsMap[selectedButton] = currentItems;

            // ✅ Update the UI list too
            final uiIndex = menuItemsList.indexWhere(
              (item) => item.id == itemId,
            );
            if (uiIndex != -1) {
              menuItemsList[uiIndex] = updatedItem;
            }
          }
        }
      }

      emit(DepartmentUpdateMenuItemSuccessState());
    } on FirebaseException catch (e) {
      emit(DepartmentUpdateMenuItemFailureState(failure: e.code));
    } catch (e) {
      emit(DepartmentUpdateMenuItemFailureState(failure: e.toString()));
    }
  }

  Future<void> deleteMenuItem({
    required String itemId,
    required bool hasFeedback,
  }) async {
    emit(DepartmentDeleteMenuItemLoadingState());

    try {
      final batch = firestore.batch();
      // 🔹 امسح feedbacks لو موجودة
      if (hasFeedback) {
        final snapshot =
            await firestore
                .collection("menu_items_complaint")
                .doc(itemId)
                .collection("feedback")
                .get();

        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }

        // امسح الـ parent document نفسه
        final complaintDocRef = firestore
            .collection("menu_items_complaint")
            .doc(itemId);
        batch.delete(complaintDocRef);
      }

      // 🔹 Reference للـ menu item نفسه
      final menuItemRef = firestore
          .collection(rootCollectionName)
          .doc(departmentId)
          .collection('super_categories')
          .doc(selectedSubScreenID)
          .collection('Buttons')
          .doc(selectedMenuButtonId)
          .collection('menu_items')
          .doc(itemId);

      // Add delete of menu item
      batch.delete(menuItemRef);

      // ✅ نفذ كل الحذف atomically
      await batch.commit();

      // ✅ بعد نجاح الحذف في Firestore حدث الكاش والـ UI
      final buttonsMap = subScreenCache[selectedSubScreenID];
      if (buttonsMap != null) {
        final selectedButton = buttonsMap.keys.firstWhere(
          (b) => b.uid == selectedMenuButtonId,
        );

        final currentItems = buttonsMap[selectedButton];
        if (currentItems != null) {
          currentItems.removeWhere((item) => item.id == itemId);
          buttonsMap[selectedButton] = currentItems;

          // ✅ Remove from UI list too
          menuItemsList.removeWhere((item) => item.id == itemId);
        }
      }

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
