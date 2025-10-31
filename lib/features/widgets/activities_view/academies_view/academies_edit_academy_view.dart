import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/check_key_map_exist_before_adding.dart';
import 'package:infantry_house_app/utils/custom_dialog.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:lottie/lottie.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../utils/custom_elevated_button.dart';
import '../../../../../utils/custom_appbar_editing_view.dart';
import '../../../../utils/custom_edit_button.dart';
import '../../../../utils/custom_snackBar.dart';
import 'manager/academies_cubit.dart';

class AcademiesEditAcademyView extends StatefulWidget {
  const AcademiesEditAcademyView({super.key});

  @override
  State<AcademiesEditAcademyView> createState() =>
      _AcademiesEditAcademyViewState();
}

class _AcademiesEditAcademyViewState extends State<AcademiesEditAcademyView>
    with SingleTickerProviderStateMixin {
  TextEditingController arabicTextEditingController = TextEditingController();
  TextEditingController englishTextEditingController = TextEditingController();

  late AnimationController _animationController;
  late ScrollController scrollController;

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
    scrollController = ScrollController();
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
      body: BlocConsumer<AcademiesCubit, AcademiesState>(
        listener: (context, state) {
          if (state is AcademyCreateFailureState) {
            showSnackBar(
              context: context,
              message: state.failure,
              backgroundColor: Colors.redAccent,
            );
          } else if (state is AcademyCreateSuccessState) {
            _playAnimation();
          }
        },
        builder: (context, state) {
          var cubit = context.read<AcademiesCubit>();
          List<String?> newButtonTitlesList = [];
          // newButtonTitlesList =
          //     cubit.mapBetweenCategoriesAndActivities.keys.toList();
          return Form(
            key: formKey,
            child: ListView(
              controller: scrollController,
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
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  // showInputDialog(context: context, arabicController: , englishController: , onUpdateConfirmed: , onDeletePressed: );
                                },
                                child: Center(
                                  child: Text(
                                    "   cubit.mapBetweenCategoriesAndActivities.keys.toList()[index]",
                                    style: TextStyle(
                                      color: Color(0xff5E3D2E),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).MnFdlkD5l3nwanElmenuInArabic;
                      }
                      return null;
                    },
                    textInputType: TextInputType.text,
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
                state is AcademyCreateLoadingState
                    ? const AppLoader()
                    : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              textColor: Color(0xFF6D3A2D),
                              backGroundColor: Colors.grey[300],
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  cubit.createAcademy(
                                    academyNameAr:
                                        arabicTextEditingController.text,
                                    academyNameEn:
                                        englishTextEditingController.text,
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
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: () {},
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
          );
        },
      ),
    );
  }
}
