import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/editing_items_view/presentation/editing_items_view.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import 'custom_edit_button.dart';
import '../../widgets_2/food_and_beverage_view/custom_menu_items_horizontal_grid_view.dart';
import 'manager/custom_menu_and_button_menu/food_and_beverage_button_and_menu_cubit.dart';

class CustomButtonInfiltrationAndMenuItems extends StatelessWidget {
  const CustomButtonInfiltrationAndMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      FoodAndBeverageButtonAndMenuCubit,
      FoodAndBeverageButtonAndMenuState
    >(
      builder: (context, state) {
        var editMenuCubit = context.read<FoodAndBeverageButtonAndMenuCubit>();
        List<String> newButtonTitlesList = [];
        newButtonTitlesList =
            context
                .read<FoodAndBeverageButtonAndMenuCubit>()
                .newAllButtonsAndItemsMap
                .keys
                .toList();

        return Column(
          children: [
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
                    bool isSelected =
                        index ==
                        context
                            .read<FoodAndBeverageButtonAndMenuCubit>()
                            .selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<FoodAndBeverageButtonAndMenuCubit>()
                            .selectedIndex = index;
                        context
                            .read<FoodAndBeverageButtonAndMenuCubit>()
                            .updateSelectedList(
                              buttonTitle:
                                  newButtonTitlesList[index].toString(),
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
                            newButtonTitlesList[index],
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
            if (newButtonTitlesList.isEmpty &&
                context
                        .read<FoodAndBeverageButtonAndMenuCubit>()
                        .isEmptyMenuItems ==
                    true)
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
                if (context
                    .read<FoodAndBeverageButtonAndMenuCubit>()
                    .listToBeShow
                    .isNotEmpty)
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
                      menuItemModel:
                          context
                              .read<FoodAndBeverageButtonAndMenuCubit>()
                              .listToBeShow,
                    ),
                  ),
                if (context
                    .read<FoodAndBeverageButtonAndMenuCubit>()
                    .listToBeShow
                    .isEmpty)
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
                      if (newButtonTitlesList.isNotEmpty &&
                          context
                                  .read<FoodAndBeverageButtonAndMenuCubit>()
                                  .isEmptyMenuItems ==
                              false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider.value(
                                  value: editMenuCubit,
                                  child: EditingItemsView(
                                    menuItemsModelList:
                                        editMenuCubit.listToBeShow,
                                    listIndex: editMenuCubit.selectedIndex,
                                    buttonTitle:
                                        newButtonTitlesList[editMenuCubit
                                            .selectedIndex], screenName: '',
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
