import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animate_do/animate_do.dart'; // للأنيميشن
import 'package:infantry_house_app/utils/app_loader.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';

import '../../../../generated/l10n.dart';
import '../../../utils/custom_appbar_editing_view.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_text_form_field.dart';
import '../menu_view/manager/user_data_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = context.read<UserDataCubit>().state;
    if (state is UserDataLoadedSuccess) {
      _nameController = TextEditingController(text: state.user.fullName);
      _emailController = TextEditingController(text: state.user.email);
      _phoneController = TextEditingController(text: state.user.phone);
    } else {
      _nameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave({required BuildContext context}) {
    if (_formKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      final state = context.read<UserDataCubit>().state;
      if (state is UserDataLoadedSuccess) {
        context.read<UserDataCubit>().updateUserData(
          currentUser: state.user,
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: CustomAppBarEditingView(
          onPressed: () => Navigator.pop(context),
          title: S.of(context).EditProfile,
        ),
      ),
      body: BlocConsumer<UserDataCubit, UserDataState>(
        listener: (context, state) {
          if (state is UserDataError) {
            showSnackBar(context: context, message: state.message);
          }
          if (state is UserDataLoadedSuccess) {
            showSnackBar(context: context, message: loc.UpdatedSuccessfully);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    S.of(context).UserName,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(height: 8.h),
                  FadeInDown(
                    duration: const Duration(milliseconds: 400),
                    child: CustomTextFormField(
                      textEditingController: _nameController,
                      hintText: loc.UserName,
                      textInputType: TextInputType.name,
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? loc.PleaseEnterYourUserName
                                  : null,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    S.of(context).PhoneNumber,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(height: 8.h),
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: CustomTextFormField(
                      textEditingController: _phoneController,
                      hintText: loc.PhoneNumber,
                      textInputType: TextInputType.phone,
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? loc.PleaseEnterYourPhoneNumber
                                  : null,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(S.of(context).Email, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(height: 8.h),
                  FadeInDown(
                    duration: const Duration(milliseconds: 500),
                    child: CustomTextFormField(
                      textEditingController: _emailController,
                      enabled: false,

                      hintText: loc.Email,
                      textInputType: TextInputType.emailAddress,
                      validator:
                          (value) =>
                              value!.isEmpty
                                  ? loc.PleaseEnterYourEmail
                                  : (!value.contains('@')
                                      ? loc.InvalidEmail
                                      : null),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  state is UserDataLoading
                      ? AppLoader()
                      : FadeInUp(
                        duration: const Duration(milliseconds: 700),
                        child: CustomElevatedButtonWithIcon(
                          onPressed: () {
                            _onSave(context: context);
                          },
                          label: loc.hefz,
                          icon: Icons.save,
                          width: double.infinity,
                          backGroundColor: const Color(0xFF6D3A2D),
                        ),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
