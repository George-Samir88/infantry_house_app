import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';


part 'food_and_beverage_button_and_menu_state.dart';

class FoodAndBeverageButtonAndMenuCubit extends Cubit<FoodAndBeverageButtonAndMenuState> {
  FoodAndBeverageButtonAndMenuCubit() : super(CustomButtonAndMenuInitial()) {}

  // List<String> newButtonTitlesList = [];
  int selectedIndex = 0; // Track selected button index
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

  List<MenuItemModel> listToBeShow = [];

  Map<String, List<MenuItemModel>> allButtonsAndItemsMap = {};

  Map<String, List<MenuItemModel>> newAllButtonsAndItemsMap = {};

  bool isEmptyMenuItems = true;

  void initializeMap() {
    allButtonsAndItemsMap = {
      "لحوم": latteList1,
      "طيور": coffeeList1,
      "طواجن": latteList2,
      "مشويات": coffeeList2,
      "فواكه البحر": latteList3,
      "معجنات": coffeeList3,
      "مقبلات": latteList4,
      "شوربة": coffeeList4,
      "أطباق جانبية": latteList5,
      "إفطار": coffeeList5,
      "ركن الأطفال": latteList6,
      "طلبات إضافية للأطفال": coffeeList6,
      "ركن السلطات": latteList7,
      "سلطات غربية": coffeeList7,
      "ركن السندوتشات": latteList8,
      "ركن الحلو": coffeeList8,
    };
    if (allButtonsAndItemsMap.isNotEmpty) {
      isEmptyMenuItems = false;
      listToBeShow = allButtonsAndItemsMap["لحوم"]!;
      newAllButtonsAndItemsMap = allButtonsAndItemsMap;
    }

    emit(CustomMenuInitializeListOfListOfItemState());
  }

  void addMenuItem({required String buttonTitle}) {
    newAllButtonsAndItemsMap[buttonTitle] = [];
    listToBeShow = [];
    resetMenuSelection();
    isEmptyMenuItems = false;
    emit(CustomButtonAndAddMenuState());
  }
  void resetMenuSelection() {
    selectedIndex = 0;
    if (newAllButtonsAndItemsMap.isNotEmpty) {
      listToBeShow = newAllButtonsAndItemsMap.values.first;
    } else {
      listToBeShow = [];
    }
    emit(CustomButtonAndMenuUpdated());
  }

  void removeMenuItem({required String title}) {
    listToBeShow = [];
    newAllButtonsAndItemsMap.remove(title);
    if (newAllButtonsAndItemsMap.isNotEmpty) {
      updateSelectedList(buttonTitle: newAllButtonsAndItemsMap.keys.first);
      resetMenuSelection();
    } else if (newAllButtonsAndItemsMap.isEmpty) {
      isEmptyMenuItems = true;
    }
    emit(CustomButtonAndRemoveMenuState());
  }


  void updateSelectedList({required String buttonTitle}) {
    listToBeShow = newAllButtonsAndItemsMap[buttonTitle]!;
    emit(CustomButtonUpdateSelectedList());
  }

  void addItem({
    required MenuItemModel menuItemModel,
    required String buttonTitle,
  }) {
    newAllButtonsAndItemsMap[buttonTitle]!.add(menuItemModel);
    emit(CustomButtonAndAddMenuState());
  }

  void removeItem({required String title, required int indexOfList}) {
    newAllButtonsAndItemsMap[title]!.removeAt(indexOfList);
    emit(CustomMenuRemoveItemState());
  }

  void updateItem({
    required String buttonTitle,
    required listIndex,
    String? newTitle,
    String? newImage,
    String? newPrice,
  }) {
    if (true) {
      if (newImage != null &&
          newAllButtonsAndItemsMap[buttonTitle]![listIndex].image != newImage) {
        newAllButtonsAndItemsMap[buttonTitle]![listIndex].image = newImage;
      }
      if (newTitle != null &&
          newAllButtonsAndItemsMap[buttonTitle]![listIndex].title != newTitle) {
        newAllButtonsAndItemsMap[buttonTitle]![listIndex].title = newTitle;
      }
      if (newPrice != null &&
          newAllButtonsAndItemsMap[buttonTitle]![listIndex].price != newPrice) {
        newAllButtonsAndItemsMap[buttonTitle]![listIndex].price = newPrice;
      }
      emit(CustomMenuUpdateItemState());
    }
  }

}
