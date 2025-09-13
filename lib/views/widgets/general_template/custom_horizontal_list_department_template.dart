import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_screen_depratment_view_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_edit_button.dart';

class CustomHorizontalListDepartmentsTemplate extends StatelessWidget {
  const CustomHorizontalListDepartmentsTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        // List<String> categories = cubit.newScreensMap.keys.toList();
        return Container(
          margin: EdgeInsets.only(
            left: GlobalData().isTabletLayout ? 12.w : 16.w,
            right: GlobalData().isTabletLayout ? 12.w : 16.w,
          ),
          height: 40.h,
          // Adjust height as needed
          child: Row(
            children: [
              // cubit.newScreensMap.isNotEmpty
              1 > 0
                  ? Expanded(
                    child: AnimationLimiter(
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        // itemCount: categories.length,
                        itemCount: 1,
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
                                    cubit.changeSelectedScreen(
                                      buttonCategoryTitle: '',
                                      // buttonCategoryTitle: categories[index],
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
                                          cubit.selectedButtonCategoryIndex ==
                                                  index
                                              ? Color(0xffE3CBA7)
                                              : Color(0xffFAF7F0),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Center(
                                      child: Text(
                                        // categories[index],
                                        '',
                                        style: TextStyle(
                                          color: const Color(0xff5E3D2E),
                                          fontSize:
                                              cubit.selectedButtonCategoryIndex ==
                                                      index
                                                  ? 14.sp
                                                  : 12.sp,
                                          fontWeight:
                                              cubit.selectedButtonCategoryIndex ==
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
                            child: EditScreenDepartmentTemplateView(),
                          ),
                    ),
                  );
                },
                icon: Icons.edit,
              ),
            ],
          ),
        );
      },
    );
  }
}
