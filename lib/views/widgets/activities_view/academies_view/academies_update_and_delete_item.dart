import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infantry_house_app/views/widgets/activities_view/academies_view/models/academies_item_model.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../global_variables.dart';
import '../../../../utils/custom_appbar_editing_view.dart';
import '../../../../utils/custom_elevated_button.dart';
import 'manager/academies_cubit.dart';

class AcademiesUpdateAndDeleteItemView extends StatefulWidget {
  const AcademiesUpdateAndDeleteItemView({
    super.key,
    required this.academiesItemModel,
  });

  final AcademiesItemModel academiesItemModel;

  @override
  State<AcademiesUpdateAndDeleteItemView> createState() =>
      _AcademiesUpdateAndDeleteItemViewState();
}

class _AcademiesUpdateAndDeleteItemViewState
    extends State<AcademiesUpdateAndDeleteItemView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose to prevent memory leaks
    _animationController.dispose();
    super.dispose();
  }

  bool isAnimationVisible = false;

  void _playAnimation() {
    _animationController.forward(from: 0); // Restart animation from beginning
    setState(() {
      isAnimationVisible = true; // Show animation
      // Wait for the UI to rebuild, then scroll to the end
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

  TextEditingController titleController = TextEditingController();
  TextEditingController trainerNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String imagePath = '';

  @override
  void initState() {
    titleController.text = widget.academiesItemModel.title;
    priceController.text = widget.academiesItemModel.price;
    trainerNameController.text = widget.academiesItemModel.trainerName;
    descriptionController.text = widget.academiesItemModel.description;
    imagePath = widget.academiesItemModel.activityImage;
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
        imagePath = _imageFile!.path;
      });
    }
  }

  bool isShowValidationErrorMessages = false;

  bool _validateImage(File? image) {
    if (image == null && imagePath.isEmpty) {
      isShowValidationErrorMessages = true;
      setState(() {});
      return false;
    }
    return true;
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
          title: S.of(context).UpdateDailyGame,
        ),
      ),
      body: BlocBuilder<AcademiesCubit, AcademiesState>(
        builder: (context, state) {
          var cubit = context.read<AcademiesCubit>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: _scrollController,
                children: [
                  SizedBox(height: 20.h),
                  //------mobile design
                  Text(
                    S.of(context).TitleOfGame,
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                    ),
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
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                    ),
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
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                    ),
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
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                    ),
                  ),
                  CustomTextFormField(
                    maxLines: 5,
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
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _buildCircularImage(),
                  ),
                  if (isShowValidationErrorMessages)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 10),
                      child: Text(
                        S.of(context).PleaseAddDailyGamesItemImage,
                        style: TextStyle(
                          fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red[900],
                        ),
                      ),
                    ),
                  SizedBox(height: 25.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            cubit.removeExistingItem(
                              activity:
                                  cubit.mapBetweenCategoriesAndActivities.values
                                      .toList()[cubit
                                      .currentSelectedCategoryIndex][cubit
                                      .currentSelectedItemIndex],
                            );
                            AcademiesItemModel? tmpItem =
                                widget.academiesItemModel;
                            Timer deletionTimer = Timer(
                              Duration(seconds: 4),
                              () {
                                tmpItem = null;
                              },
                            );
                            showSnackBar(
                              duration: 3,
                              backgroundColor: Colors.amber,
                              context: context,
                              textColor: Colors.brown[800],
                              message: S.of(context).DeletedSuccessfully,
                              snackBarAction: SnackBarAction(
                                textColor: Colors.brown[800],
                                label: S.of(context).Undo,
                                onPressed: () {
                                  deletionTimer.cancel();
                                  cubit.addNewItem(newActivity: tmpItem!);
                                },
                              ),
                            );
                            Navigator.pop(context);
                          },
                          text: S.of(context).Delete,
                          width: MediaQuery.of(context).size.width,
                          tabletLayout: GlobalData().isTabletLayout,
                          backGroundColor: Colors.redAccent.shade200,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            bool validateTextForm =
                                _formKey.currentState!.validate();
                            bool validateImageForm = _validateImage(_imageFile);
                            if (validateTextForm && validateImageForm) {
                              cubit.updateDailyActivityItem(
                                title: titleController.text,
                                description: descriptionController.text,
                                trainerName: trainerNameController.text,
                                activityImage: imagePath,
                                price: priceController.text,
                              );
                              FocusScope.of(context).unfocus();
                              _playAnimation();
                            }
                          },
                          text: S.of(context).hefz,
                          width: MediaQuery.of(context).size.width,
                          tabletLayout: GlobalData().isTabletLayout,
                        ),
                      ),
                    ],
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

  Widget _buildCircularImage() {
    if (imagePath.startsWith('assets/')) {
      return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: GlobalData().isTabletLayout ? 250.h : 150.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(imagePath),
          ),
        ),
      );
    } else if (File(imagePath).existsSync()) {
      return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: GlobalData().isTabletLayout ? 250.h : 150.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: FileImage(File(imagePath)),
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
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
