import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/views/widgets_2/activities_view/DG_add_new_item_view.dart';

import '../../../utils/custom_edit_button.dart';
import 'manager/daily_games_cubit.dart';

class CustomVerticalListOfDailyActivity extends StatelessWidget {
  CustomVerticalListOfDailyActivity({super.key, required this.cubit});

  final DailyGamesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: AnimationLimiter(
        child: Container(
          constraints: BoxConstraints(
            minWidth: GlobalData().isTabletLayout ? 60.w : 80.w,
            // Minimum width
            maxWidth:
                GlobalData().isTabletLayout ? 80.w : 90.w, // Maximum width
          ),
          padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              bottomLeft: Radius.circular(30.r),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount:
                      cubit
                          .mapBetweenCategoriesAndActivities[cubit
                              .selectedCategory]
                          ?.length ??
                      0,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(seconds: 1),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  index ==
                                          cubit
                                                  .mapBetweenCategoriesAndActivities[cubit
                                                      .selectedCategory]!
                                                  .length -
                                              1
                                      ? 0
                                      : GlobalData().isTabletLayout
                                      ? 12.h
                                      : 10.0.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                cubit.changeSelectedItemIndex(index: index);
                                cubit.triggerRotation();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    decoration: BoxDecoration(
                                      color:
                                          cubit.currentSelectedItemIndex ==
                                                  index
                                              ? Colors.amberAccent
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                        12.0.r,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4.0.h,
                                      horizontal: 4.0.w,
                                    ),
                                    curve: Curves.ease,
                                    duration: Duration(milliseconds: 300),
                                    child: Center(
                                      child: _buildCircularImage(
                                        cubit
                                            .mapBetweenCategoriesAndActivities[cubit
                                                .selectedCategory]![index]
                                            .activityImage,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  AnimatedContainer(
                                    curve: Curves.easeInOutQuad,
                                    duration: Duration(milliseconds: 300),
                                    width:
                                        cubit.currentSelectedItemIndex == index
                                            ? (GlobalData().isTabletLayout
                                                  ? 4.0.w
                                                : 8.0.w)
                                            : 0,
                                    // Animate width instead of removing the widget
                                    height:
                                        GlobalData().isTabletLayout
                                            ? 50.h
                                            : 40.h,
                                    margin: EdgeInsets.only(right: 6.0),
                                    // Space between border and image
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade300,
                                      borderRadius: BorderRadius.circular(
                                        4.0.r,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              CustomEditButton(
                height: GlobalData().isTabletLayout ? 45.h : 40.h,
                width: GlobalData().isTabletLayout ? 35.w : 50.w,
                iconSize: GlobalData().isTabletLayout ? 25.r : 25.r,
                iconColor: Colors.brown[800],
                backgroundColor: Colors.amberAccent.shade100,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BlocProvider.value(
                            value: cubit,
                            child: DailyGamesAddNewItemView(),
                          ),
                    ),
                  );
                },
                icon: Icons.add,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Container(
        width: GlobalData().isTabletLayout ? 40.w : 50.0.w,
        height: GlobalData().isTabletLayout ? 40.w : 50.0.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
          // Placeholder background color
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return Container(
        width: GlobalData().isTabletLayout ? 40.w : 50.0.w,
        height: GlobalData().isTabletLayout ? 40.w : 50.0.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
          // Placeholder background color
          image: DecorationImage(
            image: FileImage(File(imagePath)),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
  }
}
