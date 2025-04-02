import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/models/screen_data_model.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';
import 'package:infantry_house_app/utils/custom_carousel_item.dart';

part 'department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  DepartmentCubit({
    required Map<String, ScreenData> initialScreensMap,
    required String initialSelectedScreen,
  }) : super(DepartmentInitial()) {
    screensMap = initialScreensMap;
    newScreensMap = Map.from(initialScreensMap); // Deep copy to avoid mutation
    selectedScreen =
        initialSelectedScreen.isNotEmpty &&
                initialScreensMap.containsKey(initialSelectedScreen)
            ? initialSelectedScreen
            : initialScreensMap.keys.isNotEmpty
            ? initialScreensMap.keys.first
            : '';
    initializeState();
  }

  late Map<String, ScreenData> screensMap;
  Map<String, ScreenData> newScreensMap = {};
  late String selectedScreen;

  // Carousel tracking
  int currentCarouselIndex = 0;

  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(DepartmentChangeCarouselState());
  }

  // Carousel CRUD Operations
  void addCarouselItem({required CustomCarouselItem customCarouselItem}) {
    newScreensMap[selectedScreen]!.carouselWidgets.add(customCarouselItem);
    emit(DepartmentAddNewCarouselState());
  }

  void removeCarouselItem({required int index}) {
    newScreensMap[selectedScreen]!.carouselWidgets.removeAt(index);
    emit(DepartmentRemoveCarouselState());
  }

  // Initialization
  void initializeState() {
    if (newScreensMap.isNotEmpty && selectedScreen.isNotEmpty) {
      resetScreenSelection();
    }
    emit(DepartmentInitializationState());
  }

  ScreenData getScreenData(String key) {
    return screensMap[key]!;
  }

  List<String> getScreenKeys() {
    return screensMap.keys.toList();
  }

  int selectedButtonCategoryIndex = 0;
  int selectedButtonIndex = 0;
  bool isEmptyMenuItems = true;
  List<MenuItemModel> listToBeShow = [];

  // Screens CRUD Operations
  void addNewScreen({required String screenTitle}) {
    newScreensMap[screenTitle] = ScreenData(
      carouselWidgets: [],
      buttonsAndItemsMap: {},
      menuTitle: '',
    );
    emit(DepartmentAddNewCategoryState());
  }

  void removeScreen({required String screenTitle}) {
    newScreensMap.remove(screenTitle);
    resetScreenSelection();
    emit(DepartmentRemoveCategoryState());
  }

  void resetScreenSelection() {
    if (newScreensMap.isNotEmpty) {
      selectedButtonCategoryIndex = 0;
      changeSelectedScreen(buttonCategoryTitle: newScreensMap.keys.first);
    } else {
      selectedScreen = "";
      changeSelectedScreen(buttonCategoryTitle: 'emptyScreen');
    }
    emit(DepartmentResetCategorySelectionState());
  }

  void changeSelectedScreen({required String buttonCategoryTitle}) {
    selectedScreen = buttonCategoryTitle;
    selectedButtonIndex = 0;
    listToBeShow = [];

    if (newScreensMap.containsKey(selectedScreen)) {
      if (newScreensMap[selectedScreen]!.buttonsAndItemsMap.isNotEmpty) {
        String firstButtonTitle =
            newScreensMap[selectedScreen]!.buttonsAndItemsMap.keys.first;
        isEmptyMenuItems = false;
        listToBeShow =
            newScreensMap[selectedScreen]!
                .buttonsAndItemsMap[firstButtonTitle]!;
      }
    } else {
      listToBeShow = [];
    }
    emit(DepartmentChangeScreenState());
  }

  // Buttons CRUD Operations
  void addNewButton({required String screenName, required String buttonTitle}) {
    newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle] = [];
    listToBeShow = [];
    if (newScreensMap[screenName]!.buttonsAndItemsMap.isEmpty) {
      isEmptyMenuItems = true;
    }
    isEmptyMenuItems = false;
    resetButtonSelection(screenName: screenName);
    emit(DepartmentAddNewButtonState());
  }

  void removeButton({required String screenName, required String buttonTitle}) {
    listToBeShow = [];
    newScreensMap[screenName]!.buttonsAndItemsMap.remove(buttonTitle);
    if (newScreensMap[screenName]!.buttonsAndItemsMap.isNotEmpty) {
      updateSelectedList(
        buttonTitle: newScreensMap[screenName]!.buttonsAndItemsMap.keys.first,
        screenName: screenName,
      );
      resetButtonSelection(screenName: screenName);
    } else {
      isEmptyMenuItems = true;
    }
    emit(DepartmentRemoveButtonState());
  }

  void editButtonName({required String newCategoryTitle}) {
    newScreensMap[selectedScreen]!.menuTitle = newCategoryTitle;
    emit(DepartmentEditButtonNameState());
  }

  void resetButtonSelection({required String screenName}) {
    selectedButtonIndex = 0;
    if (newScreensMap[screenName]!.buttonsAndItemsMap.isNotEmpty) {
      listToBeShow = newScreensMap[screenName]!.buttonsAndItemsMap.values.first;
    } else {
      listToBeShow = [];
    }
    emit(DepartmentResetMenuSelection());
  }

  void updateSelectedList({
    required String screenName,
    required String buttonTitle,
  }) {
    listToBeShow = newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle]!;
    emit(DepartmentUpdateSelectedListState());
  }

  // Items CRUD Operations
  void addItem({
    required String screenName,
    required MenuItemModel menuItemModel,
    required String buttonTitle,
  }) {
    newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle]!.add(
      menuItemModel,
    );
    emit(DepartmentAddNewItemState());
  }

  void removeItem({
    required String screenName,
    required String buttonTitle,
    required int indexOfItemInList,
  }) {
    newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle]!.removeAt(
      indexOfItemInList,
    );
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
    final item =
        newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle]![listIndex];
    if (newImage != null && item.image != newImage) {
      item.image = newImage;
    }
    if (newTitle != null && item.title != newTitle) {
      item.title = newTitle;
    }
    if (newPrice != null && item.price != newPrice) {
      item.price = newPrice;
    }
    emit(DepartmentUpdateItemState());
  }
}
