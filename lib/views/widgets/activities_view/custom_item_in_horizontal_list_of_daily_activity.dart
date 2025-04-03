import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

class CustomItemInHorizontalListOfDailyActivity extends StatelessWidget {
  const CustomItemInHorizontalListOfDailyActivity({
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
              fontSize:
                  GlobalData().isTabletLayout
                      ? (isSelected ? 12.sp : 10.sp)
                      : (isSelected ? 16.sp : 14.sp),
            ),
          ),
          SizedBox(height: 4.h),
          if (isSelected)
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: GlobalData().isTabletLayout ? 4.w : 2.w,
              ),
              color: Colors.brown[500],
              height: 2,
            ),
        ],
      ),
    );
  }
}
