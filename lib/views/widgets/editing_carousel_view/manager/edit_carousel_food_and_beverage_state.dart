part of 'edit_carousel_food_and_beverage_cubit.dart';

@immutable
sealed class EditCarouselOfFoodAndBeverageState {}

final class EditCarouselOfFoodAndBeverageInitialState
    extends EditCarouselOfFoodAndBeverageState {}

final class EditCarouselOfFoodAndBeverageInitializeListState
    extends EditCarouselOfFoodAndBeverageState {}

final class EditCarouseInitializeCarouselState
    extends EditCarouselOfFoodAndBeverageState {}

final class EditCarouselOfFoodAndBeverageAddNewCarouselState
    extends EditCarouselOfFoodAndBeverageState {}

final class EditCarouselOfFoodAndBeverageRemoveCarouselState
    extends EditCarouselOfFoodAndBeverageState {}
