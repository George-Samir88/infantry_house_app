import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'academies_custom_item_in_horizontal_list_of_academy.dart';
import 'manager/academies_cubit.dart';

class AcademiesHorizontalListOfDepartment extends StatelessWidget {
  const AcademiesHorizontalListOfDepartment({super.key, required this.cubit});

  final AcademiesCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            duration: Duration(seconds: 1),
            position: index,
            child: SlideAnimation(
              horizontalOffset: 100.0,
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    cubit.changeCategoryIndex(index: index);
                  },
                  child: CustomItemInHorizontalListOfAcademies(
                    categoryTitle:

                            "ddddd",
                    isSelected: index == cubit.currentSelectedCategoryIndex,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 12.w);
        },
        itemCount: 1,
      ),
    );
  }
}
