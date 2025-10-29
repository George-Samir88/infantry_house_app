import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_dialog.dart';
import 'package:infantry_house_app/utils/custom_error_template.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/custom_elevated_button.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/no_internet_connection_template.dart';

class EditSubScreenTemplateView extends StatefulWidget {
  const EditSubScreenTemplateView({super.key});

  @override
  State<EditSubScreenTemplateView> createState() =>
      _EditSubScreenTemplateViewState();
}

class _EditSubScreenTemplateViewState extends State<EditSubScreenTemplateView>
    with SingleTickerProviderStateMixin {
  TextEditingController arabicTextEditingController = TextEditingController();
  TextEditingController englishTextEditingController = TextEditingController();
  TextEditingController updatedSubScreenArController = TextEditingController();
  TextEditingController updatedSubScreenEnController = TextEditingController();

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
    final cubit = context.read<DepartmentCubit>();
    cubit.listenToSubScreens();
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
      body: BlocConsumer<DepartmentCubit, DepartmentState>(
        buildWhen: (previous, current) {
          return current is DepartmentGetSubScreensNamesSuccessState ||
              current is DepartmentGetSubScreensNamesLoadingState ||
              current is DepartmentGetSubScreensNamesFailureState ||
              current is DepartmentCreateSubScreensNamesSuccessState ||
              current is DepartmentCreateSubScreensNamesLoadingState ||
              current is DepartmentCreateSubScreensNamesFailureState ||
              current is DepartmentUpdateSubScreensNamesSuccessState ||
              current is DepartmentUpdateSubScreensNamesLoadingState ||
              current is DepartmentUpdateSubScreensNamesFailureState ||
              current is DepartmentDeleteSubScreensNamesSuccessState ||
              current is DepartmentDeleteSubScreensNamesLoadingState ||
              current is DepartmentNoInternetConnectionState ||
              current is DepartmentDeleteSubScreensNamesFailureState;
        },
        listener: (context, state) {
          if (state is DepartmentCreateSubScreensNamesSuccessState) {
            _playAnimation();
          } else if (state is DepartmentCreateCarouselFailureState) {
            showSnackBar(context: context, message: state.failure);
          } else if (state is DepartmentDeleteSubScreensNamesFailureState) {
            showSnackBar(context: context, message: state.failure);
          } else if (state is DepartmentUpdateSubScreensNamesFailureState) {
            showSnackBar(context: context, message: state.failure);
          } else if (state is DepartmentNoInternetConnectionState) {
            showSnackBar(
              context: context,
              message: state.message,
              backgroundColor: Colors.yellow[800],
            );
          }
        },
        builder: (context, state) {
          var cubit = context.read<DepartmentCubit>();
          return state is DepartmentNoInternetConnectionState
              ? NoInternetConnectionWidget(
                onRetry: () async {
                  if (await cubit.hasInternetConnection()) {
                    if (!context.mounted) return;
                    cubit.listenToSubScreens();
                  }
                },
              )
              : state is DepartmentGetSubScreensNamesFailureState
              ? CustomErrorTemplate(
                isShowCustomEditButton: true,
                onRetry: () async {
                  if (await cubit.hasInternetConnection()) {
                    if (!context.mounted) return;
                    cubit.listenToSubScreens();
                  }
                },
              )
              : ListView(
                controller: scrollController,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        if (cubit.subScreensList.isNotEmpty) ...[
                          state is DepartmentDeleteSubScreensNamesLoadingState ||
                                  state is DepartmentUpdateSubScreensNamesLoadingState
                              ? AppLoader()
                              : Container(
                                margin: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                ),
                                height: 40.h,
                                // Adjust height as needed
                                child: ListView.separated(
                                  clipBehavior: Clip.none,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: cubit.subScreensList.length,
                                  // Number of buttons
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (await cubit
                                                .hasInternetConnection()) {
                                              updatedSubScreenArController
                                                  .text = cubit
                                                      .subScreensList[index]
                                                      .subScreenArName;
                                              updatedSubScreenEnController
                                                  .text = cubit
                                                      .subScreensList[index]
                                                      .subScreenEnName;
                                              if (!context.mounted) return;
                                              showInputDialog(
                                                context: context,
                                                englishController:
                                                    updatedSubScreenEnController,
                                                arabicController:
                                                    updatedSubScreenArController,
                                                onUpdateConfirmed: (value) {
                                                  if (updatedSubScreenArController
                                                          .text
                                                          .isNotEmpty &&
                                                      updatedSubScreenEnController
                                                          .text
                                                          .isNotEmpty) {
                                                    Navigator.of(context).pop();
                                                    cubit.updateSubScreen(
                                                      newSuperCatNameAr:
                                                          updatedSubScreenArController
                                                              .text
                                                              .trim(),
                                                      newSuperCatNameEn:
                                                          updatedSubScreenEnController
                                                              .text
                                                              .trim(),
                                                      subScreenUID:
                                                          cubit
                                                              .subScreensList[index]
                                                              .uid,
                                                    );
                                                  }
                                                },
                                                onDeletePressed: () {
                                                  Navigator.pop(context);
                                                  cubit.deleteSubScreen(
                                                    subScreenUID:
                                                        cubit
                                                            .subScreensList[index]
                                                            .uid,
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
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
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                            ),
                                            child: Center(
                                              child: Text(
                                                GlobalData().isArabic
                                                    ? cubit
                                                        .subScreensList[index]
                                                        .subScreenArName
                                                    : cubit
                                                        .subScreensList[index]
                                                        .subScreenEnName,
                                                style: TextStyle(
                                                  color: Color(0xff5E3D2E),
                                                  fontSize:
                                                      GlobalData()
                                                              .isTabletLayout
                                                          ? 10.sp
                                                          : 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (
                                    BuildContext context,
                                    int index,
                                  ) {
                                    return SizedBox(width: 12.w);
                                  },
                                ),
                              ),
                        ],
                        if (cubit.subScreensList.isEmpty)
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
                                return S
                                    .of(context)
                                    .MnFdlkD5l3nwanElmenuInArabic;
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
                                return S
                                    .of(context)
                                    .MnFdlkD5l3nwanElmenuInEnglish;
                              }
                              return null;
                            },
                            textInputType: TextInputType.text,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        state is DepartmentCreateSubScreensNamesLoadingState
                            ? AppLoader()
                            : Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      textColor: Color(0xFF6D3A2D),
                                      backGroundColor: Colors.grey[300],
                                      onPressed: () async {
                                        if (await cubit
                                            .hasInternetConnection()) {
                                          if (formKey.currentState!
                                              .validate()) {
                                            if (!context.mounted) return;
                                            FocusScope.of(context).unfocus();
                                            cubit.createSubScreen(
                                              subScreenArName:
                                                  arabicTextEditingController
                                                      .text,
                                              subScreenEnName:
                                                  englishTextEditingController
                                                      .text,
                                            );
                                          }
                                          arabicTextEditingController.clear();
                                          englishTextEditingController
                                              .clear();
                                        }
                                      },
                                      text: S.of(context).EdaftGded,
                                      tabletLayout: GlobalData().isTabletLayout,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  if (cubit.subScreensList.isNotEmpty)
                                    Expanded(
                                      child: CustomElevatedButton(
                                        onPressed: () {},
                                        text: S.of(context).hefz,
                                        tabletLayout:
                                            GlobalData().isTabletLayout,
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
