import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../generated/l10n.dart';

class NoInternetConnectionWidget extends StatelessWidget {
  const NoInternetConnectionWidget({
    super.key,
    required this.onRetry,
    this.message,
  });

  /// Custom message (optional)
  final String? message;

  /// Retry callback
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🌐 No Connection Illustration
            SvgPicture.asset(
              'assets/images/no-connection.svg',
              height: 150.h,
              width: 150.w,
            ),
            SizedBox(height: 16.h),

            // 📝 Message
            Text(
              message ?? S.of(context).NoInternetConnection,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.brown[800],
              ),
            ),
            SizedBox(height: 10.h),

            // 💬 Subtext
            Text(
              S.of(context).PleaseCheckYourConnectionAndTryAgain,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            SizedBox(height: 24.h),

            // 🔁 Retry Button
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: const Color(0xff6F4E37),
                elevation: 0,
                side: const BorderSide(color: Color(0xff6F4E37), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, size: 22),
                  SizedBox(width: 8.w),
                  Text(
                    S.of(context).Refresh,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff6F4E37),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
