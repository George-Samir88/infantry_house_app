import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';

class CustomActivityCardItem extends StatelessWidget {
  const CustomActivityCardItem({
    super.key,
    required this.activityTitle,
    required this.activityImage,
  });

  final String activityTitle;

  final String activityImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GlobalData().isTabletLayout ? 140.h : 100.h,
      child: Card(
        color: Colors.brown[400],
        elevation: 4,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: Image.asset(activityImage, fit: BoxFit.cover)),
            Positioned(
              right: -5,
              bottom: -15,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  activityTitle,
                  style: TextStyle(
                    color: Colors.brown[400],
                    fontSize: GlobalData().isTabletLayout ? 8.sp : 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
