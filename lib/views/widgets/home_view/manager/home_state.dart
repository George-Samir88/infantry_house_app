part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeChangeScreenState extends HomeState {}

final class HomeGetDepartmentsLoadingState extends HomeState {}

final class HomeGetDepartmentsSuccessState extends HomeState {}

final class HomeGetDepartmentsFailureState extends HomeState {
  final String failure;

  HomeGetDepartmentsFailureState({required this.failure});
}
