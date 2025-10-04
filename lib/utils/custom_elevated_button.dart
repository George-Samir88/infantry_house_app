import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.backGroundColor,
    this.textColor,
    this.tabletLayout,
    this.fontSize,
  });

  final bool? tabletLayout;
  final void Function()? onPressed;
  final String text;
  final double? width;
  final Color? backGroundColor;
  final Color? textColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backGroundColor ?? const Color(0xFF6D3A2D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize ?? (16.sp),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomElevatedButtonWithIcon extends StatelessWidget {
  const CustomElevatedButtonWithIcon({
    super.key,
    this.tabletLayout,
    this.onPressed,
    this.width,
    this.backGroundColor,
    this.textColor,
    this.fontSize,
    required this.label,
    required this.icon,
  });

  final bool? tabletLayout;
  final void Function()? onPressed;
  final double? width;
  final Color? backGroundColor;
  final Color? textColor;
  final double? fontSize;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backGroundColor ?? Colors.yellow[800],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        ),
        icon: Icon(icon, color: textColor ?? Colors.white, size: 24.r),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: fontSize ?? (16.sp),
            ),
          ),
        ),
      ),
    );
  }
}
