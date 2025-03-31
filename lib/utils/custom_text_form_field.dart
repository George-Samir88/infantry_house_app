import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global_variables.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    this.validator,
    required this.hintText,
    required this.textInputType,
    this.minLines,
    this.maxLines,
    this.obscureText,
    this.suffixIcon,
  });

  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType textInputType;
  final int? minLines;
  final bool? obscureText;
  final int? maxLines;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: obscureText ?? false,
      minLines: minLines ?? null,
      maxLines: maxLines ?? null,
      style: TextStyle(fontSize: GlobalData().isTabletLayout ? 8.sp : 14.sp),
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon ?? null,
        errorStyle: TextStyle(
          fontSize: GlobalData().isTabletLayout ? 6.sp : 10.sp,
        ),
        hintText: hintText,
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
      validator: validator,
    );
  }
}
