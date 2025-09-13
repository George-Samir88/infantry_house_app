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
  String selectedDepartment = '';

  //selected subScreen title
  String selectedSubScreen = '';

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
