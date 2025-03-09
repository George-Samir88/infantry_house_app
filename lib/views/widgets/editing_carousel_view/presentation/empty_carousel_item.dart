import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

import '../../../../generated/l10n.dart';

class EmptyCarouselContainer extends StatelessWidget {
  const EmptyCarouselContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      width: MediaQuery.of(context).size.width,
      height: GlobalData().isTabletLayout ? 360.h : 180.h,
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light grey background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.not_interested_outlined, size: 50.r, color: Colors.black54),
            SizedBox(height: 10),
            Text(
              S.of(context).laYogadE3lan,
              style: TextStyle(
                color: Colors.black54,
                fontSize: GlobalData().isTabletLayout ?12.sp :18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
