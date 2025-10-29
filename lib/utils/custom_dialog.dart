import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';

void showInputDialog({
  required BuildContext context,
  required TextEditingController arabicController,
  required TextEditingController englishController,
  required void Function(String value)? onUpdateConfirmed,
  required void Function()? onDeletePressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: true, // can't dismiss by tapping outside
    builder: (BuildContext context) {
      String? errorText;
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              S.of(context).UpdateTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: arabicController,
                  style: TextStyle(fontSize: 12.sp),
                  decoration: InputDecoration(
                    hintText: S.of(context).TypeTitle,
                    hintStyle: TextStyle(fontSize: 12.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    errorText: errorText,
                    errorStyle: TextStyle(fontSize: 10.sp),
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                TextField(
                  controller: englishController,
                  style: TextStyle(fontSize: 12.sp),
                  decoration: InputDecoration(
                    hintText: S.of(context).TypeTitle,
                    hintStyle: TextStyle(fontSize: 12.sp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    errorText: errorText,
                    errorStyle: TextStyle(fontSize: 10.sp),
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.end,
            // aligns to right
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close without saving
                          },
                          child: Text(
                            S.of(context).Cancel,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () {
                            String value = arabicController.text.trim();
                            if (value.isEmpty) {
                              setState(() {
                                errorText = S.of(context).FieldCannotBeEmpty;
                              });
                              return;
                            }
                            onUpdateConfirmed?.call(value);
                          },
                          child: Text(
                            S.of(context).Confirm,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: onDeletePressed,
                          child: Text(
                            S.of(context).Delete,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    },
  );
}
