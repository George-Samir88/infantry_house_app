import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infantry_house_app/models/complaints_model.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:infantry_house_app/utils/map_firebase_error.dart';
import 'package:infantry_house_app/views/widgets/general_template/manager/rating_cubit.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../generated/l10n.dart';
import '../../../../global_variables.dart';
import '../../../../utils/custom_elevated_button.dart';
import '../../../../utils/custom_appbar_editing_view.dart';

class ItemFeedBackView extends StatefulWidget {
  const ItemFeedBackView({super.key, required this.itemId});

  final String itemId;

  @override
  State<ItemFeedBackView> createState() => _ItemFeedBackViewState();
}

class _ItemFeedBackViewState extends State<ItemFeedBackView>
    with SingleTickerProviderStateMixin {
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOutQuad,
        );
      });

      isAnimationVisible = true; // Show animation
    });
    _animationController.forward().whenComplete(() {
      setState(() {
        isAnimationVisible = false;
      });
    });
  }

  List<String> complaints = [];

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
    complaints = [
      S.of(context).FewQuantity,
      S.of(context).HighPrice,
      S.of(context).PreparationTime,
      S.of(context).Taste,
      S.of(context).Other,
    ];
    super.didChangeDependencies();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _imageFile;

  Future<void> _pickImage() async {
    FocusScope.of(context).unfocus();
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        isShowValidationErrorMessages = false;
        _imageFile = File(pickedFile.path);
      });
    }
  }

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController complaintController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isShowValidationErrorMessages = false;

  List<String> selectedComplaints = [];

  bool _validateImage(File? image) {
    if (image == null) {
      isShowValidationErrorMessages = true;
      setState(() {});
      return false;
    }
    return true;
  }

  bool choiceChipEmpty = false;

  void validateChoiceChipList() {
    if (selectedComplaints.isEmpty) {
      setState(() {
        choiceChipEmpty = true; // Show error message
      });
    } else {
      setState(() {
        choiceChipEmpty = false; // Clear error message
      });
      // Proceed with sending data
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatingCubit, RatingState>(
      listener: (context, state) {
        if (state is RatingComplaintsFailure) {
          showSnackBar(
            context: context,
            message: localizeFirestoreError(
              context: context,
              code: state.failure,
            ),
            backgroundColor: Colors.red,
          );
        }
        if (state is RatingComplaintsSuccess) {
          _playAnimation();
        }
      },
      builder: (context, state) {
        var cubit = context.read<RatingCubit>();
        return Scaffold(
          backgroundColor: Color(0xffF5F5F5),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.h),
            child: CustomAppBarEditingView(
              onPressed: () {
                Navigator.pop(context);
              },
              title: S.of(context).Ra2ykYhmna,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: ListView(
              controller: scrollController,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),

                      ///phone number section
                      Text(
                        S.of(context).PhoneNumber,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      CustomTextFormField(
                        textEditingController: phoneNumberController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).PleaseEnterYourPhoneNumber;
                          }
                          return null;
                        },
                        hintText: S.of(context).EnterYourPhoneNumber,
                        textInputType: TextInputType.phone,
                      ),
                      SizedBox(height: 8.h),

                      ///check image section
                      Text(
                        S.of(context).SortElcheck,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(height: 8.h),

                      ///validation error message of image
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          height: GlobalData().isTabletLayout ? 220.h : 150.h,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              _imageFile != null
                                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                                  : Center(
                                    child: Text(
                                      S.of(context).Ad5lSortElcheck,
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
                            S.of(context).MnFdlkD5lSortElcheck,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      SizedBox(height: 8.h),

                      ///choice chip section
                      Text(
                        S.of(context).ShareYourFeedback,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      Wrap(
                        spacing: 8.0.w,
                        children:
                            complaints.map((complaint) {
                              return ChoiceChip(
                                label: Text(
                                  complaint,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color:
                                        selectedComplaints.contains(complaint)
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                                selected: selectedComplaints.contains(
                                  complaint,
                                ),
                                checkmarkColor: Colors.white,
                                selectedColor: Colors.brown[400],
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      selectedComplaints.add(complaint);
                                    } else {
                                      selectedComplaints.remove(complaint);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),

                      ///choice chip validation error message
                      if (choiceChipEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0.h, right: 10.w),
                          child: Text(
                            S
                                .of(context)
                                .PleaseSelectAtLeastOneOptionBeforeSubmitting,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      SizedBox(height: 8.h),

                      ///complaint section (optional)
                      Text(
                        S.of(context).AnyComments,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      CustomTextFormField(
                        textEditingController: complaintController,
                        hintText: S.of(context).Ad5lMola7zat,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(height: 25.h),

                      ///send button
                      state is RatingComplaintsLoading
                          ? AppLoader()
                          : CustomElevatedButton(
                            onPressed: () async {
                              bool validateTextForm =
                                  _formKey.currentState!.validate();
                              bool validateImageForm = _validateImage(
                                _imageFile,
                              );
                              validateChoiceChipList();
                              if (validateTextForm && validateImageForm) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                final cachedUser = prefs.getString(
                                  'user_cache',
                                );
                                final currentUser = jsonDecode(cachedUser!);

                                ComplaintModel complaintModel = ComplaintModel(
                                  userId: currentUser["uid"],
                                  userName: currentUser["fullName"],
                                  complaints: selectedComplaints,
                                  createdAt: DateTime.now(),
                                  imageUrl: _imageFile?.path,
                                  note: complaintController.text,
                                );
                                cubit.submitComplaint(
                                  itemId: widget.itemId,
                                  complaint: complaintModel,
                                );
                                if (!context.mounted) return;
                                FocusScope.of(context).unfocus();
                                selectedComplaints = [];
                                phoneNumberController.clear();
                                _imageFile = null;
                                complaintController.clear();
                              }
                            },
                            text: S.of(context).Submit,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
