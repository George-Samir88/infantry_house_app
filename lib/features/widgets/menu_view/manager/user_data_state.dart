part of 'user_data_cubit.dart';

abstract class UserDataState {}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoadedSuccess extends UserDataState {
  final UserModel user;

  UserDataLoadedSuccess(this.user);
}

class UserDataError extends UserDataState {
  final String message;

  UserDataError(this.message);
}

class UserDataUpdatedSuccess extends UserDataState {
  final UserModel updatedUser;

  UserDataUpdatedSuccess({required this.updatedUser});
}

class UserDataLogoutLoading extends UserDataState {}

class UserDataLogoutSuccess extends UserDataState {}

class UserDataLogoutFailure extends UserDataState {
  final String failure;

  UserDataLogoutFailure({required this.failure});
}

class ChangePasswordLoading extends UserDataState {}

class ChangePasswordSuccess extends UserDataState {
  final String message;

  ChangePasswordSuccess(this.message);
}

class ChangePasswordError extends UserDataState {
  final String error;

  ChangePasswordError(this.error);
}

class ChangePasswordVisibilityChanged extends UserDataState {}

class NoInternetConnectionState extends UserDataState {
  final String message;

  NoInternetConnectionState({required this.message});
}
