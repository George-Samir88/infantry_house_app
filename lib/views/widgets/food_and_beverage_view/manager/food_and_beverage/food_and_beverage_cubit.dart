import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:infantry_house_app/models/screen_data_model.dart';

import '../../../../../models/menu_item_model.dart';
import '../../../../widgets_2/food_and_beverage_view/custom_carousel_item.dart';

part 'food_and_beverage_state.dart';

class FoodAndBeverageCubit extends Cubit<FoodAndBeverageState> {
  FoodAndBeverageCubit() : super(FoodAndBeverageInitial());

  late Map<String, ScreenData> screensMap;
  Map<String, ScreenData> newScreensMap = {};
  late String selectedScreen;

  List<Widget> carouselItems = [
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee2.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee2.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
  ];
  List<Widget> carouselItems2 = [
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee2.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
  ];

  ///-----------------------Carousel Items Crud Operations-----------------------
  void addCarouselItem({required CustomCarouselItem customCarouselItem}) {
    newScreensMap[selectedScreen]!.carouselWidgets.add(customCarouselItem);
    emit(FoodAndBeverageAddNewCarouselState());
  }

  void removeCarouselItem({required int index}) {
    newScreensMap[selectedScreen]!.carouselWidgets.removeAt(index);
    emit(FoodAndBeverageRemoveCarouselState());
  }

  void initializeMapBetweenScreensAndData() {
    initializeMapBetweenButtonsAndItems();
    screensMap = {
      "باراديس": ScreenData(
        carouselWidgets: carouselItems,
        buttonsAndItemsMap: newAllButtonsAndItemsParadiseMap,
        menuTitle: 'قائمة الطعام',
      ),
      "كافيهات": ScreenData(
        carouselWidgets: carouselItems2,
        buttonsAndItemsMap: newAllButtonsAndItemsCafesMap,
        menuTitle: 'قائمة المشروبات',
      ),
      "فنادق": ScreenData(
        carouselWidgets: [],
        buttonsAndItemsMap: {},
        menuTitle: "",
      ),
    };
    newScreensMap = screensMap;
    if (newScreensMap.isNotEmpty) {
      selectedScreen = "باراديس";
    } else if (newScreensMap.isEmpty) {
      selectedScreen = "";
    }
    emit(FoodAndBeverageInitializeScreensMapState());
  }

  ScreenData getScreenData(String key) {
    return screensMap[key]!;
  }

  /// Get the list of screen names (keys)
  int selectedButtonCategoryIndex = 0;

  List<String> getScreenKeys() {
    return newScreensMap.keys.toList();
  }
  int selectedIndex = 0; // Track selected button index

  bool isEmptyMenuItems = true;

  List<MenuItemModel> listToBeShow = [];

  ///---------------Screens CRUD Operations---------------
  void addNewScreen({required String screenTitle}) {
    newScreensMap[screenTitle] = ScreenData(
      carouselWidgets: [],
      buttonsAndItemsMap: {},
      menuTitle: '',
    );
    emit(FoodAndBeverageAddNewScreen());
  }

  void removeScreen({required String screenTitle}) {
    newScreensMap.remove(screenTitle);
    resetScreenSelection();
    print(selectedScreen);
    emit(FoodAndBeverageRemoveScreen());
  }
  void resetScreenSelection() {
    if (newScreensMap.isNotEmpty) {
      selectedButtonCategoryIndex = 0;
      changeSelectedScreen(buttonCategoryTitle: newScreensMap.keys.first);
    } else {
     selectedScreen = "";
     changeSelectedScreen(buttonCategoryTitle: 'emptyScreen');
    }
    emit(FoodAndBeverageResetScreenSelection());
  }

