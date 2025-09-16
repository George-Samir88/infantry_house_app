import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_empty_items_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_items_template_view.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_menu_buttons_view_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../models/menu_title_model.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/custom_snackBar.dart';
import 'custom_menu_items_horizontal_grid_view.dart';

class CustomButtonAndMenuTemplate extends StatefulWidget {
  const CustomButtonAndMenuTemplate({super.key});

  @override
  State<CustomButtonAndMenuTemplate> createState() =>
      _CustomButtonAndMenuTemplateState();
}

class _CustomButtonAndMenuTemplateState
    extends State<CustomButtonAndMenuTemplate> {
  MenuTitleModel? menuTitleModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepartmentCubit, DepartmentState>(
      listener: (context, state) {
        if (state is DepartmentGetMenuTitleSuccessState) {
          menuTitleModel = state.menuTitleModel;
        } else if (state is DepartmentGetMenuTitleFailureState) {
          showSnackBar(context: context, message: state.failure);
        }
      },
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        List<String?> newButtonTitlesList = [];
        // newButtonTitlesList =
        //     cubit.newScreensMap[cubit.selectedScreen]?.buttonsAndItemsMap.keys
        //         .toList() ??
        //     [];
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0.w, right: 16.w),
              child: Row(
                children: [
                  cubit.subScreensList.isEmpty
                      ? Text(
                        S.of(context).EdaftGded,
                        style: TextStyle(
                          fontSize: GlobalData().isTabletLayout ? 16.sp : 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                      : state is DepartmentGetMenuTitleLoadingState
                      ? AppLoader()
                      : (state is DepartmentGetMenuTitleSuccessState
                          ? Text(
                            state.menuTitleModel.menuTitle ??
                                S.of(context).EdaftGded,
                            style: TextStyle(
                              fontSize:
                                  GlobalData().isTabletLayout ? 16.sp : 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : Text(
                            S.of(context).ErrorOccurred,
                            style: TextStyle(
                              fontSize:
                                  GlobalData().isTabletLayout ? 16.sp : 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                  SizedBox(width: 20.w),
                  CustomEditButton(
                    onTap: () {
                      if (cubit.subScreensList.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider.value(
                                  value: cubit,
                                  child: EditMenuButtonsViewTemplate(
                                    menuTitleModel: menuTitleModel!,
                                  ),
                                ),
                          ),
                        );
                      } else {
                        showSnackBar(
                          context: context,
                          message: S.of(context).PleaseAddAMainCategoryFirst,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
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
                  left: GlobalData().isArabic ? 0 : 16.w,
                  right: GlobalData().isArabic ? 16.w : 0,
                ),
                height: 40.h,
                // Adjust height as needed
                child: AnimationLimiter(
                  child: ListView.separated(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    itemCount: newButtonTitlesList.length,
                    // Number of buttons
                    itemBuilder: (context, index) {
                      bool isSelected = index == 0;
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(seconds: 1),
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              // cubit.selectedButtonIndex = index;
                              cubit.updateSelectedList(
                                buttonTitle:
                                    newButtonTitlesList[index].toString(),
                                screenName: cubit.selectedSubScreen,
                              );
                            },
                            child: Container(
                              margin:
                                  index == newButtonTitlesList.length - 1
                                      ? EdgeInsets.only(
                                        right: GlobalData().isArabic ? 0 : 16.w,
                                        left: GlobalData().isArabic ? 16.w : 0,
                                      )
                                      : null,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                                    fontSize: isSelected ? 14.sp : 12.sp,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
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
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
            SizedBox(height: 10.h),
            Stack(
              clipBehavior: Clip.none,
              children: [
                // if(cubit.listToBeShow.isNotEmpty ||
                //     cubit.isEmptyMenuItems == false)
                if (true)
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
                    margin: EdgeInsets.only(top: 20.h, left: 12.w, right: 12.w),
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 24.w,
                      top: 30.h,
                      bottom: 20.h,
                    ),
                    constraints: BoxConstraints(
                      minHeight: 100.h, // Set a reasonable minimum height
                      maxHeight:
                          GlobalData().isTabletLayout
                              ? 400.h
                              : 320
                                  .h, // Set a reasonable max height if necessary
                    ),
                    child: CustomMenuItemsHorizontalGridView(menuItemModel: []),
                  ),
                // if (cubit.listToBeShow.isEmpty ||
                //     cubit.isEmptyMenuItems == true)
                if (true) CustomEmptyItemsTemplate(),
                if (newButtonTitlesList.isNotEmpty)
                  Positioned(
                    left: GlobalData().isArabic ? 10.w : null,
                    right: GlobalData().isArabic ? null : 10.w,
                    bottom: -20.h,
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
                                    child: EditItemsTemplateView(
                                      // listIndex: cubit.selectedButtonIndex,
                                      // buttonTitle:
                                      //     newButtonTitlesList[cubit
                                      //         .selectedButtonIndex]!,
                                      screenName: cubit.selectedSubScreen,
                                      listIndex: 0,
                                      buttonTitle: '',
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
