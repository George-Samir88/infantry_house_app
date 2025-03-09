import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/views/widgets/food_and_beverage_view/manager/custom_menu_and_button_menu/food_and_beverage_button_and_menu_cubit.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../widgets_2/food_and_beverage_view/dots_indicator.dart';
import '../editing_carousel_view/manager/edit_carousel_food_and_beverage_cubit.dart';
import '../editing_carousel_view/presentation/edit_carousel_view.dart';
import '../editing_carousel_view/presentation/empty_carousel_item.dart';
import '../editing_menu_buttons_view/presentation/editing_menu_buttons_view.dart';
import 'custom_button_in_filtration.dart';
import 'custom_edit_button.dart';

class ParadiseRestaurantView extends StatefulWidget {
  const ParadiseRestaurantView({super.key});

  @override
  State<ParadiseRestaurantView> createState() => _ParadiseRestaurantViewState();
}

class _ParadiseRestaurantViewState extends State<ParadiseRestaurantView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      EditCarouselOfFoodAndBeverageCubit,
      EditCarouselOfFoodAndBeverageState
    >(
      builder: (context, state) {
        var cubit = context.read<EditCarouselOfFoodAndBeverageCubit>();
        var editMenuCubit = context.read<FoodAndBeverageButtonAndMenuCubit>();
        return Column(
          children: [
            SizedBox(height: 20.h),
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (cubit.newCarouselItems.isNotEmpty)
                  CarouselSlider.builder(
                    itemCount: cubit.newCarouselItems.length,
                    itemBuilder:
                        (context, index, realIndex) =>
                            cubit.newCarouselItems[index],
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
                if (cubit.newCarouselItems.isEmpty)
                  EmptyCarouselContainer(
                  ),
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
                          builder:
                              (context) => BlocProvider.value(
                                value: cubit,
                                child: const EditCarouselView(),
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
                  currentIndex: currentIndex,
                  itemCount: cubit.newCarouselItems.length,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Row(
                children: [
                  Text(
                    S.of(context).Menu,
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  CustomEditButton(
                    height: GlobalData().isTabletLayout ? 50.h : null,
                    width: GlobalData().isTabletLayout ? 30.w : null,
                    iconSize: GlobalData().isTabletLayout ? 40.r : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: editMenuCubit,
                                child: const EditingMenuButtonsView(),
                              ),
                        ),
                      );
                    },
                    icon: Icons.edit,
                    iconColor: Colors.black,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            CustomButtonInfiltrationAndMenuItems(),
            SizedBox(height: 40.h),
          ],
        );
      },
    );
  }
}
