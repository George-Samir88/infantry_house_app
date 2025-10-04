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
