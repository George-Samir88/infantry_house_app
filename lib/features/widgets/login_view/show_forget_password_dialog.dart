import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/app_loader.dart';

import '../../../generated/l10n.dart';
import '../../../utils/custom_snackBar.dart';
import '../../../utils/custom_text_form_field.dart';
import 'manager/login_cubit.dart';

void showForgotPasswordDialog(BuildContext parentContext) {
  final TextEditingController emailResetController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSending = false;

  showGeneralDialog(
    context: parentContext,
    barrierDismissible: true,
    barrierLabel: "Forgot Password",
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(anim1.value),
        child: Opacity(
          opacity: anim1.value,
          child: BlocListener<LoginCubit, LoginState>(
            bloc: parentContext.read<LoginCubit>(),
            listener: (dialogContext, state) {
              if (state is ResetPasswordSuccess) {
                Navigator.pop(dialogContext);
                showSnackBar(
                  context: parentContext,
                  message: S.of(dialogContext).ResetLinkSentCheckYourEmail,
                  backgroundColor: Colors.green,
                );
              } else if (state is ResetPasswordFailure) {
                showSnackBar(
                  context: parentContext,
                  message: state.error,
                  backgroundColor: Colors.red,
                );
                Navigator.pop(dialogContext);
              }
            },
            child: StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  title: Text(
                    S.of(context).ForgotPassword,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  content: Form(
                    key: formKey,
                    child: CustomTextFormField(
                      textEditingController: emailResetController,
                      hintText: S.of(context).EnterYourEmail,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).PleaseEnterYourEmail;
                        }
                        // Regex for email validation
                        final emailRegex = RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailRegex.hasMatch(value)) {
                          return S.of(context).PleaseEnterAValidEmail;
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        S.of(context).Cancel,
                        style: TextStyle(color: Colors.black, fontSize: 14.sp),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6D3A2D),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() => isSending = true);
                          parentContext.read<LoginCubit>().resetPassword(
                            email: emailResetController.text.trim(),
                          );
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child:
                            isSending
                                ? SizedBox(
                                  width: 10.w,
                                  height: 10.h,
                                  child: const AppLoader(),
                                )
                                : Text(
                                  S.of(context).SendResetLink,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}
