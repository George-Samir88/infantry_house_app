import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:infantry_house_app/views/widgets/food_and_beverage_view/manager/food_and_beverage/food_and_beverage_cubit.dart';

import '../../../global_variables.dart';
import '../../widgets/editing_carousel_view/presentation/empty_carousel_item.dart';
import '../../widgets/food_and_beverage_view/custom_edit_button.dart';
import 'custom_button_and_menu_template.dart';
import 'dots_indicator.dart';
import 'edit_carousel_template.dart';

class CustomTemplate extends StatefulWidget {
  const CustomTemplate({super.key});

  @override
  State<CustomTemplate> createState() => _CustomTemplateState();
}

class _CustomTemplateState extends State<CustomTemplate> {
  int currentIndex = 0;

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
                      CarouselSlider.builder(
                        itemCount: carouselItemsList.length,
                        itemBuilder:
                            (context, index, realIndex) =>
                                carouselItemsList[index],
                        options: CarouselOptions(
                          onPageChanged: (index, other) {
                            currentIndex = index;
                            setState(() {});
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
                    if (carouselItemsList.isEmpty) EmptyCarouselContainer(),
                    Positioned(
                      left: 10,
                      bottom: -20,
                      child: CustomEditButton(
                        height: GlobalData().isTabletLayout ? 50.h : null,
                        width: GlobalData().isTabletLayout ? 30.w : null,
                        iconSize: GlobalData().isTabletLayout ? 40.r : null,
                        iconColor: Colors.black,
                        backgroundColor: Colors.grey.shade200,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(value: cubit , child: EditCarouselTemplateView(),),
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
                      currentIndex: currentIndex,
                      itemCount: carouselItemsList.length,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButtonAndMenuTemplate(
                  menuTitle:
                      cubit.newScreensMap[cubit.selectedScreen]?.menuTitle ?? '',
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
