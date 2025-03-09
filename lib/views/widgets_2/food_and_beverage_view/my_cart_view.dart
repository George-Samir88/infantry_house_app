import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../models/menu_item_model.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import 'custom_cart_grid_view.dart';

class MyCartsView extends StatefulWidget {
  const MyCartsView({super.key});

  @override
  State<MyCartsView> createState() => _MyCartsViewState();
}

class _MyCartsViewState extends State<MyCartsView> {
  // Cart items list with quantities
  List<Map<String, dynamic>> cartItems =
      []; // {item: MenuItemModel, quantity: int}

  // Method to add an item to the cart (call this from your grid view)
  void addToCart(MenuItemModel item) {
    setState(() {
      final existingItemIndex = cartItems.indexWhere(
        (entry) => entry['item'].title == item.title,
      );
      if (existingItemIndex != -1) {
        // If item exists, increase quantity
        cartItems[existingItemIndex]['quantity'] =
            cartItems[existingItemIndex]['quantity'] + 1;
      } else {
        // If new, add with quantity 1
        cartItems.add({'item': item, 'quantity': 1});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5), // Updated background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h), // Responsive height
        child: CustomAppBarEditingView(
          onPressed: () {
            addToCart(
              MenuItemModel(
                title: 'Vanilla Latte',
                price: '28.00',
                image: 'assets/images/coffee.jpg',
                rating: 4,
              ),
            );
            // Navigator.pop(context);
          },
          title: S.of(context).MyCarts, // Localized title
        ),
      ),
      body:
          cartItems.isEmpty
              ? Center(
                child: Text(
                  S.of(context).YourCartIsEmpty,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 24.sp : 18.sp,
                    color: Color(0xFF6D3A2D),
                  ),
                ),
              )
              : Column(
                children: [
                  SizedBox(height: 30.h),
                  Expanded(
                    child: CustomCartGridView(
                      cartItems: cartItems,
                      onRemove: removeItem,
                      onQuantityChanged: updateQuantity,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      GlobalData().isTabletLayout ? 24.w : 16.w,
                    ),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).Total,
                              style: TextStyle(
                                fontSize:
                                    GlobalData().isTabletLayout ? 24.sp : 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "\$${calculateTotal().toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize:
                                    GlobalData().isTabletLayout ? 24.sp : 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6D3A2D),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: GlobalData().isTabletLayout ? 24.h : 16.h,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Add checkout logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            padding: EdgeInsets.symmetric(
                              vertical:
                                  GlobalData().isTabletLayout ? 20.h : 16.h,
                              horizontal:
                                  GlobalData().isTabletLayout ? 40.w : 32.w,
                            ),
                          ),
                          child: Text(
                            S.of(context).Checkout,
                            style: TextStyle(
                              fontSize:
                                  GlobalData().isTabletLayout ? 20.sp : 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  double calculateTotal() {
    return cartItems.fold(0, (sum, entry) {
      // Safely convert price from String to double
      final price = double.tryParse(entry['item'].price.toString()) ?? 0.0;
      return sum + price * entry['quantity'];
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void updateQuantity(int index, int newQty) {
    setState(() {
      if (newQty > 0) {
        cartItems[index]['quantity'] = newQty;
      } else {
        removeItem(index); // Remove if quantity becomes 0
      }
    });
  }
}
