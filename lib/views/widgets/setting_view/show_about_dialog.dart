// 🧾 About App Dialog
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';

void showAboutDialogAlert(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: Text(
            S.of(context).AboutThisAppTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.brown[700],
            ),
          ),
          content: Text(
            S.of(context).AboutThisAppDescription,
            style: TextStyle(fontSize: 14.sp),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.of(context).Ok,
                style: TextStyle(color: Colors.brown[700], fontSize: 12.sp),
              ),
            ),
          ],
        ),
  );
}
