import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';
import '../../widgets_2/food_and_beverage_view/dots_indicator.dart';
import '../food_and_beverage_view/custom_button_in_filtration.dart';
import '../../widgets_2/food_and_beverage_view/custom_carousel_item.dart';
import '../food_and_beverage_view/custom_edit_button.dart';

class WashingViewBody extends StatefulWidget {
  const WashingViewBody({super.key});

  @override
  State<WashingViewBody> createState() => _WashingViewBodyState();
}

class _WashingViewBodyState extends State<WashingViewBody> {
  int currentIndex = 0;
  List<Widget> carouselItems = [
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee2.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee2.jpg',
      isPickedImage: false,
    ),
    CustomCarouselItem(
      imagePath: 'assets/images/coffee.jpg',
      isPickedImage: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.h),
        LayoutBuilder(
          builder: (context, constraints) {
            // double screenWidth = constraints.maxWidth;
            // double viewportFraction = screenWidth > 600 ? 0.4 : 0.8;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                if (carouselItems.isNotEmpty)
                  CarouselSlider.builder(
                    itemCount: carouselItems.length,
                    itemBuilder:
                        (context, index, realIndex) => carouselItems[index],
                    options: CarouselOptions(
                      onPageChanged: (index, other) {
                        currentIndex = index;
                        setState(() {});
                      },
                      height: 180.h,
                      clipBehavior: Clip.none,
                      padEnds: true,
                      enlargeCenterPage: true,
                      viewportFraction: 1.2,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                  ),
                // if (carouselItems.isEmpty) EmptyCarouselContainer(),
                Positioned(
                  left: 10,
                  bottom: -20,
                  child: CustomEditButton(
                    iconColor: Colors.black,
                    backgroundColor: Colors.grey.shade200,
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EditCarouselView(tabletLayout: false,),
                      //   ),
                      // );
                    },
                    icon: Icons.edit,
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DotsIndicator(
              currentIndex: currentIndex,
              itemCount: carouselItems.length,
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
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 20.w),
              CustomEditButton(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => EditingMenuButtonsView(),
                  //   ),
                  // );
                  ;
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
  }
}
