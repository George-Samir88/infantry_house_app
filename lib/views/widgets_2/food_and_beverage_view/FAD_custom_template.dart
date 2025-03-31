import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../global_variables.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/FAD_empty_carousel_item.dart';
import 'FAD_custom_button_and_menu_template.dart';
import '../../../utils/dots_indicator.dart';
import 'FAD_edit_carousel_template.dart';
import 'manager/food_and_beverage/food_and_beverage_cubit.dart';

class FoodAndBeverageCustomTemplate extends StatelessWidget {
  const FoodAndBeverageCustomTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodAndBeverageCubit, FoodAndBeverageState>(
      builder: (context, state) {
        var cubit = context.read<FoodAndBeverageCubit>();
        List<Widget> carouselItemsList =
            cubit.newScreensMap[cubit.selectedScreen]?.carouselWidgets ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 20.h),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    if (carouselItemsList.isNotEmpty)
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
                            height: GlobalData().isTabletLayout ? 360.h : 180.h,
                            clipBehavior: Clip.none,
                            padEnds: true,
                            enlargeCenterPage: true,
                            viewportFraction: 1.2,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                          ),
                        ),
                      ),
                    if (carouselItemsList.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: EmptyCarouselContainer(),
                      ),
                    Positioned(
                      left: 10,
                      bottom: -20,
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
                                    child:
                                        FoodAndBeverageEditCarouselTemplateView(),
                                  ),
                            ),
                          );
                        },
                        icon: Icons.edit,
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
                FoodAndBeverageCustomButtonAndMenuTemplate(
                  menuTitle:
                      cubit.newScreensMap[cubit.selectedScreen]?.menuTitle ??
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