  void changeSelectedScreen({required String buttonCategoryTitle}) {
    selectedScreen = buttonCategoryTitle;
    selectedIndex = 0;
    listToBeShow = [];
    if (newScreensMap.containsKey(selectedScreen)) {
      if (newScreensMap[selectedScreen]?.buttonsAndItemsMap.isNotEmpty ??
          false) {
        String firstButtonTitle =
            newScreensMap[selectedScreen]!.buttonsAndItemsMap.keys.first;
        listToBeShow =
            newScreensMap[selectedScreen]!
                .buttonsAndItemsMap[firstButtonTitle]!;
      }
    } else {
      listToBeShow = [];
    }
    // selectedScreen = getScreenKeys()[getScreenKeys().indexOf(buttonTitle)];
    emit(FoodAndBeverageChangeScreenState());
  }

  Map<String, List<MenuItemModel>> allButtonsAndItemsParadiseMap = {};
  Map<String, List<MenuItemModel>> newAllButtonsAndItemsParadiseMap = {};
  Map<String, List<MenuItemModel>> allButtonsAndItemsCafesMap = {};
  Map<String, List<MenuItemModel>> newAllButtonsAndItemsCafesMap = {};

  ///initialize map between buttons and items
  late String selectedButtonTitle;

  void initializeMapBetweenButtonsAndItems() {
    allButtonsAndItemsParadiseMap = {
      "لحوم": latteList1,
      "طيور": coffeeList1,
      "طواجن": latteList2,
      "مشويات": coffeeList2,
      "فواكه البحر": latteList3,
      "معجنات": coffeeList3,
      "مقبلات": latteList4,
      "شوربة": coffeeList4,
      // "أطباق جانبية": latteList5,
      // "إفطار": coffeeList5,
      // "ركن الأطفال": latteList6,
      // "طلبات إضافية للأطفال": coffeeList6,
      // "ركن السلطات": latteList7,
      // "سلطات غربية": coffeeList7,
      // "ركن السندوتشات": latteList8,
      // "ركن الحلو": coffeeList8,
    };
    allButtonsAndItemsCafesMap = {
      "مانجو": latteList5,
      "قهوة": coffeeList5,
      "فراولة": latteList6,
      "جوافة": coffeeList6,
      "أناناس": latteList7,
      "موز": coffeeList7,
      "شاي": latteList8,
      "كوكتيل": coffeeList7,
    };

    if (allButtonsAndItemsParadiseMap.isNotEmpty &&
        allButtonsAndItemsCafesMap.isNotEmpty) {
      listToBeShow = allButtonsAndItemsParadiseMap["لحوم"]!;
      isEmptyMenuItems = false;
      newAllButtonsAndItemsParadiseMap = allButtonsAndItemsParadiseMap;
      newAllButtonsAndItemsCafesMap = allButtonsAndItemsCafesMap;
    }
    emit(CustomMenuInitializeListOfListOfItemState());
  }

  ///this mapping is between screens and buttons title contains its items
  Map<String, Map<String, List<MenuItemModel>>>
  mapBetweenScreenTitlesAndButtonsTitle = {};
  Map<String, Map<String?, List<MenuItemModel>?>?>
  newMapBetweenScreenTitlesAndButtonsTitle = {};


  ///---------------Buttons CRUD Operations---------------

