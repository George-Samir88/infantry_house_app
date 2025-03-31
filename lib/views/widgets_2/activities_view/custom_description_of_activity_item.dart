import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/models/daily_activity_item_model.dart';
import 'package:infantry_house_app/views/widgets_2/activities_view/manager/daily_games_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';

class CustomDescriptionOfActivityItem extends StatelessWidget {
  const CustomDescriptionOfActivityItem({
    super.key,
    required this.dailyActivityItemModel,
  });

  final DailyActivityItemModel dailyActivityItemModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyGamesCubit, DailyGamesState>(
      builder: (context, state) {
        var cubit = context.read<DailyGamesCubit>();
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedRotation(
                turns: cubit.rotationAngle / 360, // Converts degrees to turns
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
                child: _buildCircularImage(
                  dailyActivityItemModel.activityImage,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                dailyActivityItemModel.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: GlobalData().isTabletLayout ? 12.sp : 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "${S.of(context).TrainerName}: ${dailyActivityItemModel.trainerName}",
                style: TextStyle(
                  fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.amberAccent.shade100,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                child: Text(
                  "\$${dailyActivityItemModel.price}.00",
                  style: TextStyle(
                    color: Colors.brown[800],
                    fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                dailyActivityItemModel.description,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Container(
        height: 180.h,
        width: 180.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(imagePath),
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return Container(
        height: 180.h,
        width: 180.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(File(imagePath)),
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
  }
}
