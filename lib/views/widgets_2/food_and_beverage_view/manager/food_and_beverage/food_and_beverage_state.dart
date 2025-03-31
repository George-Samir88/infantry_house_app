part of 'food_and_beverage_cubit.dart';

@immutable
sealed class FoodAndBeverageState {}

final class FoodAndBeverageInitial extends FoodAndBeverageState {}

final class FoodAndBeverageChangeScreenState extends FoodAndBeverageState {}

///--------------------------------buttons states
final class FoodAndBeverageAddNewButtonState extends FoodAndBeverageState {}

final class FoodAndBeverageRemoveButtonState extends FoodAndBeverageState {}

final class FoodAndBeverageEditButtonNameState extends FoodAndBeverageState {}

///--------------------------------Carousel States

final class FoodAndBeverageChangeCarouselState extends FoodAndBeverageState {}

final class FoodAndBeverageAddNewCarouselState extends FoodAndBeverageState {}

final class FoodAndBeverageRemoveCarouselState extends FoodAndBeverageState {}

///--------------------------------Update Selected List of items
final class FoodAndBeverageUpdateSelectedListState
    extends FoodAndBeverageState {}

///--------------------------------Items States
final class FoodAndBeverageAddNewItemState extends FoodAndBeverageState {}

final class FoodAndBeverageRemoveItemState extends FoodAndBeverageState {}

final class FoodAndBeverageUpdateItemState extends FoodAndBeverageState {}

///--------------------------------Reset Menu Selection
final class FoodAndBeverageResetMenuSelection extends FoodAndBeverageState {}

///--------------------------------Initialization
final class FoodAndBeverageInitializationBetweenButtonsAndItemsState
    extends FoodAndBeverageState {}

final class FoodAndBeverageInitializationBetweenScreensAndDataState
    extends FoodAndBeverageState {}

///--------------------------------Screens States
final class FoodAndBeverageAddNewCategoryState extends FoodAndBeverageState {}

final class FoodAndBeverageRemoveCategoryState extends FoodAndBeverageState {}

final class FoodAndBeverageResetCategorySelectionState
    extends FoodAndBeverageState {}
