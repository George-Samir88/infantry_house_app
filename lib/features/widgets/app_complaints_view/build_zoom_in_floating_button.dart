import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/app_loader.dart';

import '../../../generated/l10n.dart';

ZoomIn buildZoomInFloatingButton({
  required BuildContext context,
  required S loc,
  void Function()? onPressed,
  bool isLoading = false,
}) {
  return ZoomIn(
    delay: const Duration(milliseconds: 400),
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FloatingActionButton.extended(
        onPressed: isLoading ? null : onPressed,
        label:
            isLoading
                ? AppLoader()
                : Text(
                  loc.Submit,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
        icon:
            isLoading
                ? null
                : Icon(Icons.send_rounded, size: 24.sp, color: Colors.white),
        backgroundColor: Colors.brown.shade400,
        elevation: 6,
      ),
    ),
  );
}
