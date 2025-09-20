import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infantry_house_app/models/menu_item_model.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/department_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_snackBar.dart';

class UpdateExistingItemTemplateView extends StatefulWidget {
  const UpdateExistingItemTemplateView({
    super.key,
    required this.buttonTitle,
    required this.menuItemModel,
    required this.listIndex,
    required this.screenName,
  });

  final String screenName;
  final String buttonTitle;
  final MenuItemModel menuItemModel;
  final int listIndex;

  @override
  State<UpdateExistingItemTemplateView> createState() =>
      _UpdateExistingItemTemplateViewState();
}

class _UpdateExistingItemTemplateViewState
    extends State<UpdateExistingItemTemplateView>
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
    titleController = TextEditingController(text: widget.menuItemModel.title);
    priceController = TextEditingController(text: widget.menuItemModel.price);
    _imageFile = File(widget.menuItemModel.image);
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

  Widget _buildCircularImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: GlobalData().isTabletLayout ? 250.h : 150.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child:
            _imageFile != null
                ? Image.asset(imagePath, fit: BoxFit.cover)
                : Center(
                  child: Text(
                    S.of(context).Ad5lSortElsnf,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
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
        ),
        child: Image.file(File(imagePath), fit: BoxFit.cover),
      );
    } else if (File(imagePath).existsSync()) {
      return CircleAvatar(
        radius: 30.r,
        backgroundColor: Colors.white, // Prevents image cropping
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.r),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: 60.r,
            height: 60.r,
          ),
        ),
      );
    }
    return Icon(Icons.broken_image, size: 40.r, color: Colors.grey);
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
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
      body: BlocBuilder<DepartmentCubit, DepartmentState>(
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
                  if (!GlobalData().isTabletLayout)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).EsmElsanf,
                          style: TextStyle(
                            fontSize:
                                GlobalData().isTabletLayout ? 10.sp : 20.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          textEditingController: titleController,
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
                          style: TextStyle(
                            fontSize:
                                GlobalData().isTabletLayout ? 10.sp : 20.sp,
                          ),
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
                      ],
                    ),
                  //------tablet design
                  if (GlobalData().isTabletLayout)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).EsmElsanf,
                                style: TextStyle(
                                  fontSize:
                                      GlobalData().isTabletLayout
                                          ? 10.sp
                                          : 20.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              CustomTextFormField(
                                textEditingController: titleController,
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
                                style: TextStyle(
                                  fontSize:
                                      GlobalData().isTabletLayout
                                          ? 10.sp
                                          : 20.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 8.h),
                  Text(
                    S.of(context).SoraElsnf,
                    style: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _buildCircularImage(_imageFile!.path),
                  ),
                  if (isShowValidationErrorMessages)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 10),
                      child: Text(
                        S.of(context).MnFdlkD5lSortElsnf,
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
                            // MenuItemModel? deletedMenuItem =
                            //     MenuItemModel(title: "222222222", image: "", price: "4", averageRating: 2);
                            Timer? deletionTimer;
                            cubit.removeItem(
                              screenName: widget.screenName,
                              buttonTitle: widget.buttonTitle,
                              indexOfItemInList: widget.listIndex,
                            );
                            // deletionTimer = Timer(Duration(seconds: 3), () {
                            //   deletedMenuItem = null;
                            // });
                            Navigator.pop(context);
                            showSnackBar(
                              backgroundColor: Colors.amber,
                              textColor: Colors.brown[800],
                              duration: 3,
                              context: context,
                              snackBarAction: SnackBarAction(
                                label: S.of(context).Undo,
                                textColor: Colors.brown[800],
                                onPressed: () {
                                  deletionTimer?.cancel();
                                  // if (deletedMenuItem != null) {
                                  //   cubit.addItem(
                                  //     screenName: widget.screenName,
                                  //     menuItemModel: deletedMenuItem!,
                                  //     buttonTitle: widget.buttonTitle,
                                  //   );
                                  // }
                                },
                              ),
                              message: S.of(context).DeletedSuccessfully,
                            );
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
                              cubit.updateItem(
                                newTitle: titleController.text,
                                newImage: _imageFile!.path,
                                newPrice: formatNumber(priceController.text),
                                buttonTitle: widget.buttonTitle,
                                listIndex: widget.listIndex,
                                screenName: widget.screenName,
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
                          height: 100,
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
