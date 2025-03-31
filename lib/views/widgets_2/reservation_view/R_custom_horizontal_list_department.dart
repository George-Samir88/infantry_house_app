import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/views/widgets_2/reservation_view/R_edit_screen_department_view.dart';
import 'package:infantry_house_app/views/widgets_2/reservation_view/manager/reservation_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_edit_button.dart';

class ReservationCustomHorizontalListDepartment extends StatefulWidget {
  const ReservationCustomHorizontalListDepartment({super.key});

  @override
  State<ReservationCustomHorizontalListDepartment> createState() =>
      _ReservationCustomHorizontalListDepartmentState();
}

class _ReservationCustomHorizontalListDepartmentState
    extends State<ReservationCustomHorizontalListDepartment> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (context, state) {
        var cubit = context.read<ReservationCubit>();
        List<String> categories = cubit.getScreenKeys();
        return Stack(
          clipBehavior: Clip.none,
          children: [
            if (cubit.newScreensMap.isNotEmpty)
              Container(
                margin: EdgeInsets.only(left: 16.w, right: 16.w),
                height: GlobalData().isTabletLayout ? 60.h : 40.h,
                // Adjust height as needed
                child: Row(
                  children: [
                    Expanded(
                      child: AnimationLimiter(
                        child: ListView.separated(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
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
                                      cubit.selectedButtonCategoryIndex = index;
                                      setState(() {});
                                      cubit.changeSelectedScreen(
                                        buttonCategoryTitle: categories[index],
                                      );
                                    },
                                    child: Container(
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
                                            blurRadius: 2,
                                            // Blur effect
                                          ),
                                        ],
                                        color:
                                            cubit.selectedButtonCategoryIndex ==
                                                    index
                                                ? Color(0xffE3CBA7)
                                                : Color(0xffFAF7F0),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          categories[index],
                                          style: TextStyle(
                                            color: const Color(0xff5E3D2E),
                                            fontSize:
                                                GlobalData().isTabletLayout
                                                    ? (cubit.selectedButtonCategoryIndex ==
                                                            index
                                                        ? 10.sp
                                                        : 8.sp)
                                                    : cubit.selectedButtonCategoryIndex ==
                                                        index
                                                    ? 14.sp
                                                    : 12.sp,
                                            fontWeight:
                                                cubit.selectedButtonCategoryIndex ==
                                                        index
                                                    ? FontWeight.w500
                                                    : null,
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
                    ),
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
                                  child: ReservationEditScreenDepartmentView(),
                                ),
                          ),
                        );
                      },
                      icon: Icons.edit,
                    ),
                  ],
                ),
              ),
            if (cubit.newScreensMap.isEmpty)
              Center(
                child: Text(
                  S.of(context).LaYogdAksam,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 16.sp : 20.sp,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
