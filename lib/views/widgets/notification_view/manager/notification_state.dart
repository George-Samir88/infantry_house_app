part of 'notification_cubit.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoadedSuccess extends NotificationState {
  final List<NotificationModel> notifications;
  NotificationLoadedSuccess(this.notifications);
}

class NotificationError extends NotificationState {
  final String failure;
  NotificationError({required this.failure});
}

class NoInternetConnectionState extends NotificationState {
  final String message;
  NoInternetConnectionState({required this.message});
}
