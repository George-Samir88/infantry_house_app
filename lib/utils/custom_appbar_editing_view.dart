import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global_variables.dart';

class CustomAppBarEditingView extends StatelessWidget {
  const CustomAppBarEditingView({
    super.key,
    required this.onPressed,
    required this.title,
  });

  final void Function() onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF6D3A2D),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.5,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              title,
              style: TextStyle(
                fontSize: GlobalData().isTabletLayout ? 10.sp : 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 26.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
