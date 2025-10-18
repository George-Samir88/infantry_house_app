import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildFaqItem({required String question, required String answer}) {
  return ExpansionTile(
    tilePadding: const EdgeInsets.symmetric(horizontal: 0),
    childrenPadding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    title: Text(
      question,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.sp,
        color: Colors.black87,
      ),
    ),
    children: [
      Text(
        answer,
        style: TextStyle(fontSize: 14.sp, color: Colors.black54, height: 1.4),
      ),
    ],
  );
}
