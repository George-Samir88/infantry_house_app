import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets_2/food_and_beverage_view/custom_carousel_item.dart';

part 'edit_carousel_food_and_beverage_state.dart';

class EditCarouselOfFoodAndBeverageCubit
    extends Cubit<EditCarouselOfFoodAndBeverageState> {
  EditCarouselOfFoodAndBeverageCubit()
    : super(EditCarouselOfFoodAndBeverageInitialState());
  List<Widget> newCarouselItems = [];
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

  void initializeCarousel() {
    newCarouselItems = carouselItems;
    emit(EditCarouselOfFoodAndBeverageInitializeListState());
  }

  void addCarouselItem({required CustomCarouselItem customCarouselItem}) {
    newCarouselItems.add(customCarouselItem);
    emit(EditCarouselOfFoodAndBeverageAddNewCarouselState());
  }

  void removeCarouselItem({required int index}) {
    newCarouselItems.removeAt(index);
    emit(EditCarouselOfFoodAndBeverageRemoveCarouselState());
  }
}
