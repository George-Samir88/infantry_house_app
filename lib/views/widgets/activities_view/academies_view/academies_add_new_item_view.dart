import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infantry_house_app/views/widgets/activities_view/academies_view/models/academies_item_model.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../global_variables.dart' show GlobalData;
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../../../utils/custom_elevated_button.dart';
import 'manager/academies_cubit.dart';

class AcademiesAddNewItemView extends StatefulWidget {
  const AcademiesAddNewItemView({super.key});

  @override
  State<AcademiesAddNewItemView> createState() =>
      _AcademiesAddNewItemViewState();
}

class _AcademiesAddNewItemViewState extends State<AcademiesAddNewItemView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool isAnimationVisible = false;

  void _playAnimation() {
    _animationController.forward(from: 0); // Restart animation from beginning
    setState(() {
      isAnimationVisible = true; // Show animation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        isShowValidationErrorMessages = false;
        _imageFile = File(pickedFile.path);
      });
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController trainerNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isShowValidationErrorMessages = false;

  bool _validateImage(File? image) {
    if (image == null) {
      isShowValidationErrorMessages = true;
      setState(() {});
      return false;
    }
    return true;
  }

  final ScrollController _scrollController = ScrollController();

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
          title: S.of(context).AddingNewDailyGame,
        ),
      ),
      body: BlocBuilder<AcademiesCubit, AcademiesState>(
        builder: (context, state) {
          var cubit = context.read<AcademiesCubit>();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: _scrollController,
                children: [
                  SizedBox(height: 20.h),
                  //------mobile design
                  Text(
                    S.of(context).TitleOfGame,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  CustomTextFormField(
                    textEditingController: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).PleaseEnterTitleOfGame;
                      }
                      return null;
                    },
                    hintText: S.of(context).EnterTitleOfGame,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).GamePrice,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  CustomTextFormField(
                    textEditingController: priceController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).PleaseEnterPriceOfGame;
                      }
                      return null;
                    },
                    hintText: S.of(context).EnterPriceOfGame,
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).TrainerName,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  CustomTextFormField(
                    textEditingController: trainerNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).PleaseEnterTrainerName;
                      }
                      return null;
                    },
                    hintText: S.of(context).EnterTrainerName,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).Description,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  CustomTextFormField(
                    textEditingController: descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).PleaseEnterDescription;
                      }
                      return null;
                    },
                    hintText: S.of(context).EnterDescription,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).DailyGamesItemImage,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: GlobalData().isTabletLayout ? 220.h : 150.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          _imageFile != null
                              ? Image.file(_imageFile!, fit: BoxFit.cover)
                              : Center(
                                child: Text(
                                  S.of(context).AddDailyGamesItemImage,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                    ),
                  ),
                  if (isShowValidationErrorMessages)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 10),
                      child: Text(
                        S.of(context).PleaseAddDailyGamesItemImage,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red[900],
                        ),
                      ),
                    ),
                  SizedBox(height: 25.h),
                  CustomElevatedButton(
                    onPressed: () {
                      bool validateTextForm = _formKey.currentState!.validate();
                      bool validateImageForm = _validateImage(_imageFile);
                      if (validateTextForm && validateImageForm) {
                        cubit.addNewItem(
                          newActivity: AcademiesItemModel(
                            trainerName: trainerNameController.text,
                            activityImage: _imageFile!.path,
                            price: priceController.text,
                            title: titleController.text,
                            description: descriptionController.text,
                          ),
                        );
                        FocusScope.of(context).unfocus();
                        titleController.clear();
                        priceController.clear();
                        trainerNameController.clear();
                        descriptionController.clear();
                        _imageFile = null;
                        _playAnimation();
                      }
                    },
                    text: S.of(context).hefz,
                    width: MediaQuery.of(context).size.width,
                    tabletLayout: GlobalData().isTabletLayout,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: isAnimationVisible,
                        child: SizedBox(
                          height: 100.h,
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
                    ],
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

  String formatNumber(String value) {
    double? number = double.tryParse(value); // Try parsing to double

    if (number == null) {
      return "Invalid number"; // Handle invalid cases
    }

    // Format to always have exactly two decimal places
    return number.toStringAsFixed(2);
  }
}
