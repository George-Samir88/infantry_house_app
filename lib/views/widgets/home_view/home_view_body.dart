import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:infantry_house_app/views/widgets/home_view/custom_app_bar.dart';
import 'package:infantry_house_app/views/widgets/home_view/custom_button_in_filtration.dart';
import 'package:infantry_house_app/views/widgets/home_view/dots_indicator.dart';

import 'custom_carousel_item.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int currentIndex = 0;
  final List<Widget> carouselItems = const [
    CustomCarouselItem(),
    CustomCarouselItem(),
    CustomCarouselItem(),
    CustomCarouselItem(),
    CustomCarouselItem(),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customAppBar(onPressed: widget.onPressed, context: context),
          const SizedBox(height: 5),
          LayoutBuilder(
            builder: (context, constraints) {
              // double screenWidth = constraints.maxWidth;
              // double viewportFraction = screenWidth > 600 ? 0.4 : 0.8;

              return CarouselSlider.builder(
                itemCount: carouselItems.length,
                itemBuilder:
                    (context, index, realIndex) => carouselItems[index],
                options: CarouselOptions(
                  onPageChanged: (index, other) {
                    currentIndex = index;
                    setState(() {});
                  },
                  height: 180,
                  clipBehavior: Clip.none,
                  padEnds: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.1,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DotsIndicator(
                currentIndex: currentIndex,
                itemCount: carouselItems.length,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Menu",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // RichText(
                //   text: TextSpan(
                //     children: [
                //       TextSpan(
                //         text: "Created by",
                //         style: TextStyle(fontSize: 14, color: Color(0xff7B766F)),
                //       ),
                //       TextSpan(
                //         text: " GS",
                //         style: TextStyle(
                //           fontSize: 14,
                //           color: Color(0xff5D4B3F),
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomButtonInfiltrationAndPopularItems(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
