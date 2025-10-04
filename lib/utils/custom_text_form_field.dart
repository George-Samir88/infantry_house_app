import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    this.enabled,
  });

  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType textInputType;
  final int? minLines;
  final bool? obscureText;
  final int? maxLines;
  final Widget? suffixIcon;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      obscureText: obscureText ?? false,
      enabled: enabled ?? true,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(fontSize: 14.sp),
      keyboardType: textInputType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        errorStyle: TextStyle(fontSize: 10.sp),
        hintText: hintText,
        filled: true,
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
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
