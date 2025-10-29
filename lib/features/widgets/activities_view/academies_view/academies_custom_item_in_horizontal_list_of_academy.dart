import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomItemInHorizontalListOfAcademies extends StatelessWidget {
  const CustomItemInHorizontalListOfAcademies({
    super.key,
    required this.categoryTitle,
    required this.isSelected,
  });

  final String categoryTitle;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        children: [
          Text(
            categoryTitle,
            style: TextStyle(
              color: isSelected ? Colors.brown[500] : Colors.grey,
              fontSize: isSelected ? 16.sp : 14.sp,
            ),
          ),
          SizedBox(height: 4.h),
          if (isSelected)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              color: Colors.brown[500],
              height: 2.h,
            ),
        ],
      ),
    );
  }
}
