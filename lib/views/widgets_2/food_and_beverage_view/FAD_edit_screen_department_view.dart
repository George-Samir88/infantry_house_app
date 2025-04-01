import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/utils/check_key_map_exist_before_adding.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_elevated_button.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_edit_button.dart';
import 'manager/food_and_beverage/food_and_beverage_cubit.dart';

class FoodAndBeverageEditScreenDepartmentView extends StatefulWidget {
  const FoodAndBeverageEditScreenDepartmentView({super.key});

  @override
  State<FoodAndBeverageEditScreenDepartmentView> createState() =>
      _FoodAndBeverageEditScreenDepartmentViewState();
}

class _FoodAndBeverageEditScreenDepartmentViewState
    extends State<FoodAndBeverageEditScreenDepartmentView>
    with SingleTickerProviderStateMixin {
  TextEditingController arabicTextEditingController = TextEditingController();
  TextEditingController englishTextEditingController = TextEditingController();

  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool isAnimationVisible = false;

  void _playAnimation() {
    _animationController.forward(from: 0); // Restart animation from beginning
    setState(() {
      isAnimationVisible = true; // Show animation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutQuad,
        );
      });
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
  ScrollController scrollController = ScrollController();

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
          return ListView(
            controller: scrollController,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    if (newButtonTitlesList.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(left: 16.w, right: 16.w),
                        height: 40.h,
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
                                    horizontal: 20.w,
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade400,
                                        // Shadow color with opacity
                                        spreadRadius: 1,
                                        // Spread area of the shadow
                                        blurRadius: 4,
                                        // Blur effect
                                        offset: Offset(
                                          3,
                                          1,
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
                                                ? 10.sp
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
                                        screenTitle:
                                            newButtonTitlesList[index]!,
                                      );
                                    },
                                    height:
                                        GlobalData().isTabletLayout
                                            ? 28.h
                                            : 25.h,
                                    width:
                                        GlobalData().isTabletLayout
                                            ? 20.w
                                            : 35.w,
                                    iconSize:
                                        GlobalData().isTabletLayout
                                            ? 18.r
                                            : 20.r,
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
                          style: TextStyle(fontSize: 20.sp),
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
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: CustomTextFormField(
                        textEditingController: arabicTextEditingController,
                        hintText: S.of(context).Ad5lEsmElkaemaInArabic,
                        textInputType: TextInputType.text,

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
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: CustomTextFormField(
                        textEditingController: englishTextEditingController,
                        hintText: S.of(context).Ad5lEsmElkaemaInEnglish,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).MnFdlkD5l3nwanElmenuInEnglish;
                          }
                          return null;
                        },
                        textInputType: TextInputType.text,
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
                                  bool existingKey =
                                      checkKeyMapExistBeforeAdding(
                                        cubit.newScreensMap,
                                        arabicTextEditingController.text,
                                      );
                                  if (!existingKey) {
                                    cubit.addNewScreen(
                                      screenTitle:
                                          GlobalData().isArabic
                                              ? arabicTextEditingController.text
                                              : englishTextEditingController
                                                  .text,
                                    );
                                    arabicTextEditingController.clear();
                                    englishTextEditingController.clear();
                                    FocusScope.of(context).unfocus();
                                  }
                                  if (existingKey) {
                                    showSnackBar(
                                      context: context,
                                      message:
                                          S
                                              .of(context)
                                              .TheSectionAlreadyExistsYouCannotAddANewSectionWithTheSameName,
                                      backgroundColor: Colors.red,
                                    );
                                  }
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
                            _animationController.duration =
                                composition.duration;
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
            ],
          );
        },
      ),
    );
  }
}
