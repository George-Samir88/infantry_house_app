import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/utils/custom_empty_items_template.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../../../utils/custom_edit_button.dart';
import 'daily_games_add_new_item_view.dart';
import 'daily_games_edit_screen_department_view.dart';
import 'daily_games_update_and_delete_item.dart';
import 'daily_games_custom_description_of_activity_item.dart';
import 'daily_games_custom_vertical_list_of_daily_activity.dart';
import 'daily_games_horizontal_list_of_department.dart';
import 'manager/daily_games_cubit.dart';

class DailyGamesView extends StatelessWidget {
  const DailyGamesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DailyGamesCubit()..initialRotation(),
      child: Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.h),
          child: CustomAppBarEditingView(
            onPressed: () {
              Navigator.pop(context);
            },
            title: S.of(context).DailyGames,
          ),
        ),
        body: BlocBuilder<DailyGamesCubit, DailyGamesState>(
          builder: (context, state) {
            var cubit = context.read<DailyGamesCubit>();
            return Padding(
              padding: EdgeInsets.only(
                right: GlobalData().isArabic ? 0 : 16.w,
                left: GlobalData().isArabic ? 16.w : 0,
                top: 20.0.h,
              ),
              child:
                  cubit.mapBetweenCategoriesAndActivities.isNotEmpty
                      ? Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: GlobalData().isArabic ? 16.w : 0,
                              left: GlobalData().isArabic ? 0 : 16.w,
                            ),
                            height: 40.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: DailyGamesHorizontalListOfDepartment(
                                    cubit: cubit,
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                CustomEditButton(
                                  iconColor: Colors.brown[800],
                                  backgroundColor: Colors.amberAccent.shade100,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BlocProvider.value(
                                              value: cubit,
                                              child:
                                                  DailyGamesEditScreenDepartmentView(),
                                            ),
                                      ),
                                    );
                                  },
                                  icon: Icons.edit,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CustomScrollView(
                              slivers: [
                                SliverFillRemaining(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        opacity: 0.2,
                                        image: AssetImage(
                                          "assets/images/daily_activity_background.jpg",
                                        ),
                                        fit:
                                            BoxFit
                                                .cover, // Cover the entire screen
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SizedBox(height: 10.h),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (cubit
                                                      .mapBetweenCategoriesAndActivities[cubit
                                                          .selectedCategory]
                                                      ?.isNotEmpty ??
                                                  false) ...[
                                                Expanded(
                                                  flex: 1,
                                                  child:
                                                      CustomVerticalListOfDailyActivity(
                                                        cubit: cubit,
                                                      ),
                                                ),
                                                SizedBox(width: 10.w),
                                                Expanded(
                                                  flex: 2,
                                                  child: Stack(
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      CustomDescriptionOfActivityItem(
                                                        dailyActivityItemModel:
                                                            cubit
                                                                .mapBetweenCategoriesAndActivities
                                                                .values
                                                                .toList()[cubit
                                                                .currentSelectedCategoryIndex][cubit
                                                                .currentSelectedItemIndex],
                                                      ),
                                                      Positioned(
                                                        left:
                                                            GlobalData()
                                                                    .isArabic
                                                                ? 10.w
                                                                : null,
                                                        right:
                                                            GlobalData()
                                                                    .isArabic
                                                                ? null
                                                                : 10.w,
                                                        top: 0,
                                                        child: CustomEditButton(
                                                          iconColor:
                                                              Colors.brown[800],
                                                          backgroundColor:
                                                              Colors
                                                                  .amberAccent
                                                                  .shade100,
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => BlocProvider.value(
                                                                      value:
                                                                          cubit,
                                                                      child: DailyGamesUpdateAndDeleteItemView(
                                                                        dailyActivityItemModel:
                                                                            cubit.mapBetweenCategoriesAndActivities.values.toList()[cubit.currentSelectedCategoryIndex][cubit.currentSelectedItemIndex],
                                                                      ),
                                                                    ),
                                                              ),
                                                            );
                                                          },
                                                          icon: Icons.edit,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                              if (cubit
                                                      .mapBetweenCategoriesAndActivities[cubit
                                                          .selectedCategory]
                                                      ?.isEmpty ??
                                                  true) ...[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 16.0.w,
                                                    ),
                                                    child: CustomEmptyItemsTemplate(
                                                      iconOfCustomEditButton:
                                                          Icons.add,
                                                      isShowCustomEditButton:
                                                          true,
                                                      onTapCustomEditIcon: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (
                                                                  context,
                                                                ) => BlocProvider.value(
                                                                  value: cubit,
                                                                  child:
                                                                      DailyGamesAddNewItemView(),
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10.h),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                      : Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            opacity: 0.2,
                            image: AssetImage(
                              "assets/images/daily_activity_background.jpg",
                            ),
                            fit: BoxFit.cover, // Cover the entire screen
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/box.png',
                              height: 100.h,
                              width: 100.w,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              S.of(context).LaYogdAksam,
                              style: TextStyle(fontSize: 20.sp),
                            ),
                            SizedBox(height: 20.h),
                            CustomEditButton(
                              iconColor: Colors.brown[800],
                              backgroundColor: Colors.amberAccent.shade100,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BlocProvider.value(
                                          value: cubit,
                                          child:
                                              DailyGamesEditScreenDepartmentView(),
                                        ),
                                  ),
                                );
                              },
                              icon: Icons.add,
                            ),
                          ],
                        ),
                      ),
            );
          },
        ),
      ),
    );
  }
}
