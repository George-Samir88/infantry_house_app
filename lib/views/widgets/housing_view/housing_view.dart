import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../../../models/menu_item_model.dart';
import '../../../models/screen_data_model.dart';
import '../../../utils/custom_carousel_item.dart';
import '../general_template/general_template.dart';
import '../general_template/manager/department_cubit.dart';

class HousingView extends StatefulWidget {
  const HousingView({super.key});

  @override
  State<HousingView> createState() => _HousingViewState();
}

class _HousingViewState extends State<HousingView> {
  List<MenuItemModel> latteList1 = [];
  List<MenuItemModel> latteList2 = [];
  Map<String, ScreenData> housingScreensMap = {};

  @override
  void initState() {
    // Sample data
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
    Map<String, List<MenuItemModel>> allButtonsAndItemsParadiseMap = {
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
    Map<String, List<MenuItemModel>> allButtonsAndItemsCafesMap = {
      "مانجو": latteList5,
      "قهوة": coffeeList5,
      "فراولة": latteList6,
      "جوافة": coffeeList6,
      "أناناس": latteList7,
      "موز": coffeeList7,
      "شاي": latteList8,
      "كوكتيل": coffeeList7,
      "ركن الحلو": coffeeList8,
    };
    housingScreensMap = {
      "باراديس": ScreenData(
        carouselWidgets: carouselItems,
        buttonsAndItemsMap: allButtonsAndItemsParadiseMap,
        menuTitle: 'قائمة الطعام',
      ),
      "كافيهات": ScreenData(
        carouselWidgets: carouselItems2,
        buttonsAndItemsMap: allButtonsAndItemsCafesMap,
        menuTitle: 'قائمة المشروبات',
      ),
      "فنادق": ScreenData(
        carouselWidgets: [],
        buttonsAndItemsMap: {},
        menuTitle: "",
      ),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DepartmentCubit(),
      child: GeneralTemplateView(appBarTitle: S.of(context).eskan),
    );
  }
}
