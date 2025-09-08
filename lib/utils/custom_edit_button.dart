import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global_variables.dart';

class CustomEditButton extends StatelessWidget {
  const CustomEditButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.height,
    this.width,
    this.iconSize,
  });

  final void Function() onTap;
  final IconData icon;
  final Color? iconColor;
  final Color backgroundColor;
  final double? height;
  final double? width;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? (GlobalData().isTabletLayout ? 36.h : 30.h),
        width: width ?? (GlobalData().isTabletLayout ? 26.w : 40.w),
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey.shade500)],
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: iconSize ?? (GlobalData().isTabletLayout ? 25.r : 20.r),
        ),
      ),
    );
  }
}
