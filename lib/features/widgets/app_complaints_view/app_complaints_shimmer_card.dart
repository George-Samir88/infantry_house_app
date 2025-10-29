import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppComplaintCardShimmer extends StatelessWidget {
  const AppComplaintCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border(
            top: BorderSide(width: 2.w),
            left: BorderSide(),
            right: BorderSide(width: 2.w),
            bottom: BorderSide(),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Circle avatar + name shimmer
            Row(
              children: [
                // Avatar shimmer
                Container(
                  height: 40.r,
                  width: 40.r,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.w),
                // Name shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 14.h,
                        width: 140.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        height: 12.h,
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // 💬 Message placeholder shimmer
            Container(
              height: 60.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),

            SizedBox(height: 10.h),

            // ☎️ Phone shimmer
            Row(
              children: [
                Icon(Icons.phone, size: 16.sp, color: Colors.grey.shade300),
                SizedBox(width: 8.w),
                Container(
                  height: 12.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
