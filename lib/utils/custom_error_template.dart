import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../generated/l10n.dart';

class CustomErrorTemplate extends StatelessWidget {
  const CustomErrorTemplate({
    super.key,
    this.errorMessage,
    required this.onRetry,
    this.isShowCustomEditButton = false,
  });

  /// Optional custom error message (fallback uses localized text)
  final String? errorMessage;

  /// Callback for retry or fix button
  final void Function() onRetry;

  /// Whether to show the retry/edit button
  final bool isShowCustomEditButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔴 Error Illustration
          SvgPicture.asset(
            'assets/images/error-message.svg',
            height: 120.h,
            width: 120.w,
          ),
          SizedBox(height: 12.h),

          // 📝 Error Text
          Text(
            errorMessage ?? S.of(context).ErrorLoadingData,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.red.shade800,
            ),
          ),
          SizedBox(height: 20.h),

          // 🔁 Optional Retry/Edit Button
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
                side: const BorderSide(color: Color(0xff6F4E37), width: 1.5),
                // outlined border
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
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
    );
  }
}
