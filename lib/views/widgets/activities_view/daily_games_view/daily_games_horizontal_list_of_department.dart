import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'daily_games_custom_item_in_horizontal_list_of_daily_activity.dart';
import 'manager/daily_games_cubit.dart';

class DailyGamesHorizontalListOfDepartment extends StatelessWidget {
  const DailyGamesHorizontalListOfDepartment({super.key, required this.cubit});

  final DailyGamesCubit cubit;

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
                  child: CustomItemInHorizontalListOfDailyActivity(
                    categoryTitle:
                        cubit.mapBetweenCategoriesAndActivities.keys
                            .toList()[index],
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
        itemCount: cubit.mapBetweenCategoriesAndActivities.keys.toList().length,
      ),
    );
  }
}
