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
class DepartmentGetSubScreensNamesSuccessState extends DepartmentState {
  DepartmentGetSubScreensNamesSuccessState();
}

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

///------------states related to MenuTitle---------
class DepartmentGetMenuTitleLoadingState extends DepartmentState {}

class DepartmentGetMenuTitleSuccessState extends DepartmentState {
  final MenuTitleModel menuTitleModel;

  DepartmentGetMenuTitleSuccessState({required this.menuTitleModel});
}

class DepartmentGetMenuTitleFailureState extends DepartmentState {
  final String failure;

  DepartmentGetMenuTitleFailureState({required this.failure});
}

class DepartmentUpdateMenuTitleLoadingState extends DepartmentState {}

class DepartmentUpdateMenuTitleSuccessState extends DepartmentState {
  DepartmentUpdateMenuTitleSuccessState();
}

class DepartmentUpdateMenuTitleFailureState extends DepartmentState {
  final String failure;

  DepartmentUpdateMenuTitleFailureState({required this.failure});
}

///------------states related to MenuButtons---------

class DepartmentCreateMenuButtonLoadingState extends DepartmentState {}

class DepartmentCreateMenuButtonSuccessState extends DepartmentState {
  final MenuButtonModel menuButton;

  DepartmentCreateMenuButtonSuccessState({required this.menuButton});
}

class DepartmentCreateMenuButtonFailureState extends DepartmentState {
  final String failure;

  DepartmentCreateMenuButtonFailureState({required this.failure});
}

class DepartmentChangeMenuButtonIndexState extends DepartmentState {}

class DepartmentGetMenuButtonSuccessState extends DepartmentState {}

class DepartmentGetMenuButtonLoadingState extends DepartmentState {}

class DepartmentGetMenuButtonFailureState extends DepartmentState {
  final String failure;

  DepartmentGetMenuButtonFailureState({required this.failure});
}

class DepartmentUpdateMenuButtonLoadingState extends DepartmentState {}

class DepartmentUpdateMenuButtonSuccessState extends DepartmentState {
  DepartmentUpdateMenuButtonSuccessState();
}

class DepartmentUpdateMenuButtonFailureState extends DepartmentState {
  final String failure;

  DepartmentUpdateMenuButtonFailureState({required this.failure});
}

class DepartmentAddNewCategoryState extends DepartmentState {}

class DepartmentRemoveCategoryState extends DepartmentState {}

class DepartmentResetCategorySelectionState extends DepartmentState {}

class DepartmentChangeSubScreenState extends DepartmentState {}

class DepartmentAddNewButtonState extends DepartmentState {}

class DepartmentRemoveButtonState extends DepartmentState {}

class DepartmentEditButtonNameState extends DepartmentState {}

class DepartmentResetMenuSelection extends DepartmentState {}

class DepartmentUpdateSelectedListState extends DepartmentState {}

class DepartmentAddNewItemState extends DepartmentState {}

class DepartmentRemoveItemState extends DepartmentState {}

class DepartmentUpdateItemState extends DepartmentState {}
