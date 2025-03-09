import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/editing_items_view/presentation/editing_items_view.dart';
import 'package:infantry_house_app/views/widgets/food_and_beverage_view/manager/food_and_beverage/food_and_beverage_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../widgets/food_and_beverage_view/custom_edit_button.dart';
import '../../widgets/food_and_beverage_view/custom_menu_items_horizontal_grid_view.dart';
import 'editing_menu_buttons_view_template.dart';

class CustomButtonAndMenuTemplate extends StatelessWidget {
  const CustomButtonAndMenuTemplate({super.key, required this.menuTitle});

  final String menuTitle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodAndBeverageCubit, FoodAndBeverageState>(
      builder: (context, state) {
        var cubit = context.read<FoodAndBeverageCubit>();
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
                    height: GlobalData().isTabletLayout ? 50.h : null,
                    width: GlobalData().isTabletLayout ? 30.w : null,
                    iconSize: GlobalData().isTabletLayout ? 40.r : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: cubit,
                                child: EditingMenuButtonsViewTemplate(),
                              ),
                        ),
                      );
                    },
                    icon: Icons.edit,
                    iconColor: Colors.black,
                    backgroundColor: Colors.grey.shade200,
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
                height: GlobalData().isTabletLayout ? 60.h : 50.h,
                // Adjust height as needed
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  itemCount: newButtonTitlesList.length,
                  // Number of buttons
                  itemBuilder: (context, index) {
                    bool isSelected = index == cubit.selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        cubit.selectedIndex = index;
                        cubit.updateSelectedList(
                          buttonTitle: newButtonTitlesList[index].toString(),
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
                          color: isSelected ? Color(0xff6F4E37) : Colors.grey,
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
                              fontWeight: isSelected ? FontWeight.w500 : null,
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
                  Container(
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
                      left: 20.w,
                      right: 20.w,
                      top: 22.h,
                      bottom: 20.h,
                    ),
                    constraints: BoxConstraints(
                      minHeight: 100.h, // Set a reasonable minimum height
                      maxHeight:
                          GlobalData().isTabletLayout
                              ? 300.h
                              : 320
                                  .h, // Set a reasonable max height if necessary
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/box.png',
                                height:
                                    GlobalData().isTabletLayout ? 80.h : 100.h,
                                width:
                                    GlobalData().isTabletLayout ? 80.h : 100.w,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                S.of(context).LaYogd3nasr,
                                style: TextStyle(
                                  fontSize:
                                      GlobalData().isTabletLayout
                                          ? 16.sp
                                          : 20.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (newButtonTitlesList.isNotEmpty)
                  Positioned(
                    left: 10,
                    bottom: -20,
                    child: CustomEditButton(
                      height: GlobalData().isTabletLayout ? 50.h : null,
                      width: GlobalData().isTabletLayout ? 30.w : null,
                      iconSize: GlobalData().isTabletLayout ? 40.r : null,
                      icon: Icons.edit,
                      iconColor: Colors.black,
                      backgroundColor: Colors.grey.shade200,
                      onTap: () {
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BlocProvider.value(
                                    value: cubit,
                                    child: EditingItemsView(
                                      menuItemsModelList: cubit.listToBeShow,
                                      listIndex: cubit.selectedIndex,
                                      // listIndex: editMenuCubit.selectedIndex,
                                      // buttonTitle: buttonTitlesList[editMenuCubit.selectedIndex],
                                      buttonTitle:
                                          newButtonTitlesList[cubit
                                              .selectedIndex]!,
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
