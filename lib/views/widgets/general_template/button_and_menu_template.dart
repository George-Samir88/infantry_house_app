import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/utils/custom_empty_items_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_items_template_view.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_menu_buttons_view_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:infantry_house_app/views/widgets/general_template/shimmer_loader.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../models/menu_title_model.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/custom_snackBar.dart';
import 'custom_menu_items_horizontal_grid_view.dart';
import 'menu_items_horizontal_grid_view_shimmer_loading.dart';

class ButtonAndMenuTemplate extends StatelessWidget {
  const ButtonAndMenuTemplate({super.key});

  Widget buildMenuTitle(
    BuildContext context,
    DepartmentState state,
    DepartmentCubit cubit,
    MenuTitleModel? menuTitleModel,
  ) {
    final textStyle = TextStyle(
      fontSize: GlobalData().isTabletLayout ? 16.sp : 20.sp,
      fontWeight: FontWeight.bold,
    );

    if (cubit.subScreensList.isEmpty) {
      // 🔹 No subScreens at all
      return Text(S.of(context).EdaftGded, style: textStyle);
    }

    if (state is DepartmentGetMenuTitleLoadingState) {
      // 🔹 Loading state
      return ShimmerLoader(width: 150.w, height: 30.h);
    }

    if (state is DepartmentGetMenuTitleFailureState) {
      // 🔹 Error fetching menu title
      return Text(
        S.of(context).ErrorOccurred, // you can define this in ARB
        style: textStyle.copyWith(color: Colors.red),
      );
    }

    if (state is DepartmentGetMenuTitleEmptyState || menuTitleModel == null) {
      // 🔹 No menu title found
      return Text(S.of(context).EdaftGded, style: textStyle);
    }

    // 🔹 Success state (title available)
    return Text(
      menuTitleModel.menuTitle ?? S.of(context).EdaftGded,
      style: TextStyle(
        fontSize: GlobalData().isTabletLayout ? 16.sp : 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildMenuButtons(
    BuildContext context,
    DepartmentState state,
    DepartmentCubit cubit,
  ) {
    // 🔹 Common style
    final emptyTextStyle = TextStyle(fontSize: 20.sp);

    if (state is DepartmentGetMenuButtonLoadingState) {
      return Container(
        height: 40.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (_, __) => ShimmerLoader(width: 80.w, height: 40.h),
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
        ),
      );
    }

    if (state is DepartmentGetMenuButtonFailureState ||
        state is DepartmentGetMenuTitleFailureState) {
      // 🔹 Failure state
      return Center(
        child: Text(
          S.of(context).ErrorOccurred, // Add this in ARB for localization
          style: emptyTextStyle.copyWith(color: Colors.red),
        ),
      );
    }

    if (state is DepartmentGetMenuButtonEmptyState ||
        cubit.menuButtonList.isEmpty) {
      // 🔹 Empty state
      return Center(
        child: Text(S.of(context).LaYogdAksam, style: emptyTextStyle),
      );
    }

    // 🔹 Success state (buttons available)
    return Container(
      margin: EdgeInsets.only(
        left: GlobalData().isArabic ? 0 : 16.w,
        right: GlobalData().isArabic ? 16.w : 0,
      ),
      height: 40.h,
      child: AnimationLimiter(
        child: ListView.separated(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          itemCount: cubit.menuButtonList.length,
          itemBuilder: (context, index) {
            bool isSelected = index == cubit.selectedButtonIndex;
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(seconds: 1),
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () {
                    cubit.changeMenuButtonIndex(
                      index: index,
                      buttonId: cubit.menuButtonList[index].uid!,
                    );
                  },
                  child: Container(
                    margin:
                        index == cubit.menuButtonList.length - 1
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
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      color: isSelected ? const Color(0xff6F4E37) : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        cubit.menuButtonList[index].buttonTitle!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSelected ? 14.sp : 12.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
        ),
      ),
    );
  }

  Widget buildMenuItems(
    BuildContext context,
    DepartmentState state,
    DepartmentCubit cubit,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (state is DepartmentGetMenuItemLoadingState ||
            state is DepartmentGetMenuButtonLoadingState)
          const CustomMenuItemsHorizontalGridViewShimmer()
        else if (state is DepartmentGetMenuItemFailureState)
          // 🔹 Failure
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 20.h, left: 12.w, right: 12.w),
            padding: EdgeInsets.all(20.w),
            alignment: Alignment.center,
            child: Text(
              S.of(context).ErrorOccurred, // Add to ARB for localization
              style: TextStyle(fontSize: 16.sp, color: Colors.red),
            ),
          )
        else if (cubit.menuItemsList.isEmpty ||
            state is DepartmentGetMenuItemEmptyState)
          // 🔹 Empty
          const CustomEmptyItemsTemplate()
        else
          // 🔹 Success (items available)
          Container(
            width: MediaQuery.of(context).size.width,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(top: 20.h, left: 12.w, right: 12.w),
            padding: EdgeInsets.only(
              left: 20.w,
              right: 24.w,
              top: 30.h,
              bottom: 20.h,
            ),
            constraints: BoxConstraints(
              minHeight: 100.h,
              maxHeight: GlobalData().isTabletLayout ? 400.h : 320.h,
            ),
            child: const CustomMenuItemsHorizontalGridView(),
          ),

        // 🔹 Edit button (only if buttons exist and user can manage)
        if (cubit.menuButtonList.isNotEmpty && cubit.canManage)
          Positioned(
            left: GlobalData().isArabic ? 10.w : null,
            right: GlobalData().isArabic ? null : 10.w,
            bottom: -20.h,
            child: CustomEditButton(
              icon: Icons.edit,
              iconColor: Colors.brown[800],
              backgroundColor: Colors.amberAccent.shade100,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: cubit,
                          child: const EditItemsTemplateView(),
                        ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepartmentCubit, DepartmentState>(
      buildWhen: (previous, current) {
        return current is DepartmentGetMenuTitleSuccessState ||
            current is DepartmentGetMenuButtonSuccessState ||
            current is DepartmentGetMenuTitleLoadingState ||
            current is DepartmentGetMenuButtonLoadingState ||
            current is DepartmentGetMenuTitleFailureState ||
            current is DepartmentGetMenuButtonFailureState ||
            current is DepartmentGetMenuTitleEmptyState ||
            current is DepartmentGetMenuButtonEmptyState ||
            current is DepartmentGetMenuItemLoadingState ||
            current is DepartmentGetMenuItemFailureState ||
            current is DepartmentGetMenuItemEmptyState ||
            current is DepartmentChangeMenuButtonIndexState;
      },
      listener: (context, state) {
        if (state is DepartmentGetMenuTitleFailureState) {
          showSnackBar(context: context, message: state.failure);
        } else if (state is DepartmentGetMenuButtonFailureState) {
          showSnackBar(context: context, message: state.failure);
        } else if (state is DepartmentGetMenuItemFailureState) {
          showSnackBar(context: context, message: state.failure);
        }
      },
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16.0.w, right: 16.w),
              child: Row(
                children: [
                  buildMenuTitle(
                    context,
                    state,
                    cubit,
                    cubit.selectedMenuTitle,
                  ),
                  if (cubit.canManage) ...[
                    SizedBox(width: 20.w),
                    CustomEditButton(
                      onTap: () {
                        if (cubit.subScreensList.isNotEmpty &&
                            cubit.selectedSubScreenID != null &&
                            cubit.selectedMenuTitle != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BlocProvider.value(
                                    value: cubit,
                                    child: EditMenuButtonsAndMenuTitleTemplate(
                                      menuTitleModel: cubit.selectedMenuTitle!,
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
                ],
              ),
            ),
            SizedBox(height: 20.h),
            buildMenuButtons(context, state, cubit),
            SizedBox(height: 10.h),
            buildMenuItems(context, state, cubit),
          ],
        );
      },
    );
  }
}
