part of 'cart_cubit.dart';

@immutable
sealed class FoodCartState {}

final class CartInitial extends FoodCartState {}

final class CartAddToCartState extends FoodCartState {}

final class CartRemoveFromCartState extends FoodCartState {}

final class CartUpdateQuantityCartState extends FoodCartState {}
