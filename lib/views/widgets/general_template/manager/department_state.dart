part of 'department_cubit.dart';

sealed class DepartmentState {}

class DepartmentInitial extends DepartmentState {}

///------------states related to departments---------
class DepartmentGetDepartmentsNamesSuccessState extends DepartmentState {}

class DepartmentGetDepartmentsNamesLoadingState extends DepartmentState {}

class DepartmentGetDepartmentsNamesFailureState extends DepartmentState {
  final String error;

  DepartmentGetDepartmentsNamesFailureState({required this.error});
}

///------------states related to Sub Screens---------
class DepartmentGetSubScreensNamesSuccessState extends DepartmentState {}

class DepartmentGetSubScreensNamesLoadingState extends DepartmentState {}

class DepartmentGetSubScreensNamesFailureState extends DepartmentState {
  final String error;

  DepartmentGetSubScreensNamesFailureState({required this.error});
}

class DepartmentCreateSubScreensNamesSuccessState extends DepartmentState {
  final DocumentReference docReference;

  DepartmentCreateSubScreensNamesSuccessState({required this.docReference});
}

class DepartmentCreateSubScreensNamesLoadingState extends DepartmentState {}

class DepartmentCreateSubScreensNamesFailureState extends DepartmentState {
  final String failure;

  DepartmentCreateSubScreensNamesFailureState({required this.failure});
}

class DepartmentUpdateSubScreensNamesSuccessState extends DepartmentState {}

class DepartmentUpdateSubScreensNamesLoadingState extends DepartmentState {}

class DepartmentUpdateSubScreensNamesFailureState extends DepartmentState {
  final String failure;

  DepartmentUpdateSubScreensNamesFailureState({required this.failure});
}

class DepartmentDeleteSubScreensNamesSuccessState extends DepartmentState {}

class DepartmentDeleteSubScreensNamesLoadingState extends DepartmentState {}

class DepartmentDeleteSubScreensNamesFailureState extends DepartmentState {
  final String failure;

  DepartmentDeleteSubScreensNamesFailureState({required this.failure});
}

///------------states related to CAROUSEL---------
class DepartmentChangeCarouselIndexState extends DepartmentState {}

class DepartmentAddNewCarouselSuccessState extends DepartmentState {}

class DepartmentAddNewCarouselLoadingState extends DepartmentState {}

class DepartmentAddNewCarouselFailureState extends DepartmentState {
  final String failure;

  DepartmentAddNewCarouselFailureState({required this.failure});
}

class DepartmentGetCarouselSuccessState extends DepartmentState {}

class DepartmentGetCarouselLoadingState extends DepartmentState {}

class DepartmentGetCarouselFailureState extends DepartmentState {
  final String failure;

  DepartmentGetCarouselFailureState({required this.failure});
}

class DepartmentCreateCarouselSuccessState extends DepartmentState {}

class DepartmentCreateCarouselLoadingState extends DepartmentState {}

class DepartmentCreateCarouselFailureState extends DepartmentState {
  final String failure;

  DepartmentCreateCarouselFailureState({required this.failure});
}
class DepartmentRemoveCarouselSuccessState extends DepartmentState {}

class DepartmentRemoveCarouselLoadingState extends DepartmentState {}

class DepartmentRemoveCarouselFailureState extends DepartmentState {
  final String failure;

  DepartmentRemoveCarouselFailureState({required this.failure});
}
class DepartmentRemoveCarouselState extends DepartmentState {}

class DepartmentInitializationState extends DepartmentState {}

class DepartmentAddNewCategoryState extends DepartmentState {}

class DepartmentRemoveCategoryState extends DepartmentState {}

class DepartmentResetCategorySelectionState extends DepartmentState {}

class DepartmentChangeScreenState extends DepartmentState {}

class DepartmentAddNewButtonState extends DepartmentState {}

class DepartmentRemoveButtonState extends DepartmentState {}

class DepartmentEditButtonNameState extends DepartmentState {}

class DepartmentResetMenuSelection extends DepartmentState {}

class DepartmentUpdateSelectedListState extends DepartmentState {}

class DepartmentAddNewItemState extends DepartmentState {}

class DepartmentRemoveItemState extends DepartmentState {}

class DepartmentUpdateItemState extends DepartmentState {}
