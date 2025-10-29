// 🔹 Animated List Tile
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget animatedTile({
  required int index,
  required IconData icon,
  required String title,
  String? subtitle,
  Color? color,
  required VoidCallback onTap,
}) {
  return FadeInRight(
    duration: const Duration(milliseconds: 600),
    delay: Duration(milliseconds: index * 100),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            buildIcon(icon),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: color ?? Colors.brown[900],
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18.sp,
              color: Colors.brown[400],
            ),
          ],
        ),
      ),
    ),
  );
}

// 🔸 Reusable Gradient Icon
Widget buildIcon(IconData icon) {
  return Container(
    height: 45.h,
    width: 45.h,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        colors: [Color(0xFF6D4C41), Color(0xFF8D6E63)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Icon(icon, color: Colors.white, size: 24.sp),
  );
}
