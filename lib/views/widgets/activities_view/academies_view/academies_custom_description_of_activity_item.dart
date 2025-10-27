import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/activities_view/academies_view/models/academies_item_model.dart';

import '../../../../generated/l10n.dart';
import 'manager/academies_cubit.dart';

class CustomDescriptionOfAcademyItem extends StatelessWidget {
  const CustomDescriptionOfAcademyItem({
    super.key,
    required this.academiesItemModel,
  });

  final AcademiesItemModel academiesItemModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademiesCubit, AcademiesState>(
      builder: (context, state) {
        var cubit = context.read<AcademiesCubit>();
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
                  academiesItemModel.activityImage,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                academiesItemModel.title,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                "${S.of(context).TrainerName}: ${academiesItemModel.trainerName}",
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.amberAccent.shade100,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                child: Text(
                  "\$${academiesItemModel.price}.00",
                  style: TextStyle(color: Colors.brown[800], fontSize: 14.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                academiesItemModel.description,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14.sp),
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
