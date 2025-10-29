import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../general_template/models/menu_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<FoodCartState> {
  CartCubit() : super(CartInitial());

  // Cart items list with quantities
  List<Map<String, dynamic>> cartItems =
      []; // {item: MenuItemModel, quantity: int}

  // Method to add an item to the cart (call this from your grid view)
  void addToCart(MenuItemModel item) {
    final existingItemIndex = cartItems.indexWhere(
      (entry) =>
          entry['item'].title == item.titleAr ||
          entry['item'].title == item.titleEn,
    );
    if (existingItemIndex != -1) {
      // If item exists, increase quantity
      cartItems[existingItemIndex]['quantity'] =
          cartItems[existingItemIndex]['quantity'] + 1;
    } else {
      // If new, add with quantity 1
      cartItems.add({'item': item, 'quantity': 1});
    }
    calculateTotal();
    emit(CartAddToCartState());
  }

  void updateQuantity(int index, int newQty) {
    if (newQty > 0) {
      cartItems[index]['quantity'] = newQty;
    } else {
      removeItem(index); // Remove if quantity becomes 0
    }
    calculateTotal();
    emit(CartUpdateQuantityCartState());
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
    calculateTotal();
    emit(CartRemoveFromCartState());
  }

  double calculateTotal() {
    return cartItems.fold(0, (sum, entry) {
      // Safely convert price from String to double
      final price = double.tryParse(entry['item'].price.toString()) ?? 0.0;
      return sum + price * entry['quantity'];
    });
  }
}
