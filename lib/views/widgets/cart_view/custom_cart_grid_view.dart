import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global_variables.dart';
import '../../../models/menu_item_model.dart';
import 'manager/cart_cubit/cart_cubit.dart';

class CustomCartGridView extends StatelessWidget {
  const CustomCartGridView({super.key});

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: 31.r,
        // Adjusted for consistency
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 60.w,
            height: 60.h,
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 31.r,
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: 60.w,
            height: 60.h,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, FoodCartState>(
      builder: (context, state) {
        var cubit = context.read<CartCubit>();
        return GridView.builder(
          clipBehavior: Clip.none,
          padding: EdgeInsets.all(GlobalData().isTabletLayout ? 24.w : 16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: GlobalData().isTabletLayout ? 3 : 2,
            childAspectRatio: 0.85,
            mainAxisSpacing: 35.h,
            crossAxisSpacing: 20.w,
          ),
          itemCount: cubit.cartItems.length,
          itemBuilder: (context, index) {
            final item = cubit.cartItems[index]['item'] as MenuItemModel;
            final quantity = cubit.cartItems[index]['quantity'] as int;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: EdgeInsets.only(
                    bottom: 20.h,
                    left: 6.w,
                    right: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown[400],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 5.r,
                        blurRadius: 10.r,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            item.title,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              starIndex < item.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.yellow,
                              size: 12.r,
                            );
                          }),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16.r,
                                  ),
                                  onPressed: () {
                                    cubit.updateQuantity(index, quantity - 1);
                                  },
                                  padding: EdgeInsets.zero,
                                ),
                                Text(
                                  "$quantity",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16.r,
                                  ),
                                  onPressed: () {
                                    cubit.updateQuantity(index, quantity + 1);
                                  },
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 16.r,
                                ),
                                onPressed: () => cubit.removeItem(index),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -20.h,
                  right: GlobalData().isArabic ? -10.w : null,
                  left: GlobalData().isArabic ? null : -10.w,
                  child: _buildCircularImage(item.image),
                ),
                Positioned(
                  bottom: -10.h,
                  right: GlobalData().isArabic ? -8.w : null,
                  left: GlobalData().isArabic ? null : -8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 8.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '\$${item.price}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
