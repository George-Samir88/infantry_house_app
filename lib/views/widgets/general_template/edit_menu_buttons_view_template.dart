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
import '../../../models/menu_button_model.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/custom_snackBar.dart';

class EditMenuButtonsAndMenuTitleTemplate extends StatefulWidget {
  const EditMenuButtonsAndMenuTitleTemplate({
    super.key,
    required this.menuTitleModel,
  });

  final MenuTitleModel menuTitleModel;

  @override
  State<EditMenuButtonsAndMenuTitleTemplate> createState() =>
      _EditMenuButtonsAndMenuTitleTemplateState();
}

class _EditMenuButtonsAndMenuTitleTemplateState
    extends State<EditMenuButtonsAndMenuTitleTemplate>
    with SingleTickerProviderStateMixin {
  TextEditingController arabicTextEditingController = TextEditingController();
  TextEditingController englishTextEditingController = TextEditingController();
  TextEditingController menuTitleARTextEditingController =
      TextEditingController();
  TextEditingController menuTitleENTextEditingController =
      TextEditingController();

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
    cubit.listenToMenuButtons();
    cubit.listenToMenuTitle();
  }

  @override
  void didChangeDependencies() {
    menuTitleARTextEditingController.text =
        widget.menuTitleModel.menuTitle ?? S.of(context).EdaftGded;
    super.didChangeDependencies();
  }

  final GlobalKey<FormState> buttonsFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> menuTitleFormKey = GlobalKey<FormState>();
  final TextEditingController updateMenuButtonController =
      TextEditingController();
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
        listener: (context, state) {
          if (state is DepartmentUpdateMenuTitleSuccessState ||
              state is DepartmentCreateMenuButtonSuccessState ||
              state is DepartmentDeleteMenuButtonSuccessState) {
            _playAnimation();
          } else if (state is DepartmentGetMenuTitleFailureState) {
            showSnackBar(context: context, message: state.failure);
          } else if (state is DepartmentUpdateMenuTitleFailureState) {
            showSnackBar(context: context, message: state.failure);
          } else if (state is DepartmentCreateMenuButtonFailureState) {
            showSnackBar(context: context, message: state.failure);
          } else if (state is DepartmentDeleteMenuButtonFailureState) {
            showSnackBar(context: context, message: state.failure);
          }
        },
        builder: (context, state) {
          var cubit = context.read<DepartmentCubit>();
          List<MenuButtonModel?> menuButtonsList = cubit.menuButtonList;
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
                        textEditingController: menuTitleARTextEditingController,
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
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                      child: CustomTextFormField(
                        textEditingController: menuTitleENTextEditingController,
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

                    state is DepartmentUpdateMenuTitleLoadingState
                        ? AppLoader()
                        : CustomElevatedButton(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          onPressed: () {
                            if (menuTitleFormKey.currentState!.validate()) {
                              cubit.updateMenuTitle(
                                menuTitle:
                                    menuTitleARTextEditingController.text,
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
                    state is DepartmentGetMenuButtonLoadingState ||
                            state is DepartmentUpdateMenuButtonLoadingState ||
                            state is DepartmentDeleteMenuButtonLoadingState
                        ? AppLoader()
                        : cubit.menuButtonList.isNotEmpty
                        ? Container(
                          margin: EdgeInsets.only(left: 16.w, right: 16.w),
                          height: 40.h,
                          // Adjust height as needed
                          child: ListView.separated(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            itemCount: menuButtonsList.length,
                            // Number of buttons
                            itemBuilder: (context, index) {
                              bool isSelected =
                                  index == cubit.selectedButtonIndex;
                              return GestureDetector(
                                onTap: () {
                                  cubit.changeMenuButtonIndex(
                                    index: index,
                                    buttonId: menuButtonsList[index]!.uid!,
                                  );
                                  updateMenuButtonController.text =
                                      menuButtonsList[cubit
                                              .selectedButtonIndex]!
                                          .buttonTitle!;
                                  showInputDialog(
                                    context: context,
                                    controller: updateMenuButtonController,
                                    onUpdateConfirmed: (String value) {
                                      Navigator.pop(context);
                                      cubit.updateMenuButton(
                                        buttonId: menuButtonsList[index]!.uid!,
                                        newTitle:
                                            updateMenuButtonController.text,
                                      );
                                    },
                                    onDeletePressed: () {
                                      Navigator.pop(context);
                                      cubit.deleteMenuButton(
                                        buttonId: menuButtonsList[index]!.uid!,
                                      );
                                    },
                                  );
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
                                      menuButtonsList[index]!.buttonTitle!,
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
                              );
                            },
                            separatorBuilder: (
                              BuildContext context,
                              int index,
                            ) {
                              return SizedBox(width: 8.w);
                            },
                          ),
                        )
                        : Center(
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
                    state is DepartmentCreateMenuButtonLoadingState
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
                                    if (buttonsFormKey.currentState!
                                        .validate()) {
                                      cubit.createMenuButton(
                                        buttonTitle:
                                            GlobalData().isArabic
                                                ? arabicTextEditingController
                                                    .text
                                                : englishTextEditingController
                                                    .text,
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
