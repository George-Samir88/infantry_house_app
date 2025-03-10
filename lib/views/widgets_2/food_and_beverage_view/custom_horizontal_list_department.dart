import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets_2/food_and_beverage_view/edit_screen_department_view.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../widgets/food_and_beverage_view/custom_edit_button.dart';
import 'manager/food_and_beverage/food_and_beverage_cubit.dart';

class CustomHorizontalListDepartment extends StatefulWidget {
  const CustomHorizontalListDepartment({super.key});

  @override
  State<CustomHorizontalListDepartment> createState() =>
      _CustomHorizontalListDepartmentState();
}

class _CustomHorizontalListDepartmentState
    extends State<CustomHorizontalListDepartment> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodAndBeverageCubit, FoodAndBeverageState>(
      builder: (context, state) {
        var cubit = context.read<FoodAndBeverageCubit>();
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
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        // Number of buttons
                        itemBuilder: (context, index) {
                          return GestureDetector(
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
                                    blurRadius: 10,
                                    // Blur effect
                                    offset: Offset(
                                      0,
                                      3,
                                    ), // Changes position of shadow (X, Y)
                                  ),
                                ],
                                color:
                                    cubit.selectedButtonCategoryIndex == index
                                        ? Colors.brown[800]
                                        : Color(0xffFAF7F0),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  categories[index],
                                  style: TextStyle(
                                    color:
                                        cubit.selectedButtonCategoryIndex ==
                                                index
                                            ? Color(0xffFFFFFF)
                                            : Color(0xff5E3D2E),
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
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 12.w);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    CustomEditButton(
                      iconSize: GlobalData().isTabletLayout ? 40.r : null,
                      height: GlobalData().isTabletLayout ? 50.h : null,
                      width: GlobalData().isTabletLayout ? 30.w : null,
                      iconColor: Colors.black,
                      backgroundColor: Colors.grey.shade200,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BlocProvider.value(
                                  value: cubit,
                                  child: EditScreenDepartmentView(),
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
