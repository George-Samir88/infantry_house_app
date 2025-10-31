part of 'academies_cubit.dart';

sealed class AcademiesState {}

final class AcademyInitial extends AcademiesState {}

final class AcademyChangeCurrentSelectedIndexState extends AcademiesState {}

final class AcademyChangeCurrentCategoryIndexState extends AcademiesState {}

final class AcademyTriggerAnimationState extends AcademiesState {}

final class AcademyInitialAnimationState extends AcademiesState {}

///-----------------------------Academy Crud------------------------------
final class AcademyCreateSuccessState extends AcademiesState {}

final class AcademyCreateLoadingState extends AcademiesState {}

final class AcademyCreateFailureState extends AcademiesState {
  final String failure;

  AcademyCreateFailureState({required this.failure});
}

///-----------------------------Items Crud------------------------------
final class AcademyAddNewItemState extends AcademiesState {}

final class AcademyRemoveItemState extends AcademiesState {}

final class AcademyUpdateItemState extends AcademiesState {}

final class AcademyNoInternetConnectionState extends AcademiesState {
  final String message;

  AcademyNoInternetConnectionState({required this.message});
}
