import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';


customAppBar({required void Function() onPressed , required context ,  required String appBarTitle ,}) {
  return Container(
    color: Color(0xffF5F5F5),
    child: Padding(
      padding: EdgeInsets.only(
          top: GlobalData().isTabletLayout ? 16 : 6,
          left: 16  , right: GlobalData().isTabletLayout ?16 : 0
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: onPressed, icon: Icon(Icons.menu , size: GlobalData().isTabletLayout ? 30.r :26.r,) ,),

          SizedBox(
            width: 30.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   S.of(context).Hello,
              //   style: TextStyle(
              //     fontSize: tabletLayout ? 14.sp : 24.sp,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xff64432A),
              //   ),
              // ),
              Text(
                appBarTitle,
                style: TextStyle(
                  fontSize: GlobalData().isTabletLayout ? 12.sp :18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff64432A),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
