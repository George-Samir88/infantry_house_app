part of 'housing_cubit.dart';

@immutable
sealed class HousingState {}

final class HousingInitial extends HousingState {}

final class HousingChangeScreenState extends HousingState {}

///--------------------------------buttons states
final class HousingAddNewButtonState extends HousingState {}

final class HousingRemoveButtonState extends HousingState {}

final class HousingEditButtonNameState extends HousingState {}

///--------------------------------Carousel States

final class HousingChangeCarouselState extends HousingState {}

final class HousingAddNewCarouselState extends HousingState {}

final class HousingRemoveCarouselState extends HousingState {}

///--------------------------------Update Selected List of items
final class HousingUpdateSelectedListState extends HousingState {}

///--------------------------------Items States
final class HousingAddNewItemState extends HousingState {}

final class HousingRemoveItemState extends HousingState {}

final class HousingUpdateItemState extends HousingState {}

///--------------------------------Reset Menu Selection
final class HousingResetMenuSelection extends HousingState {}

///--------------------------------Initialization
final class HousingInitializationBetweenButtonsAndItemsState
    extends HousingState {}

final class HousingInitializationBetweenScreensAndDataState
    extends HousingState {}

///--------------------------------Screens States
final class HousingAddNewCategoryState extends HousingState {}

final class HousingRemoveCategoryState extends HousingState {}

final class HousingResetCategorySelectionState extends HousingState {}
