part of 'activity_cubit.dart';

@immutable
sealed class ActivityState {}

final class ActivityInitial extends ActivityState {}

///----------------Carousel States-----------------
final class ActivityChangeCarouselIndexState extends ActivityState {}

final class ActivityCreateCarouselLoadingState extends ActivityState {}

final class ActivityCreateCarouselSuccessState extends ActivityState {}

final class ActivityCreateCarouselFailureState extends ActivityState {
  final String failure;

  ActivityCreateCarouselFailureState({required this.failure});
}

final class ActivityDeleteLoadingCarouselState extends ActivityState {}

final class ActivityDeleteSuccessCarouselState extends ActivityState {}

final class ActivityDeleteFailureCarouselState extends ActivityState {
  final String failure;

  ActivityDeleteFailureCarouselState({required this.failure});
}

final class ActivityGetCarouselLoadingState extends ActivityState {}

final class ActivityGetCarouselEmptyState extends ActivityState {}

final class ActivityGetCarouselSuccessState extends ActivityState {}

final class ActivityGetCarouselFailureState extends ActivityState {
  final String failure;

  ActivityGetCarouselFailureState({required this.failure});
}

final class ActivityNoInternetConnectionState extends ActivityState {
  final String message;

  ActivityNoInternetConnectionState({required this.message});
}
