import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/cart_view/payment/payment_method_bottom_sheet.dart';
import '../../../generated/l10n.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import 'custom_cart_grid_view.dart';
import 'manager/cart_cubit/cart_cubit.dart';

class MyCartView extends StatefulWidget {
  const MyCartView({super.key});

  @override
  State<MyCartView> createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, FoodCartState>(
      builder: (context, state) {
        var cubit = context.read<CartCubit>();
        return Scaffold(
          backgroundColor: Color(0xffF5F5F5), // Updated background color
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h), // Responsive height
            child: CustomAppBarEditingView(
              onPressed: () {
                Navigator.pop(context);
              },
              title: S.of(context).MyCarts, // Localized title
            ),
          ),
          body:
              cubit.cartItems.isEmpty
                  ? Center(
                    child: Text(
                      S.of(context).YourCartIsEmpty,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Color(0xFF6D3A2D),
                      ),
                    ),
                  )
                  : Column(
                    children: [
                      SizedBox(height: 20.h),
                      Expanded(child: CustomCartGridView()),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        color: Colors.white,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Total,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  "\$${cubit.calculateTotal().toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF6D3A2D),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  builder:
                                      (context) =>
                                          const PaymentMethodsBottomSheet(),
                                );
                                // Add checkout logic here
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.amber,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.h,
                                  horizontal: 32.w,
                                ),
                              ),
                              child: Text(
                                S.of(context).Checkout,
                                style: TextStyle(
                                  fontSize: 18.sp,
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
      },
    );
  }
}
