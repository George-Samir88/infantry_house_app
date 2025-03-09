import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/views/widgets/food_and_beverage_view/manager/food_and_beverage/food_and_beverage_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_elevated_button.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../widgets/food_and_beverage_view/custom_edit_button.dart';

class EditScreenDepartmentView extends StatefulWidget {
  const EditScreenDepartmentView({super.key});

  @override
  State<EditScreenDepartmentView> createState() =>
      _EditScreenDepartmentViewState();
}

class _EditScreenDepartmentViewState extends State<EditScreenDepartmentView>
    with SingleTickerProviderStateMixin {
  TextEditingController arabicTextEditingController = TextEditingController();
  TextEditingController englishTextEditingController = TextEditingController();

  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    super.initState();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: CustomAppBarEditingView(
          onPressed: () {
            //don't forget to add items to go back to the previous screen
            Navigator.pop(context);
          },
          title: S.of(context).T3delElaksam,
        ),
      ),
      body: BlocBuilder<FoodAndBeverageCubit, FoodAndBeverageState>(
        builder: (context, state) {
          var cubit = context.read<FoodAndBeverageCubit>();
          List<String?> newButtonTitlesList = [];
          newButtonTitlesList = cubit.screensMap.keys.toList();
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  if (newButtonTitlesList.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(left: 16.w, right: 16.w),
                      height: GlobalData().isTabletLayout ? 50.h : 40.h,
                      // Adjust height as needed
                      child: ListView.separated(
                        clipBehavior: Clip.none,
                        scrollDirection: Axis.horizontal,
                        itemCount: newButtonTitlesList.length,
                        // Number of buttons
                        itemBuilder: (context, index) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
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
                                  color: Color(0xffFAF7F0),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Center(
                                  child: Text(
                                    cubit.newScreensMap.keys.toList()[index],
                                    style: TextStyle(
                                      color: Color(0xff5E3D2E),
                                      fontSize:
                                          GlobalData().isTabletLayout
                                              ? 8.sp
                                              : 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: -10,
                                bottom: -15,
                                child: CustomEditButton(
                                  onTap: () {
                                    cubit.removeScreen(
                                      screenTitle: newButtonTitlesList[index]!,
                                    );
                                  },
                                  height:
                                      GlobalData().isTabletLayout ? 30.h : 25.h,
                                  width:
                                      GlobalData().isTabletLayout ? 15.w : 35.w,
                                  iconSize:
                                      GlobalData().isTabletLayout ? 24.r : 20.r,
                                  icon: Icons.cancel,
                                  iconColor: Colors.white,
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 12.w);
                        },
                      ),
                    ),
                  if (newButtonTitlesList.isEmpty)
                    Center(
                      child: Text(
                        S.of(context).LaYogdAksam,
                        style: TextStyle(
                          fontSize: GlobalData().isTabletLayout ? 16.sp : 20.sp,
                        ),
                      ),
                    ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          S.of(context).EdaftGded,
                          style: TextStyle(
                            fontSize:
                                GlobalData().isTabletLayout ? 10.sp : 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                      ),
                      controller: arabicTextEditingController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
                        ),
                        hintStyle: TextStyle(
                          fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                          color: Colors.grey,
                        ),
                        hintText: S.of(context).Ad5lEsmElkaemaInArabic,
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).MnFdlkD5l3nwanElmenuInArabic;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.w),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                      ),
                      controller: englishTextEditingController,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
                        ),
                        hintStyle: TextStyle(
                          fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                          color: Colors.grey,
                        ),
                        hintText: S.of(context).Ad5lEsmElkaemaInEnglish,
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).MnFdlkD5l3nwanElmenuInEnglish;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomElevatedButton(
                            textColor: Color(0xFF6D3A2D),
                            backGroundColor: Colors.grey[300],
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                cubit.addNewScreen(
                                  screenTitle:
                                      GlobalData().isArabic
                                          ? arabicTextEditingController.text
                                          : englishTextEditingController.text,
                                );
                                arabicTextEditingController.clear();
                                englishTextEditingController.clear();
                                FocusScope.of(context).unfocus();
                              }
                            },
                            text: S.of(context).EdaftGded,
                            tabletLayout: GlobalData().isTabletLayout,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        if (cubit.newScreensMap.isNotEmpty)
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
                      height: 100.h,
                      alignment: Alignment.center,
                      // Use relative units like 10.w or any desired fixed size
                      // Same for height
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
            ),
          );
        },
      ),
    );
  }
}
