part of 'rating_cubit.dart';

sealed class RatingState {}

final class RatingInitial extends RatingState {}

final class RatingSendRatingLoading extends RatingState {}

final class RatingSendRatingSuccess extends RatingState {}

final class RatingSendRatingFailure extends RatingState {
  final String failure;

  RatingSendRatingFailure({required this.failure});
}

final class RatingGetRatingLoading extends RatingState {}

final class RatingGetRatingSuccess extends RatingState {}

final class RatingGetRatingFailure extends RatingState {
  final String failure;

  RatingGetRatingFailure({required this.failure});
}

final class RatingSubmitComplaintsLoading extends RatingState {}

final class RatingSubmitComplaintsSuccess extends RatingState {}

final class RatingSubmitComplaintsFailure extends RatingState {
  final String failure;

  RatingSubmitComplaintsFailure({required this.failure});
}

final class RatingGetComplaintsLoading extends RatingState {}

final class RatingGetComplaintsSuccess extends RatingState {}

final class RatingGetComplaintsFailure extends RatingState {
  final String failure;

  RatingGetComplaintsFailure({required this.failure});
}
