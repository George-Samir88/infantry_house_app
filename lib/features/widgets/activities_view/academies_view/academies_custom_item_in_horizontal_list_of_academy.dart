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
    return AnimatedContainer(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? Colors.brown.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: Colors.brown.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ]
                : [],
      ),
      child: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric( horizontal: 16.w),
            child: Text(
              categoryTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.brown[700] : Colors.grey[600],
                fontSize: isSelected ? 16.sp : 14.sp,
              ),
            ),
          ),

          // 👇 الخط اللي بيظهر كأنه ملتحم بأسفل الشاشة
          if (isSelected)
            Positioned(
              bottom: -6.h,
              child: Container(
                width: 40.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: Colors.brown[500],
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(6.r),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
