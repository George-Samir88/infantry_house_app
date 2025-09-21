import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_sub_screen_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../models/sub_screen_model.dart';
import '../../../utils/custom_edit_button.dart';

class SubScreenTemplate extends StatefulWidget {
  const SubScreenTemplate({super.key});

  @override
  State<SubScreenTemplate> createState() => _SubScreenTemplateState();
}

class _SubScreenTemplateState extends State<SubScreenTemplate> {
  List<SubScreenModel> subScreens = [];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<DepartmentCubit>();
    cubit.listenToSubScreens();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepartmentCubit, DepartmentState>(
      listener: (context, state) {
        if (state is DepartmentGetSubScreensNamesFailureState) {
          showSnackBar(
            context: context,
            message: state.error,
            backgroundColor: Colors.red,
          );
        }
      },
      buildWhen: (previous, current) {
        return current is DepartmentGetSubScreensNamesSuccessState ||
            current is DepartmentGetSubScreensNamesLoadingState ||
            current is DepartmentGetSubScreensNamesFailureState ||
            current is DepartmentGetSubScreensNamesEmptyState;
      },
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        if (state is DepartmentGetSubScreensNamesSuccessState) {
          return Container(
            margin: EdgeInsets.only(
              left: GlobalData().isTabletLayout ? 12.w : 16.w,
              right: GlobalData().isTabletLayout ? 12.w : 16.w,
            ),
            height: 40.h,
            // Adjust height as needed
            child: Row(
              children: [
                cubit.subScreensList.isNotEmpty
                    ? Expanded(
                      child: AnimationLimiter(
                        child: ListView.separated(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemCount: cubit.subScreensList.length,
                          // Number of buttons
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              duration: Duration(seconds: 1),
                              position: index,
                              child: SlideAnimation(
                                horizontalOffset: 100.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      cubit.changeSelectedSubScreen(
                                        subScreenButtonId:
                                            cubit.subScreensList[index].uid,
                                        index: index,
                                      );
                                    },
                                    child: Container(
                                      clipBehavior: Clip.none,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade400,
                                            // Shadow color with opacity
                                            spreadRadius: 1,
                                            // Spread area of the shadow
                                            blurRadius: 2,
                                            // Blur effect
                                          ),
                                        ],
                                        color:
                                            cubit.selectedSubScreenIndex ==
                                                    index
                                                ? Color(0xffE3CBA7)
                                                : Color(0xffFAF7F0),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          cubit
                                              .subScreensList[index]
                                              .subScreenName,
                                          style: TextStyle(
                                            color: const Color(0xff5E3D2E),
                                            fontSize:
                                                cubit.selectedSubScreenIndex ==
                                                        index
                                                    ? 14.sp
                                                    : 12.sp,
                                            fontWeight:
                                                cubit.selectedSubScreenIndex ==
                                                        index
                                                    ? FontWeight.w600
                                                    : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 12.w);
                          },
                        ),
                      ),
                    )
                    : Center(
                      child: Text(
                        S.of(context).LaYogdAksam,
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                    ),
                if (cubit.canManage) ...[
                  SizedBox(width: 12.w),
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
                                child: EditSubScreenTemplateView(),
                              ),
                        ),
                      );
                    },
                    icon: Icons.edit,
                  ),
                ],
              ],
            ),
          );
        } else if (state is DepartmentGetSubScreensNamesLoadingState) {
          return AppLoader();
        } else if (state is DepartmentGetSubScreensNamesFailureState) {
          return Center(
            child: Center(
              child: Text(
                S.of(context).ErrorOccurred,
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              ),
            ),
          );
        } else if (state is DepartmentGetSubScreensNamesEmptyState) {
          return Container(
            margin: EdgeInsets.only(
              left: GlobalData().isTabletLayout ? 12.w : 16.w,
              right: GlobalData().isTabletLayout ? 12.w : 16.w,
            ),
            height: 40.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Text(
                    S.of(context).LaYogdAksam,
                    style: TextStyle(color: Colors.white, fontSize: 20.sp),
                  ),
                ),
                if (cubit.canManage) ...[
                  SizedBox(width: 12.w),
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
                                child: EditSubScreenTemplateView(),
                              ),
                        ),
                      );
                    },
                    icon: Icons.edit,
                  ),
                ],
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
