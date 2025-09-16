import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../generated/l10n.dart';

void showInputDialog({
  required BuildContext context,
  required TextEditingController controller,
  required void Function(String value)? onConfirmed,
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
              S.of(context).UpdateSubScreenTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            content: TextField(
              controller: controller,
              style: TextStyle(fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: S.of(context).TypeSubScreenTitle,
                hintStyle: TextStyle(fontSize: 12.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                errorText: errorText,
                errorStyle: TextStyle(
                  fontSize: 10.sp,
                )
              ),
            ),
            actionsAlignment: MainAxisAlignment.end,
            // aligns to right
            actions: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close without saving
                    },
                    child: Text(
                      S.of(context).Cancel,
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      String value = controller.text.trim();
                      if (value.isEmpty) {
                        setState(() {
                          errorText = S.of(context).FieldCannotBeEmpty;
                        });
                        return;
                      }
                      onConfirmed?.call(value);
                    },
                    child: Text(
                      S.of(context).Confirm,
                      style: TextStyle(fontSize: 12.sp),
                    ),
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
