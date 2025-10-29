import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_snackBar.dart';

class AddNewItemTemplateView extends StatefulWidget {
  const AddNewItemTemplateView({super.key});

  @override
  State<AddNewItemTemplateView> createState() => _AddNewItemTemplateViewState();
}

class _AddNewItemTemplateViewState extends State<AddNewItemTemplateView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  bool isAnimationVisible = false;

  void _playAnimation() {
    setState(() {
      isAnimationVisible = true;
    });

    _animationController.forward(from: 0).whenComplete(() {
      setState(() {
        isAnimationVisible = false;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuad,
        );
      }
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

  TextEditingController titleArController = TextEditingController();
  TextEditingController titleEnController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionArController = TextEditingController();
  TextEditingController descriptionEnController = TextEditingController();
  bool isShowValidationErrorMessages = false;

  bool _validateImage(File? image) {
    if (image == null) {
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
          title: S.of(context).EdaftSnf,
        ),
      ),
      body: BlocConsumer<DepartmentCubit, DepartmentState>(
        listener: (context, state) {
          if (state is DepartmentCreateMenuItemSuccessState) {
            _playAnimation();
          } else if (state is DepartmentCreateMenuItemFailureState) {
            showSnackBar(
              context: context,
              message: state.failure,
              backgroundColor: Colors.redAccent,
            );
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
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                controller: scrollController,
                children: [
                  SizedBox(height: 20.h),
                  //------mobile design
                  if (!GlobalData().isTabletLayout) ...[
                    Text(
                      S.of(context).EsmElsanfInAr,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    CustomTextFormField(
                      textEditingController: titleArController,
                      textInputType: TextInputType.text,
                      hintText: S.of(context).Ad5lEsmElsnf,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).MnFdlkD5lEsmElsnf;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      S.of(context).EsmElsanfInEn,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    CustomTextFormField(
                      textEditingController: titleEnController,
                      textInputType: TextInputType.text,
                      hintText: S.of(context).Ad5lEsmElsnf,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).MnFdlkD5lEsmElsnf;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      S.of(context).S3rElsnf,
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    CustomTextFormField(
                      textEditingController: priceController,
                      textInputType: TextInputType.number,
                      hintText: S.of(context).Ad5lS3rElsnf,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).MnFdlkD5lS3rElsnf;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8.h),
                  ],
                  //------tablet design
                  if (GlobalData().isTabletLayout)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).EsmElsanfInAr,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              CustomTextFormField(
                                textEditingController: titleArController,
                                textInputType: TextInputType.text,
                                hintText: S.of(context).Ad5lEsmElsnf,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).MnFdlkD5lEsmElsnf;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                S.of(context).EsmElsanfInEn,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              CustomTextFormField(
                                textEditingController: titleEnController,
                                textInputType: TextInputType.text,
                                hintText: S.of(context).Ad5lEsmElsnf,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).MnFdlkD5lEsmElsnf;
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).S3rElsnf,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              CustomTextFormField(
                                textEditingController: priceController,
                                textInputType: TextInputType.number,
                                hintText: S.of(context).Ad5lS3rElsnf,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.of(context).MnFdlkD5lS3rElsnf;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 8.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  Text(
                    S.of(context).DescriptionAr,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  CustomTextFormField(
                    textEditingController: descriptionArController,
                    textInputType: TextInputType.text,
                    hintText: S.of(context).EnterDescription,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).PleaseEnterDescription;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).DescriptionEn,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  CustomTextFormField(
                    textEditingController: descriptionEnController,
                    textInputType: TextInputType.text,
                    hintText: S.of(context).EnterDescription,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).PleaseEnterDescription;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).SoraElsnf,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 150.h,
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
                                  S.of(context).Ad5lSortElsnf,
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
                      padding: EdgeInsets.only(top: 8.0.h, right: 10.w),
                      child: Text(
                        S.of(context).MnFdlkD5lSortElsnf,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.red[900],
                        ),
                      ),
                    ),
                  SizedBox(height: 25.h),
                  state is DepartmentCreateMenuItemLoadingState
                      ? AppLoader()
                      : CustomElevatedButton(
                        onPressed: () async {
                          if (await cubit.hasInternetConnection()) {
                            bool validateTextForm =
                                _formKey.currentState!.validate();
                            bool validateImageForm = _validateImage(_imageFile);
                            if (validateTextForm && validateImageForm) {
                              cubit.createMenuItem(
                                titleAr: titleArController.text,
                                price: priceController.text,
                                imagePath:
                                    _imageFile?.path ?? "Error in adding image",
                                descriptionAr: descriptionArController.text,
                                titleEn: titleEnController.text,
                                descriptionEn: descriptionEnController.text,
                              );
                              if (!context.mounted) return;
                              FocusScope.of(context).unfocus();
                              titleArController.clear();
                              titleEnController.clear();
                              descriptionEnController.clear();
                              priceController.clear();
                              descriptionArController.clear();
                              _imageFile = null;
                            }
                          }
                        },
                        text: S.of(context).hefz,
                        width: MediaQuery.of(context).size.width,
                        tabletLayout: GlobalData().isTabletLayout,
                      ),
                  Visibility(
                    visible: isAnimationVisible,
                    child: Container(
                      height: 100.h,
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
