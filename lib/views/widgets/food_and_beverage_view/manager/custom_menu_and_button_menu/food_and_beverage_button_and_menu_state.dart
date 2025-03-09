part of 'food_and_beverage_button_and_menu_cubit.dart';

@immutable
sealed class FoodAndBeverageButtonAndMenuState {}

final class CustomButtonAndMenuInitial extends FoodAndBeverageButtonAndMenuState {}

final class CustomButtonAndMenuGetState extends FoodAndBeverageButtonAndMenuState {

  CustomButtonAndMenuGetState();
}

final class CustomButtonAndAddMenuState extends FoodAndBeverageButtonAndMenuState {}

final class CustomButtonAndRemoveMenuState extends FoodAndBeverageButtonAndMenuState {}

final class CustomButtonUpdateSelectedList extends FoodAndBeverageButtonAndMenuState {}

final class CustomButtonAssignListToBeShow extends FoodAndBeverageButtonAndMenuState {}

final class CustomMenuAddNewItemState extends FoodAndBeverageButtonAndMenuState {}

final class CustomMenuRemoveItemState extends FoodAndBeverageButtonAndMenuState {}

final class CustomMenuUpdateItemState extends FoodAndBeverageButtonAndMenuState {}

final class CustomButtonAndMenuUpdated extends FoodAndBeverageButtonAndMenuState {}

final class CustomMenuCheckEmptyMenuState extends FoodAndBeverageButtonAndMenuState {}

final class CustomMenuInitializeListOfListOfItemState
    extends FoodAndBeverageButtonAndMenuState {}
