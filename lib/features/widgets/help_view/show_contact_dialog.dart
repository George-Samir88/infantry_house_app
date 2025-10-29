import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';

void showContactDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
      title: Text(S.of(context).ContactSupport , style: TextStyle(fontSize: 18.sp , fontWeight: FontWeight.bold),),
      content: Text(S.of(context).ContactSupportMessage , style: TextStyle(fontSize: 14.sp),),
      actions: [
        TextButton(
          child: Text(
            S.of(context).Close,
            style: TextStyle(
              color: Colors.brown.shade400,
              fontSize: 12.sp,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    ),
  );
}