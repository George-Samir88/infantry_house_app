import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

import '../../../models/menu_item_model.dart';

class CustomItemsInGridEditView extends StatelessWidget {
  const CustomItemsInGridEditView({super.key, required this.menuItemModel});

  final MenuItemModel menuItemModel;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.brown,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 2.r,
                blurRadius: 6.r,
                offset: Offset(0, 3.h),
              ),
            ],
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  menuItemModel.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < menuItemModel.rating
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.yellow,
                    size: 12.r,
                  );
                }),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
        // Positioned Circle Avatar (Image)
        Positioned(
          top: -20.h,
          right: GlobalData().isArabic ? -8.w : null,
          left: GlobalData().isArabic ? null : -8.w,
          child: _buildCircularImage(menuItemModel.image),
        ),
        // Positioned Price Tag
        Positioned(
          bottom: -10.h,
          right: GlobalData().isArabic ? -8.w : null,
          left: GlobalData().isArabic ? null : -8.w,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '\$${menuItemModel.price}',
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
  }

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return CircleAvatar(
        radius: 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 60.r,
            height: 60.r,
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 31.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: 60.r,
            height: 60.r,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
  }
}
