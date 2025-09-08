import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_edit_button.dart';

import '../generated/l10n.dart';
import '../global_variables.dart';

class EmptyCarouselContainer extends StatelessWidget {
  const EmptyCarouselContainer({super.key, required this.onTab});

  final void Function() onTab;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 10.w),
      width: MediaQuery.of(context).size.width,
      height: GlobalData().isTabletLayout ? 280.h : 180.h,
      decoration: BoxDecoration(
        color: Colors.grey[300], // Light grey background
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.not_interested_outlined,
              size: 50.r,
              color: Colors.black54,
            ),
            SizedBox(height: 10.h),
            Text(
              S.of(context).laYogadE3lan,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            CustomEditButton(
              onTap: onTab,
              icon: Icons.add,
              iconColor: Colors.brown[800],
              backgroundColor: Colors.amberAccent.shade100,
            )
          ],
        ),
      ),
    );
  }
}
