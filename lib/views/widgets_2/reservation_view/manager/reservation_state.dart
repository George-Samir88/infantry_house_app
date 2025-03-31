part of 'reservation_cubit.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

final class ReservationChangeScreenState extends ReservationState {}

///--------------------------------buttons states
final class ReservationAddNewButtonState extends ReservationState {}

final class ReservationRemoveButtonState extends ReservationState {}

final class ReservationEditButtonNameState extends ReservationState {}

///--------------------------------Carousel States

final class ReservationChangeCarouselState extends ReservationState {}

final class ReservationAddNewCarouselState extends ReservationState {}

final class ReservationRemoveCarouselState extends ReservationState {}

///--------------------------------Update Selected List of items
final class ReservationUpdateSelectedListState extends ReservationState {}

///--------------------------------Items States
final class ReservationAddNewItemState extends ReservationState {}

final class ReservationRemoveItemState extends ReservationState {}

final class ReservationUpdateItemState extends ReservationState {}

///--------------------------------Reset Menu Selection
final class ReservationResetMenuSelection extends ReservationState {}

///--------------------------------Initialization
final class ReservationInitializationBetweenButtonsAndItemsState
    extends ReservationState {}

final class ReservationInitializationBetweenScreensAndDataState
    extends ReservationState {}

///--------------------------------Screens States
final class ReservationAddNewCategoryState extends ReservationState {}

final class ReservationRemoveCategoryState extends ReservationState {}

final class ReservationResetCategorySelectionState extends ReservationState {}
