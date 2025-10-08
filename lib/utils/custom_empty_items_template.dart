import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/l10n.dart';
import '../global_variables.dart';

class CustomEmptyItemsTemplate extends StatelessWidget {
  const CustomEmptyItemsTemplate({
    super.key,
    this.iconOfCustomEditButton,
    this.isShowCustomEditButton = false,
    this.errorMessage,
    required this.onRetry,
  });

  final IconData? iconOfCustomEditButton;
  final bool isShowCustomEditButton;

  /// Optional custom error message (fallback uses localized text)
  final String? errorMessage;

  /// Callback for retry or fix button
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            // Shadow color with opacity
            spreadRadius: 5,
            // Spread area of the shadow
            blurRadius: 10,
            // Blur effect
            offset: Offset(0, 3), // Changes position of shadow (X, Y)
          ),
        ],
        borderRadius: BorderRadius.circular(10), // Optional: Rounds corners
      ),
      margin: EdgeInsets.only(top: 20, left: 12, right: 12),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 22.h,
        bottom: 20.h,
      ),
      constraints: BoxConstraints(
        minHeight: 100.h, // Set a reasonable minimum height
        maxHeight:
            GlobalData().isTabletLayout
                ? 300.h
                : 320.h, // Set a reasonable max height if necessary
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/empty-items2.svg',
                  height: GlobalData().isTabletLayout ? 80.h : 100.h,
                  width: GlobalData().isTabletLayout ? 80.h : 100.w,
                ),
                SizedBox(height: 10.h),
                Text(
                  S.of(context).LaYogd3nasr,
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(height: 20.h),
                if (isShowCustomEditButton)
                  ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      // transparent background
                      foregroundColor: const Color(0xff6F4E37),
                      // text & icon color (your brown)
                      elevation: 0,
                      // remove shadow
                      side: const BorderSide(
                        color: Color(0xff6F4E37),
                        width: 1.5,
                      ),
                      // outlined border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 24),
                        SizedBox(width: 8.w),
                        Text(
                          S.of(context).Refresh,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff6F4E37), // match palette
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomEmptyWidgetTemplate extends StatelessWidget {
  const CustomEmptyWidgetTemplate({
    super.key,
    this.iconOfCustomEditButton,
    this.isShowCustomEditButton = false,
    this.errorMessage,
    required this.onRetry,
  });

  final IconData? iconOfCustomEditButton;
  final bool isShowCustomEditButton;

  /// Optional custom error message (fallback uses localized text)
  final String? errorMessage;

  /// Callback for retry or fix button
  final void Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/empty-items2.svg',
                height: GlobalData().isTabletLayout ? 80.h : 120.h,
                width: GlobalData().isTabletLayout ? 80.h : 120.w,
              ),
              SizedBox(height: 10.h),
              Text(
                S.of(context).LaYogd3nasr,
                style: TextStyle(fontSize: 20.sp),
              ),
              SizedBox(height: 20.h),
              if (isShowCustomEditButton)
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    // transparent background
                    foregroundColor: const Color(0xff6F4E37),
                    // text & icon color (your brown)
                    elevation: 0,
                    // remove shadow
                    side: const BorderSide(
                      color: Color(0xff6F4E37),
                      width: 1.5,
                    ),
                    // outlined border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, size: 24),
                      SizedBox(width: 8.w),
                      Text(
                        S.of(context).Refresh,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff6F4E37), // match palette
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
