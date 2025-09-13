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

class DepartmentChangeCarouselIndexState extends DepartmentState {}

class DepartmentAddNewCarouselState extends DepartmentState {}

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
