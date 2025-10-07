import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/l10n.dart';
import '../global_variables.dart';
import 'custom_edit_button.dart';

class CustomEmptyItemsTemplate extends StatelessWidget {
  const CustomEmptyItemsTemplate({
    super.key,
    this.iconOfCustomEditButton,
    this.onTapCustomEditIcon,
    this.isShowCustomEditButton = false,
  });

  final IconData? iconOfCustomEditButton;
  final void Function()? onTapCustomEditIcon;
  final bool isShowCustomEditButton;

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
                  CustomEditButton(
                    iconColor: Colors.brown[800],
                    backgroundColor: Colors.amberAccent.shade100,
                    onTap: onTapCustomEditIcon!,
                    icon: iconOfCustomEditButton!,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
