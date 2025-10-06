import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/general_template/shimmer_loader.dart';
import 'package:shimmer/shimmer.dart';

import '../../../global_variables.dart';

class CustomMenuItemsHorizontalGridViewShimmer extends StatelessWidget {
  const CustomMenuItemsHorizontalGridViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.only(top: 20.h, left: 12.w, right: 12.w),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 24.w,
        top: 30.h,
        bottom: 20.h,
      ),
      constraints: BoxConstraints(
        minHeight: 100.h,
        maxHeight: GlobalData().isTabletLayout ? 400.h : 320.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.brown.shade200, width: 1),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.shade100.withValues(alpha: 0.4),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: GridView.builder(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: GlobalData().isTabletLayout ? 1.1 : 1,
          mainAxisSpacing: 20.w,
          crossAxisSpacing: 35.h,
        ),
        itemCount: 6,
        itemBuilder: (_, __) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Main card
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown[300],
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShimmerLoader(width: 70.w, height: 12.h, borderRadius: 6),
                      SizedBox(height: 8.h),
                      Row(
                        children: List.generate(
                          5,
                              (_) => Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: ShimmerLoader(
                              width: 10.w,
                              height: 10.h,
                              borderRadius: 3,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                    ],
                  ),
                ),
              ),

              // Circular image shimmer
              Positioned(
                top: -18.h,
                right: GlobalData().isArabic ? -10.w : null,
                left: GlobalData().isArabic ? null : -10.w,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CircleAvatar(
                    radius: 26.r,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),

              // Price shimmer
              Positioned(
                bottom: -8.h,
                right: GlobalData().isArabic ? -8.w : null,
                left: GlobalData().isArabic ? null : -8.w,
                child: ShimmerLoader(
                  width: 45.w,
                  height: 16.h,
                  borderRadius: 6,
                ),
              ),

              // Cart shimmer
              Positioned(
                bottom: -5.h,
                left: GlobalData().isArabic ? -5.w : null,
                right: GlobalData().isArabic ? null : -5.w,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CircleAvatar(
                    radius: 20.r,
                    backgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
