import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infantry_house_app/utils/custom_elevated_button.dart';
import 'package:infantry_house_app/views/widgets/food_and_beverage_view/manager/food_and_beverage/food_and_beverage_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../global_variables.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../widgets/editing_carousel_view/presentation/empty_carousel_item.dart';
import 'custom_carousel_item.dart';
import '../../widgets/food_and_beverage_view/custom_edit_button.dart';
import 'dots_indicator.dart';


class EditCarouselTemplateView extends StatefulWidget {
  const EditCarouselTemplateView({super.key});

  @override
  State<EditCarouselTemplateView> createState() =>
      _EditCarouselTemplateViewState();
}

class _EditCarouselTemplateViewState extends State<EditCarouselTemplateView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    super.initState();
  }

  bool isAnimationVisible = false;

  void _playAnimation() {
    _animationController.forward(from: 0); // Restart animation from beginning
    setState(() {
      isAnimationVisible = true; // Show animation
    });
    _animationController.forward().whenComplete(() {
      setState(() {
        isAnimationVisible = false;
      });
    });
  }

  int currentIndex = 0;

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: CustomAppBarEditingView(
          onPressed: () {
            Navigator.pop(context);
          },
          title: S.of(context).t3delE3lan,
        ),
      ),
      body: BlocBuilder<FoodAndBeverageCubit, FoodAndBeverageState>(
        builder: (context, state) {
          var cubit = context.read<FoodAndBeverageCubit>();
          List<Widget> carouselItems =
              cubit.newScreensMap[cubit.selectedScreen]?.carouselWidgets ?? [];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                if (carouselItems.isNotEmpty)
                  Stack(
                    children: [
                      CarouselSlider.builder(
                        itemCount: carouselItems.length,
                        itemBuilder:
                            (context, index, realIndex) => Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.passthrough,
                              children: [
                                carouselItems[index],
                                Positioned(
                                  left: 10,
                                  bottom: -20,
                                  child: Row(
                                    children: [
                                      CustomEditButton(
                                        backgroundColor: Colors.red,
                                        height:
                                            GlobalData().isTabletLayout
                                                ? 50.h
                                                : 34.h,
                                        width:
                                            GlobalData().isTabletLayout
                                                ? 30.w
                                                : 44.w,
                                        iconSize:
                                            GlobalData().isTabletLayout
                                                ? 40.r
                                                : 25.r,
                                        onTap: () {
                                          cubit.removeCarouselItem(
                                            index: index,
                                          );
                                        },
                                        iconColor: Colors.white,
                                        icon: Icons.cancel,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                          autoPlay: false,
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
                      itemCount: carouselItems.length,
                    ),
                  ],
                ),
                if (carouselItems.isEmpty)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      EmptyCarouselContainer(),
                      Positioned(
                        left: 10,
                        bottom: -20,
                        child: CustomEditButton(
                          height: GlobalData().isTabletLayout ? 50.h : null,
                          width: GlobalData().isTabletLayout ? 30.w : null,
                          iconSize: GlobalData().isTabletLayout ? 40.r : null,
                          onTap: () async {
                            await _pickImage();
                            setState(() {});
                            if (_image != null) {
                              cubit.addCarouselItem(
                                customCarouselItem: CustomCarouselItem(
                                  imagePath: _image!.path,
                                  isPickedImage: true,
                                ),
                              );
                              _image = null;
                            }
                          },
                          icon: Icons.add,
                          iconColor: Colors.white,
                          backgroundColor: Color(0xFF6D3A2D),
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          textColor: Color(0xFF6D3A2D),
                          backGroundColor: Colors.grey[300],
                          onPressed: () async {
                            setState(() {});
                            await _pickImage();
                            setState(() {});
                            if (_image != null) {
                              cubit.addCarouselItem(
                                customCarouselItem: CustomCarouselItem(
                                  imagePath: _image!.path,
                                  isPickedImage: true,
                                ),
                              );
                              _image = null;
                            }
                          },
                          text: S.of(context).EdaftGded,
                          tabletLayout: GlobalData().isTabletLayout,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      if (carouselItems.isNotEmpty)
                        Expanded(
                          child: CustomElevatedButton(
                            onPressed: () {
                              _playAnimation();
                            },
                            text: S.of(context).hefz,
                            tabletLayout: GlobalData().isTabletLayout,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Visibility(
                  visible: isAnimationVisible,
                  child: Container(
                    height: 100,
                    alignment: Alignment.center,

                    child: Lottie.asset(
                      controller: _animationController,
                      onLoaded: (composition) {
                        _animationController.duration = composition.duration;
                      },
                      backgroundLoading: true,
                      alignment: Alignment.centerLeft,
                      'assets/animation/done_lottie.json',
                      // Local file
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