  void addNewButton({required String screenName, required String buttonTitle}) {
    newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle] = [];
    listToBeShow = [];
    if (screensMap[screenName]!.buttonsAndItemsMap.isEmpty) {
      isEmptyMenuItems = true;
    }
    isEmptyMenuItems = false;
    resetButtonSelection(screenName: screenName);
    emit(CustomButtonAndAddMenuState());
  }

  void resetButtonSelection({required String screenName}) {
    selectedIndex = 0;
    if (newScreensMap[screenName]!.buttonsAndItemsMap.isNotEmpty) {
      listToBeShow = newScreensMap[screenName]!.buttonsAndItemsMap.values.first;
    } else {
      listToBeShow = [];
    }
    emit(CustomButtonAndMenuUpdated());
  }

  void removeButton({required String screenName, required String buttonTitle}) {
    listToBeShow = [];
    newScreensMap[screenName]!.buttonsAndItemsMap.remove(buttonTitle);
    // newMapBetweenScreenTitlesAndButtonsTitle[screenName]!.remove(buttonTitle);
    if (newScreensMap[screenName]!.buttonsAndItemsMap.isNotEmpty) {
      updateSelectedList(
        buttonTitle: newScreensMap[screenName]!.buttonsAndItemsMap.keys.first,
        screenName: screenName,
      );
      resetButtonSelection(screenName: screenName);
    } else if (newScreensMap[screenName]!.buttonsAndItemsMap.isEmpty) {
      isEmptyMenuItems = true;
    }
    emit(CustomButtonAndRemoveMenuState());
  }

  void updateSelectedList({
    required String screenName,
    required String buttonTitle,
  }) {
    listToBeShow = screensMap[screenName]!.buttonsAndItemsMap[buttonTitle]!;
    emit(CustomButtonUpdateSelectedList());
  }

  ///---------------Items CRUD Operations---------------

  void addItem({
    required String screenName,
    required MenuItemModel menuItemModel,
    required String buttonTitle,
  }) {
    newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle]!.add(
      menuItemModel,
    );
    emit(CustomButtonAndAddMenuState());
  }

  void removeItem({
    required String screenName,
    required String buttonTitle,
    required int indexOfItemInList,
  }) {
    newScreensMap[screenName]!.buttonsAndItemsMap[buttonTitle]!.removeAt(
      indexOfItemInList,
    );
    emit(CustomMenuRemoveItemState());
  }

  void updateItem({
    required String buttonTitle,
    required listIndex,
    required String screenName,
    String? newTitle,
    String? newImage,
    String? newPrice,
  }) {
    if (true) {
      if (newImage != null &&
          newScreensMap[screenName]!
                  .buttonsAndItemsMap[buttonTitle]![listIndex]
                  .image !=
              newImage) {
        newScreensMap[screenName]!
            .buttonsAndItemsMap[buttonTitle]![listIndex]
            .image = newImage;
      }
      if (newTitle != null &&
          newScreensMap[screenName]!
                  .buttonsAndItemsMap[buttonTitle]![listIndex]
                  .title !=
              newTitle) {
        newScreensMap[screenName]!
            .buttonsAndItemsMap[buttonTitle]![listIndex]
            .title = newTitle;
      }
      if (newPrice != null &&
          newScreensMap[screenName]!
                  .buttonsAndItemsMap[buttonTitle]![listIndex]
                  .price !=
              newPrice) {
        newScreensMap[screenName]!
            .buttonsAndItemsMap[buttonTitle]![listIndex]
            .price = newPrice;
      }
      emit(CustomMenuUpdateItemState());
    }
  }

  ///----------Buttons title-------------
  //----------------------------------------Button List-------------------------------------------
  List<MenuItemModel> latteList1 = [
    MenuItemModel(
      title: 'Vanilla Latte',
      price: '28.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Caramel Latte',
      price: '30.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Hazelnut Latte',
      price: '29.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Iced Latte',
      price: '27.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Mocha Latte',
      price: '32.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
  ];

  List<MenuItemModel> latteList2 = [
    MenuItemModel(
      title: 'Cinnamon Latte',
      price: '26.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Pumpkin Spice Latte',
      price: '31.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'White Chocolate Latte',
      price: '33.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Matcha Latte',
      price: '30.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Lavender Latte',
      price: '28.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
  ];

  List<MenuItemModel> latteList3 = [
    MenuItemModel(
      title: 'Salted Caramel Latte',
      price: '32.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Peppermint Latte',
      price: '29.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Coconut Latte',
      price: '27.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Honey Latte',
      price: '30.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Almond Latte',
      price: '28.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
  ];

  List<MenuItemModel> latteList4 = [
    MenuItemModel(
      title: 'Spiced Latte',
      price: '31.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Rose Latte',
      price: '33.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Maple Latte',
      price: '26.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Gingerbread Latte',
      price: '30.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Cherry Latte',
      price: '29.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
  ];

  List<MenuItemModel> latteList5 = [
    MenuItemModel(
      title: 'Oat Milk Latte',
      price: '34.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Soy Latte',
      price: '32.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Condensed Milk Latte',
      price: '30.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Irish Cream Latte',
      price: '35.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Amaretto Latte',
      price: '31.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
  ];

  List<MenuItemModel> latteList6 = [
    MenuItemModel(
      title: 'Butterscotch Latte',
      price: '29.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Tiramisu Latte',
      price: '33.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Cookie Dough Latte',
      price: '30.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Raspberry Latte',
      price: '28.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Blueberry Latte',
      price: '32.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
  ];

  List<MenuItemModel> latteList7 = [
    MenuItemModel(
      title: 'Pistachio Latte',
      price: '36.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Black Sesame Latte',
      price: '34.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Cardamom Latte',
      price: '31.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Saffron Latte',
      price: '37.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Turmeric Latte',
      price: '33.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
  ];

  List<MenuItemModel> latteList8 = [
    MenuItemModel(
      title: 'Beetroot Latte',
      price: '35.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Avocado Latte',
      price: '32.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Purple Yam Latte',
      price: '30.00',
      image: 'assets/images/coffee.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Earl Grey Latte',
      price: '34.00',
      image: 'assets/images/coffee.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Chai Latte',
      price: '31.00',
      image: 'assets/images/coffee.jpg',
      rating: 4,
    ),
  ];

  // 8 Coffee Lists
  List<MenuItemModel> coffeeList1 = [
    MenuItemModel(
      title: 'Espresso',
      price: '18.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Americano',
      price: '20.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Macchiato',
      price: '22.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Ristretto',
      price: '19.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Long Black',
      price: '21.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
  ];
  List<MenuItemModel> coffeeList2 = [
    MenuItemModel(
      title: 'Cold Brew',
      price: '23.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Iced Coffee',
      price: '24.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Pour Over',
      price: '25.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'French Press',
      price: '22.00',
      image: 'assets/images/coffee2.jpg',
      rating: 1,
    ),
  ];
  List<MenuItemModel> coffeeList3 = [
    MenuItemModel(
      title: 'Turkish Coffee',
      price: '20.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Vietnamese Coffee',
      price: '24.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Cuban Coffee',
      price: '21.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Irish Coffee',
      price: '26.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Drip Coffee',
      price: '19.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
  ];
  List<MenuItemModel> coffeeList4 = [
    MenuItemModel(
      title: 'Red Eye',
      price: '22.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Black Eye',
      price: '23.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Dead Eye',
      price: '25.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Cortado',
      price: '21.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Flat White',
      price: '24.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
  ];
  List<MenuItemModel> coffeeList5 = [
    MenuItemModel(
      title: 'Affogato',
      price: '27.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Vienna Coffee',
      price: '26.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Mazagran',
      price: '23.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Lungo',
      price: '20.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Piccolo Latte',
      price: '22.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
  ];
  List<MenuItemModel> coffeeList6 = [
    MenuItemModel(
      title: 'Galão',
      price: '24.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Cappuccino',
      price: '25.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Mocha',
      price: '26.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Breve',
      price: '23.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Con Panna',
      price: '21.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
  ];
  List<MenuItemModel> coffeeList7 = [
    MenuItemModel(
      title: 'Doppio',
      price: '20.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Guillermo',
      price: '27.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Kopi Tubruk',
      price: '22.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Pharisaer',
      price: '25.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Rüdesheimer Kaffee',
      price: '28.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
  ];
  List<MenuItemModel> coffeeList8 = [
    MenuItemModel(
      title: 'Espresso Romano',
      price: '23.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Café Bombon',
      price: '26.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
    MenuItemModel(
      title: 'Café de Olla',
      price: '24.00',
      image: 'assets/images/coffee2.jpg',
      rating: 5,
    ),
    MenuItemModel(
      title: 'Café au Lait',
      price: '25.00',
      image: 'assets/images/coffee2.jpg',
      rating: 4,
    ),
    MenuItemModel(
      title: 'Café Cubano',
      price: '22.00',
      image: 'assets/images/coffee2.jpg',
      rating: 3,
    ),
  ];
}
