part of 'app_complaints_cubit.dart';

abstract class AppComplaintsState {}

class ComplaintsInitial extends AppComplaintsState {}

class ComplaintsSubmitLoading extends AppComplaintsState {}

class ComplaintsSubmitSuccess extends AppComplaintsState {}

class ComplaintsSubmitError extends AppComplaintsState {
  final String error;

  ComplaintsSubmitError({required this.error});
}

class ComplaintsGetLoading extends AppComplaintsState {}

class ComplaintsGetSuccess extends AppComplaintsState {}

class ComplaintsGetFailure extends AppComplaintsState {
  final String failure;

  ComplaintsGetFailure({required this.failure});
}

class ComplaintsGetEmpty extends AppComplaintsState {}

class ComplaintsNoInternetConnectionState extends AppComplaintsState {
  final String failure;

  ComplaintsNoInternetConnectionState({required this.failure});
}
