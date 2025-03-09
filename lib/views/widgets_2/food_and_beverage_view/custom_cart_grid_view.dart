import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global_variables.dart';
import '../../../models/menu_item_model.dart';

class CustomCartGridView extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems; // {item: MenuItemModel, quantity: int}
  final Function(int) onRemove;
  final Function(int, int) onQuantityChanged;

  const CustomCartGridView({
    super.key,
    required this.cartItems,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: 31, // Adjusted for consistency
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 31,
        backgroundColor: Colors.white,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40, color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(GlobalData().isTabletLayout ? 24.w : 16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: GlobalData().isTabletLayout ? 3 : 2,
        childAspectRatio: GlobalData().isTabletLayout ? 0.85 : 0.75,
        mainAxisSpacing: GlobalData().isTabletLayout ? 30.h : 20.h,
        crossAxisSpacing: GlobalData().isTabletLayout ? 30.w : 20.w,
      ),
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index]['item'] as MenuItemModel;
        final quantity = cartItems[index]['quantity'] as int;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: GlobalData().isTabletLayout ? 24.h : 16.h,
                horizontal: GlobalData().isTabletLayout ? 18.w : 12.w,
              ),
              decoration: BoxDecoration(
                color: Colors.brown[400],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    spreadRadius: GlobalData().isTabletLayout ? 7.r : 5.r,
                    blurRadius: GlobalData().isTabletLayout ? 14.r : 10.r,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: GlobalData().isTabletLayout ? 60.h : 40.h),
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
                          fontSize: GlobalData().isTabletLayout ? 16.sp : 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: GlobalData().isTabletLayout ? 14.h : 10.h),
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < item.rating ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                          size: GlobalData().isTabletLayout ? 16.r : 12.r,
                        );
                      }),
                    ),
                    SizedBox(height: GlobalData().isTabletLayout ? 14.h : 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: GlobalData().isTabletLayout ? 20.r : 16.r,
                              ),
                              constraints: BoxConstraints(),
                              onPressed: () =>
                                  onQuantityChanged(index, quantity - 1),
                              padding: EdgeInsets.zero,
                            ),
                            Text(
                              "$quantity",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: GlobalData().isTabletLayout ? 18.sp : 14.sp,
                              ),
                            ),
                            IconButton(
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: GlobalData().isTabletLayout ? 20.r : 16.r,
                              ),
                              onPressed: () =>
                                  onQuantityChanged(index, quantity + 1),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: IconButton(
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: GlobalData().isTabletLayout ? 20.r : 16.r,
                            ),
                            onPressed: () => onRemove(index),
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
              top: GlobalData().isTabletLayout ? -30.h : -20.h,
              right: GlobalData().isTabletLayout ? -15.w : -10.w,
              child: _buildCircularImage(item.image),
            ),
            Positioned(
              bottom: GlobalData().isTabletLayout ? -15.h : -10.h,
              right: GlobalData().isTabletLayout ? -12.w : -8.w,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: GlobalData().isTabletLayout ? 6.h : 4.h,
                  horizontal: GlobalData().isTabletLayout ? 12.w : 8.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '\$${item.price}',
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 16.sp : 12.sp,
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
  }
}