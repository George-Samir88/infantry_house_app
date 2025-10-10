import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import '../../../generated/l10n.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_text_form_field.dart';
import '../menu_view/manager/user_data_cubit.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserDataCubit>();
    final loc = S.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBarEditingView(
          onPressed: () => Navigator.pop(context),
          title: S.of(context).ChangePassword,
        ),
      ),
      body: Stack(
        children: [
          // 🔹 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFECE0DC), Color(0xFFF5F5F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          BlocConsumer<UserDataCubit, UserDataState>(
            listener: (context, state) {
              if (state is ChangePasswordError) {
                showSnackBar(
                  context: context,
                  message: state.error,
                  backgroundColor: Colors.redAccent,
                );
              } else if (state is ChangePasswordSuccess) {
                showSnackBar(
                  context: context,
                  message: loc.PasswordUpdatedSuccessfully,
                  backgroundColor: Colors.green,
                );
                _newPasswordController.clear();
                _confirmPasswordController.clear();
                _oldPasswordController.clear();
                FocusScope.of(context).unfocus();
              } else if (state is NoInternetConnectionState) {
                showSnackBar(
                  context: context,
                  message: state.message,
                  backgroundColor: Colors.yellow[800],
                );
              }
            },
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  // 🔹 Form
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            FadeInUp(
                              child: _buildPasswordField(
                                controller: _oldPasswordController,
                                label: loc.OldPassword,
                                visible: cubit.oldPasswordVisible,
                                onVisibilityChanged:
                                    () => cubit.toggleOldPasswordVisibility(),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            FadeInUp(
                              delay: const Duration(milliseconds: 100),
                              child: _buildPasswordField(
                                controller: _newPasswordController,
                                label: loc.NewPassword,
                                visible: cubit.newPasswordVisible,
                                onVisibilityChanged:
                                    cubit.toggleNewPasswordVisibility,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            FadeInUp(
                              delay: const Duration(milliseconds: 200),
                              child: _buildPasswordField(
                                controller: _confirmPasswordController,
                                label: loc.ConfirmPassword,
                                visible: cubit.confirmPasswordVisible,
                                onVisibilityChanged:
                                    cubit.toggleConfirmPasswordVisibility,
                                validator: (value) {
                                  if (value != _newPasswordController.text) {
                                    return loc.PasswordsDoNotMatch;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 28.h),
                            state is ChangePasswordLoading
                                ? const AppLoader()
                                : FadeInUp(
                                  delay: const Duration(milliseconds: 300),
                                  child: CustomElevatedButton(
                                    onPressed: () async {
                                      final form = _formKey.currentState!;
                                      final cubit =
                                          context.read<UserDataCubit>();
                                      if (form.validate()) {
                                        if (await cubit
                                            .hasInternetConnection()) {
                                          cubit.changePassword(
                                            oldPassword:
                                                _oldPasswordController.text
                                                    .trim(),
                                            newPassword:
                                                _newPasswordController.text
                                                    .trim(),
                                          );
                                        }
                                      }
                                    },
                                    text: S.of(context).UpdatePassword,
                                    width: double.infinity,
                                    backGroundColor: const Color(0xFF6D3A2D),
                                    fontSize: 16.sp,
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable password field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool visible,
    required VoidCallback onVisibilityChanged,
    FormFieldValidator<String>? validator,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: CustomTextFormField(
          textEditingController: controller,
          hintText: label,
          textInputType: TextInputType.visiblePassword,
          obscureText: !visible,
          suffixIcon: IconButton(
            onPressed: onVisibilityChanged,
            icon: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: Colors.brown[600],
            ),
          ),
          validator:
              validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).ThisFieldIsRequired;
                }
                return null;
              },
        ),
      ),
    );
  }
}
