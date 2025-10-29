part of 'autologin_cubit.dart';

sealed class AutoLoginState {}

final class AutoLoginInitial extends AutoLoginState {}

class AutoLoginLoading extends AutoLoginState {}

class AutoLoginSuccess extends AutoLoginState {
  final UserModel user;

  AutoLoginSuccess(this.user);
}

class AutoLoginUserNotFound extends AutoLoginState {
  final String message;

  AutoLoginUserNotFound(this.message);
}

class AutoLoginFailure extends AutoLoginState {
  final String message;

  AutoLoginFailure(this.message);
}

class AutoLoginEmailNotVerified extends AutoLoginState {
  final String message;

  AutoLoginEmailNotVerified(this.message);
}
