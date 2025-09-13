import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/views/widgets/general_template/custom_button_and_menu_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/edit_carousel_view_template.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/empty_carousel_item.dart';
import '../../../utils/dots_indicator.dart';

class GeneralBodyTemplateView extends StatelessWidget {
  const GeneralBodyTemplateView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      builder: (context, state) {
        var cubit = context.read<DepartmentCubit>();
        List<Widget> carouselItemsList = [];
        // cubit.newScreensMap[cubit.selectedScreen]?.carouselWidgets ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 20.h),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (carouselItemsList.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: CarouselSlider.builder(
                          itemCount: carouselItemsList.length,
                          itemBuilder:
                              (context, index, realIndex) =>
                                  carouselItemsList[index],
                          options: CarouselOptions(
                            onPageChanged: (index, other) {
                              cubit.changeCarouselIndex(index: index);
                            },
                            height: GlobalData().isTabletLayout ? 280.h : 180.h,
                            clipBehavior: Clip.none,
                            padEnds: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.2,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                          ),
                        ),
                      ),
                      Positioned(
                        left: GlobalData().isArabic ? 5.w : null,
                        right: GlobalData().isArabic ? null : 5.w,
                        bottom: -20.h,
                        child: CustomEditButton(
                          iconColor: Colors.brown[800],
                          backgroundColor: Colors.amberAccent.shade100,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BlocProvider.value(
                                      value: cubit,
                                      child: EditCarouselViewTemplate(),
                                    ),
                              ),
                            );
                          },
                          icon: Icons.edit,
                        ),
                      ),
                    ],
                    if (carouselItemsList.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: EmptyCarouselContainer(
                          onTab: () async {
                            // if (cubit.newScreensMap.isNotEmpty) {
                            if (1 > 0) {
                              await context.read<DepartmentCubit>().getDepartmentsNames();
                              await context.read<DepartmentCubit>().getAllSubScreenNames();
                              await context
                                  .read<DepartmentCubit>()
                                    .deleteSubScreen(subScreenName: 'lamaraaaaaaaaaa',);

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder:
                              //         (context) => BlocProvider.value(
                              //           value: cubit,
                              //           child: EditCarouselViewTemplate(),
                              //         ),
                              //   ),
                              // );
                            } else {
                              showSnackBar(
                                context: context,
                                message:
                                    S.of(context).PleaseAddAMainCategoryFirst,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotsIndicator(
                      currentIndex: cubit.currentCarouselIndex,
                      itemCount: carouselItemsList.length,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButtonAndMenuTemplate(
                  menuTitle:
                      // cubit.newScreensMap[cubit.selectedScreen]?.menuTitle ??
                      '',
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ],
        );
      },
    );
  }
}
