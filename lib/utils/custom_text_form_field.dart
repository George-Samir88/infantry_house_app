import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.textEditingController,
    this.validator,
    this.hintText,
    required this.textInputType,
    this.maxLines,
    this.obscureText,
    this.suffixIcon,
    this.enabled,
    this.prefixIcon,
    this.label,
  });

  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType textInputType;
  final bool? obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: obscureText ?? false,
      enabled: enabled ?? true,
      maxLines: maxLines ?? 1,
      style: TextStyle(fontSize: 14.sp),
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.brown.shade300
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorStyle: TextStyle(fontSize: 10.sp),
        hintText: hintText,
        filled: true,
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
        fillColor: Colors.brown.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.brown.shade300, width: 2.w),
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),

      validator: validator,
    );
  }
}
