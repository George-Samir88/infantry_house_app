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
  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: Duration(milliseconds: 400 + (index * 100)),
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      );
    },
    child: Card(
      elevation: 3,
      color: color ?? Colors.brown.shade100.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown.shade700, size: 26.sp),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
            fontSize: 15.sp,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
          subtitle,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.brown.shade500,
          ),
        )
            : null,
        onTap: onTap,
      ),
    ),
  );
}
