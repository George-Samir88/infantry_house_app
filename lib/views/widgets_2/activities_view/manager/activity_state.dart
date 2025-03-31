part of 'activity_cubit.dart';

@immutable
sealed class ActivityState {}

final class ActivityInitial extends ActivityState {}

final class ActivityChangeCarouselIndexState extends ActivityState {}

final class ActivityAddCarouselState extends ActivityState {}

final class ActivityRemoveCarouselState extends ActivityState {}
