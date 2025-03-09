part of 'food_and_beverage_cubit.dart';

@immutable
sealed class FoodAndBeverageState {}

final class FoodAndBeverageInitial extends FoodAndBeverageState {}

final class FoodAndBeverageChangeScreenState extends FoodAndBeverageState {}

final class CustomButtonAndMenuGetState extends FoodAndBeverageState {
  CustomButtonAndMenuGetState();
}

final class CustomButtonAndAddMenuState extends FoodAndBeverageState {}

final class CustomButtonAndRemoveMenuState extends FoodAndBeverageState {}

final class FoodAndBeverageAddNewCarouselState extends FoodAndBeverageState {}

final class FoodAndBeverageRemoveCarouselState extends FoodAndBeverageState {}

final class CustomButtonUpdateSelectedList extends FoodAndBeverageState {}

final class CustomButtonAssignListToBeShow extends FoodAndBeverageState {}

final class CustomMenuAddNewItemState extends FoodAndBeverageState {}

final class CustomMenuRemoveItemState extends FoodAndBeverageState {}

final class CustomMenuUpdateItemState extends FoodAndBeverageState {}

final class CustomButtonAndMenuUpdated extends FoodAndBeverageState {}

final class CustomMenuCheckEmptyMenuState extends FoodAndBeverageState {}

final class CustomMenuInitializeListOfListOfItemState
    extends FoodAndBeverageState {}

final class CustomMenuInitializeMappingBetweenScreensAndButtonsTitleState
    extends FoodAndBeverageState {}

final class FoodAndBeverageInitializeScreensMapState
    extends FoodAndBeverageState {}

final class FoodAndBeverageAddNewScreen extends FoodAndBeverageState {}

final class FoodAndBeverageRemoveScreen extends FoodAndBeverageState {}

final class FoodAndBeverageResetScreenSelection extends FoodAndBeverageState {}
