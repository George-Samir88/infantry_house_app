import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

void showSnackBar({
  required BuildContext context,
  required SnackBarAction snackBarAction,
  required String message,
  int? seconds,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: GlobalData().isTabletLayout ? 8.sp : 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFF6D3A2D),
      // Custom color
      behavior: SnackBarBehavior.floating,
      // Custom behavior
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      duration: Duration(seconds: seconds ?? 2),
      action: snackBarAction,
    ),
  );
}

// SnackBarAction(
// label: 'Undo',
// onPressed: onUndo ,
// textColor: Colors.white,
// )
