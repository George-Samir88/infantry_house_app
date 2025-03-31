import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/utils/custom_empty_items_template.dart';
import 'package:infantry_house_app/views/widgets_2/reservation_view/R_editing_items_view.dart';
import 'package:infantry_house_app/views/widgets_2/reservation_view/R_editing_menu_buttons_view_template.dart';
import 'package:infantry_house_app/views/widgets_2/reservation_view/manager/reservation_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_edit_button.dart';
import '../../reusable_screens/custom_menu_items_horizontal_grid_view.dart';

class ReservationCustomButtonAndMenuTemplate extends StatelessWidget {
  const ReservationCustomButtonAndMenuTemplate({
    super.key,
    required this.menuTitle,
  });

  final String menuTitle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        var cubit = context.read<ReservationCubit>();
        List<String?> newButtonTitlesList = [];
        newButtonTitlesList =
            cubit.newScreensMap[cubit.selectedScreen]?.buttonsAndItemsMap.keys
                .toList() ??
            [];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Row(
                children: [
                  Text(
                    menuTitle.isEmpty ? S.of(context).EdaftGded : menuTitle,
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  CustomEditButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: cubit,
                                child:
                                    ReservationEditingMenuButtonsViewTemplate(
                                      categoryName: menuTitle,
                                    ),
                              ),
                        ),
                      );
                    },
                    icon: Icons.edit,
                    iconColor: Colors.brown[800],
                    backgroundColor: Colors.amberAccent.shade100,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            if (newButtonTitlesList.isNotEmpty)
              Container(
                margin: EdgeInsets.only(
                  left: GlobalData().isArabic ? 0 : 16,
                  right: GlobalData().isArabic ? 16 : 0,
                ),
                height: GlobalData().isTabletLayout ? 60.h : 40.h,
                // Adjust height as needed
                child: AnimationLimiter(
                  child: ListView.separated(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    itemCount: newButtonTitlesList.length,
                    // Number of buttons
                    itemBuilder: (context, index) {
                      bool isSelected = index == cubit.selectedButtonIndex;
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(seconds: 1),
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              cubit.selectedButtonIndex = index;
                              cubit.updateSelectedList(
                                buttonTitle:
                                    newButtonTitlesList[index].toString(),
                                screenName: cubit.selectedScreen,
                              );
                            },
                            child: Container(
                              margin:
                                  index == newButtonTitlesList.length - 1
                                      ? EdgeInsets.only(
                                        right: GlobalData().isArabic ? 0 : 16,
                                        left: GlobalData().isArabic ? 16 : 0,
                                      )
                                      : null,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    // Shadow color with opacity
                                    spreadRadius: 1,
                                    // Spread area of the shadow
                                    blurRadius: 10,
                                    // Blur effect
                                    offset: Offset(
                                      0,
                                      3,
                                    ), // Changes position of shadow (X, Y)
                                  ),
                                ],
                                color:
                                    isSelected
                                        ? Color(0xff6F4E37)
                                        : Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  newButtonTitlesList[index]!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        GlobalData().isTabletLayout
                                            ? (isSelected ? 10.sp : 8.sp)
                                            : isSelected
                                            ? 16.sp
                                            : 14.sp,
                                    fontWeight:
                                        isSelected ? FontWeight.w500 : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(width: 8.w);
                    },
                  ),
                ),
              ),
            if (newButtonTitlesList.isEmpty)
              Center(
                child: Text(
                  S.of(context).LaYogdAksam,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 16.sp : 20.sp,
                  ),
                ),
              ),
            SizedBox(height: 10.h),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (cubit.listToBeShow.isNotEmpty ||
                    cubit.isEmptyMenuItems == false)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          // Shadow color with opacity
                          spreadRadius: 5,
                          // Spread area of the shadow
                          blurRadius: 10,
                          // Blur effect
                          offset: Offset(
                            0,
                            3,
                          ), // Changes position of shadow (X, Y)
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Optional: Rounds corners
                    ),
                    margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                    padding: EdgeInsets.only(
                      left: GlobalData().isTabletLayout ? 10.w : 20.w,
                      right: GlobalData().isTabletLayout ? 10.w : 20.w,
                      top: 22.h,
                      bottom: 22.h,
                    ),
                    constraints: BoxConstraints(
                      minHeight: 100.h, // Set a reasonable minimum height
                      maxHeight:
                          GlobalData().isTabletLayout
                              ? 300.h
                              : 320
                                  .h, // Set a reasonable max height if necessary
                    ),
                    child: CustomMenuItemsHorizontalGridView(
                      menuItemModel: cubit.listToBeShow,
                    ),
                  ),
                if (cubit.listToBeShow.isEmpty ||
                    cubit.isEmptyMenuItems == true)
                  CustomEmptyItemsTemplate(),
                if (newButtonTitlesList.isNotEmpty)
                  Positioned(
                    left: 10,
                    bottom: -20,
                    child: CustomEditButton(
                      icon: Icons.edit,
                      iconColor: Colors.brown[800],
                      backgroundColor: Colors.amberAccent.shade100,
                      onTap: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BlocProvider.value(
                                    value: cubit,
                                    child: ReservationEditingItemsView(
                                      listIndex: cubit.selectedButtonIndex,
                                      buttonTitle:
                                          newButtonTitlesList[cubit
                                              .selectedButtonIndex]!,
                                      screenName: cubit.selectedScreen,
                                    ),
                                  ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
