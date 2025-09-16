import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/models/menu_title_model.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_edit_button.dart';
import '../../../utils/custom_snackBar.dart';

class EditMenuButtonsViewTemplate extends StatefulWidget {
  const EditMenuButtonsViewTemplate({super.key, required this.menuTitleModel});

  final MenuTitleModel menuTitleModel;

  @override
  State<EditMenuButtonsViewTemplate> createState() =>
      _EditMenuButtonsViewTemplateState();
}

class _EditMenuButtonsViewTemplateState
    extends State<EditMenuButtonsViewTemplate>
    with SingleTickerProviderStateMixin {
  TextEditingController arabicTextEditingController = TextEditingController();
  TextEditingController englishTextEditingController = TextEditingController();
  TextEditingController categoryTextEditingController = TextEditingController();
  int selectedIndex = 0; // Track selected button index

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

  @override
  void didChangeDependencies() {
    categoryTextEditingController.text =
        widget.menuTitleModel.menuTitle ?? S.of(context).EdaftGded;
    super.didChangeDependencies();
  }

  final GlobalKey<FormState> buttonsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> menuTitleFormKey = GlobalKey<FormState>();
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
          title: S.of(context).t3delKwaem,
        ),
      ),
      body: BlocConsumer<DepartmentCubit, DepartmentState>(
        listener: (context , state ) {
          if(state is DepartmentUpdateMenuTitleSuccessState){
            _playAnimation();
          }
        },
        builder: (context, state) {
          var cubit = context.read<DepartmentCubit>();
          List<String?> newButtonTitlesList = [];
          newButtonTitlesList = [];
          // cubit.newScreensMap[cubit.selectedScreen]?.buttonsAndItemsMap.keys
          //     .toList() ??
          // [];
          return ListView(
            controller: scrollController,
            children: [
              Form(
                key: menuTitleFormKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: CustomTextFormField(
                        textEditingController: categoryTextEditingController,
                        hintText: S.of(context).Ad5lEsmEltsnef,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).MnFdlkAd5lEsmEltsnef;
                          }
                          return null;
                        },
                        textInputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    state is DepartmentUpdateMenuTitleLoadingState ? AppLoader() : CustomElevatedButton(
                      width: MediaQuery.sizeOf(context).width * 0.4,
                      onPressed: () {
                        if (menuTitleFormKey.currentState!.validate()) {
                          cubit.updateMenuTitle(
                            menuTitle: categoryTextEditingController.text,
                          );
                          FocusScope.of(context).unfocus();

                        }
                      },
                      text: S.of(context).hefz,
                      tabletLayout: GlobalData().isTabletLayout,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Divider(color: Colors.grey, thickness: 2),
              ),
              Form(
                key: buttonsFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            bool isSelected = index == selectedIndex;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Stack(
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
                                          blurRadius: 10,
                                          // Blur effect
                                          offset: Offset(
                                            0,
                                            3,
                                          ), // Changes position of shadow (X, Y)
                                        ),
                                      ],
                                      color:
                                          isSelected
                                              ? Colors.brown[800]
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        newButtonTitlesList[index]!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSelected ? 16.sp : 14.sp,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: GlobalData().isArabic ? -5.w : null,
                                    right: GlobalData().isArabic ? null : -5.w,
                                    bottom: -10.h,
                                    child: Row(
                                      children: [
                                        CustomEditButton(
                                          onTap: () {
                                            cubit.removeButton(
                                              screenName:
                                                  cubit.selectedSubScreen,
                                              buttonTitle:
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(width: 8.w);
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
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              textColor: Color(0xFF6D3A2D),
                              backGroundColor: Colors.grey[300],
                              onPressed: () async {
                                if (buttonsFormKey.currentState!.validate()) {
                                  bool existingButton = 1 > 0;
                                  // checkKeyMapExistBeforeAdding(
                                  //   cubit
                                  //       .newScreensMap[cubit
                                  //           .selectedScreen]!
                                  //       .buttonsAndItemsMap,
                                  //   arabicTextEditingController.text,
                                  // );
                                  if (!existingButton) {
                                    cubit.addNewButton(
                                      buttonTitle:
                                          GlobalData().isArabic
                                              ? arabicTextEditingController.text
                                              : englishTextEditingController
                                                  .text,
                                      screenName: cubit.selectedSubScreen,
                                    );
                                    arabicTextEditingController.clear();
                                    englishTextEditingController.clear();
                                    FocusScope.of(context).unfocus();
                                  } else if (existingButton) {
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
                          if (newButtonTitlesList.isNotEmpty)
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
