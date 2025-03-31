import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../utils/custom_carousel_item.dart';

part 'activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  ActivityCubit() : super(ActivityInitial());

  int currentCarouselIndex = 0;

  void changeCarouselIndex({required int index}) {
    currentCarouselIndex = index;
    emit(ActivityChangeCarouselIndexState());
  }

  List<Widget> carouselItems = [
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee2.jpg',
      isPickedImage: false,
    ),
  ];

  ///-----------------------Carousel Items Crud Operations-----------------------
  void addCarouselItem({required CustomCarouselItem customCarouselItem}) {
    carouselItems.add(customCarouselItem);
    emit(ActivityAddCarouselState());
  }

  void removeCarouselItem({required int index}) {
    carouselItems.removeAt(index);
    emit(ActivityRemoveCarouselState());
  }
}
