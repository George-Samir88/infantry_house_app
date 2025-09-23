part of 'rating_cubit.dart';

sealed class RatingState {}

final class RatingInitial extends RatingState {}

final class RatingSendRatingLoading extends RatingState {}

final class RatingSendRatingSuccess extends RatingState {}

final class RatingSendRatingFailure extends RatingState {
  final String failure;

  RatingSendRatingFailure({required this.failure});
}
