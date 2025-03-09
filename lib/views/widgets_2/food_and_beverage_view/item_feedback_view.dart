import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../../generated/l10n.dart';
import '../../../../global_variables.dart';
import '../../../../utils/custom_elevated_button.dart';
import '../../../../utils/custom_appbar_editing_view.dart';

class ItemFeedBackView extends StatefulWidget {
  const ItemFeedBackView({super.key});

  @override
  State<ItemFeedBackView> createState() => _ItemFeedBackViewState();
}

class _ItemFeedBackViewState extends State<ItemFeedBackView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),

                ///phone number section
                Text(
                  S.of(context).PhoneNumber,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                  ),
                ),
                TextFormField(
                  controller: phoneNumberController,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                  ),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
                    ),
                    hintText: S.of(context).EnterYourPhoneNumber,
                    filled: true,
                    hintStyle: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                      color: Colors.grey,
                    ),
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).PleaseEnterYourPhoneNumber;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8.h),

                ///check image section
                Text(
                  S.of(context).SortElcheck,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                  ),
                ),
                SizedBox(height: 8.h),

                ///validation error message of image
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: GlobalData().isTabletLayout ? 250.h : 150.h,
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
                    padding: const EdgeInsets.only(top: 8.0, right: 10),
                    child: Text(
                      S.of(context).MnFdlkD5lSortElcheck,
                      style: TextStyle(
                        fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                SizedBox(height: 8.h),

                ///choice chip section
                Text(
                  S.of(context).ShareYourFeedback,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children:
                      complaints.map((complaint) {
                        return ChoiceChip(
                          label: Text(
                            complaint,
                            style: TextStyle(
                              fontSize:
                                  GlobalData().isTabletLayout ? 8.sp : 14.sp,
                              color:
                                  selectedComplaints.contains(complaint)
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          selected: selectedComplaints.contains(complaint),
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
                    padding: const EdgeInsets.only(top: 8.0, right: 10),
                    child: Text(
                      S
                          .of(context)
                          .PleaseSelectAtLeastOneOptionBeforeSubmitting,
                      style: TextStyle(
                        fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.red[900],
                      ),
                    ),
                  ),
                SizedBox(height: 8.h),

                ///complaint section (optional)
                Text(
                  S.of(context).AnyComments,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 10.sp : 20.sp,
                  ),
                ),
                TextField(
                  controller: complaintController,
                  style: TextStyle(
                    fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                  ),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    errorStyle: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
                    ),
                    hintText: S.of(context).Ad5lMola7zat,
                    filled: true,
                    hintStyle: TextStyle(
                      fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp,
                      color: Colors.grey,
                    ),
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 25.h),

                ///send button
                CustomElevatedButton(
                  onPressed: () {
                    bool validateTextForm = _formKey.currentState!.validate();
                    bool validateImageForm = _validateImage(_imageFile);
                    validateChoiceChipList();
                    if (validateTextForm && validateImageForm) {
                      FocusScope.of(context).unfocus();
                      selectedComplaints =[];
                      phoneNumberController.clear();
                      _imageFile = null;
                      _playAnimation();
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
                      child: Container(
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
        ),
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
