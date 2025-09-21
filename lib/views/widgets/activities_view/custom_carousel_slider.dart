import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global_variables.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/empty_carousel_item.dart';
import 'activities_edit_carousel_template.dart';
import 'manager/activity_cubit.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({super.key, required this.activityCubit});

  final ActivityCubit activityCubit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (activityCubit.carouselItems.isNotEmpty) ...[
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: CarouselSlider.builder(
              itemCount: activityCubit.carouselItems.length,
              itemBuilder:
                  (context, index, realIndex) =>
                      activityCubit.carouselItems[index],
              options: CarouselOptions(
                onPageChanged: (index, other) {
                  activityCubit.changeCarouselIndex(index: index);
                },
                height: GlobalData().isTabletLayout ? 280.h : 180.h,
                clipBehavior: Clip.none,
                padEnds: true,
                enlargeCenterPage: true,
                viewportFraction: 1.2,
                enableInfiniteScroll: true,
                autoPlay: true,
              ),
            ),
          ),
          Positioned(
            left: GlobalData().isArabic ? 5.w : null,
            right: GlobalData().isArabic ? null : 5.w,
            bottom: -20.h,
            child: CustomEditButton(
              iconColor: Colors.brown[800],
              backgroundColor: Colors.amberAccent.shade100,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: activityCubit,
                          child: ActivityEditCarouselTemplateView(),
                        ),
                  ),
                );
              },
              icon: Icons.edit,
            ),
          ),
        ],
        if (activityCubit.carouselItems.isEmpty) ...[
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: EmptyCarouselContainer(
              onTab: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: activityCubit,
                          child: ActivityEditCarouselTemplateView(),
                        ),
                  ),
                );
              }, canManage: true,
            ),
          ),
        ],
      ],
    );
  }
}
