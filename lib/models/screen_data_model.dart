import 'package:flutter/cupertino.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';

class ScreenData {
  List<Widget> carouselWidgets;
  String menuTitle;
  Map<String, List<MenuItemModel>> buttonsAndItemsMap;

  ScreenData({
    required this.carouselWidgets,
    required this.buttonsAndItemsMap,
    required this.menuTitle,
  });
}
