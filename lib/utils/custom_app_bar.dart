import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.onPressedOnMenuButton,
    required this.onPressedOnMyCartButton,
    required this.appBarTitle,
  });

  final void Function() onPressedOnMenuButton;
  final void Function() onPressedOnMyCartButton;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      /// card color : Color(0xff6F4E37)
      // color: Color(0xffF5F5F5),
      color: Color(0xff6F4E37),
      child: Padding(
        padding: EdgeInsets.only(
          top: GlobalData().isTabletLayout ? 16 : 6,
          left: GlobalData().isTabletLayout ? 20 : 12,
          right: GlobalData().isTabletLayout ? 20 : 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onPressedOnMenuButton,
              icon: Icon(
                Icons.menu,
                size: GlobalData().isTabletLayout ? 30.r : 26.r,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 30.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appBarTitle,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 12.sp : 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,

                    ///main color of app
                    // color: Color(0xff64432A),
                  ),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: onPressedOnMyCartButton,
              icon: Icon(
                Icons.shopping_cart,
                size: GlobalData().isTabletLayout ? 30.r : 26.r,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
