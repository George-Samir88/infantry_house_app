import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/utils/custom_elevated_button.dart';
import 'package:infantry_house_app/utils/custom_snackBar.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';
import 'package:infantry_house_app/views/widgets/register_view/manager/register_cubit.dart';

import '../../../generated/l10n.dart';
import 'otp_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isPasswordVisible = false;

  void _register(BuildContext blocContext) {
    if (_formKey.currentState!.validate()) {
      blocContext.read<RegisterCubit>().registerUser(
        fullName: _userNameController.text,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        phone: _phoneController.text.trim(),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: Builder(
        builder: (context) {
          return BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                final cubit = context.read<RegisterCubit>();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => BlocProvider.value(
                          value: cubit,
                          child: OtpView(email: _emailController.text),
                        ),
                  ),
                );
              } else if (state is RegisterFailure) {
                showSnackBar(
                  context: context,
                  message: state.error,
                  backgroundColor: Colors.red,
                );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Scaffold(
                  backgroundColor: const Color(0xFF6D3A2D),
                  // Coffee brown background
                  body: CustomScrollView(
                    slivers: [
                      // Fixed top section
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          height: size.height * 0.3,
                          decoration: BoxDecoration(
                            color: Color(0xFF6D3A2D),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40.r),
                              bottomRight: Radius.circular(40.r),
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 150.h,
                            ),
                          ),
                        ),
                      ),

                      // Scrollable form section
                      SliverFillRemaining(
                        hasScrollBody: true,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 30.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.r),
                              topRight: Radius.circular(40.r),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Welcome back text
                                  Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          S.of(context).CreateAnAccount,
                                          style: TextStyle(
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6D3A2D),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${S.of(context).AlreadyHaveAnAccount} ',
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                S.of(context).Login,
                                                style: TextStyle(
                                                  color: Color(0xFF6D3A2D),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  // user name field
                                  Text(
                                    S.of(context).UserName,
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextFormField(
                                    textEditingController: _userNameController,
                                    textInputType: TextInputType.text,
                                    hintText: S.of(context).EnterYourUserName,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return S
                                            .of(context)
                                            .PleaseEnterYourUserName;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20.h),

                                  // phone field
                                  Text(
                                    S.of(context).PhoneNumber,
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextFormField(
                                    textEditingController: _phoneController,
                                    textInputType: TextInputType.phone,
                                    hintText: S.of(context).EnterYourPhoneNumber,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return S
                                            .of(context)
                                            .PleaseEnterYourPhoneNumber;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20.h),

                                  // user name field
                                  Text(
                                    S.of(context).Email,
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextFormField(
                                    textEditingController: _emailController,
                                    textInputType: TextInputType.emailAddress,
                                    hintText: S.of(context).EnterYourEmail,
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
                                  SizedBox(height: 20.h),

                                  // Password field
                                  Text(
                                    S.of(context).Password,
                                    style: TextStyle(fontSize: 20.sp),
                                  ),
                                  SizedBox(height: 8.h),
                                  CustomTextFormField(
                                    textEditingController: _passwordController,
                                    obscureText: !_isPasswordVisible,
                                    maxLines: 1,
                                    textInputType: TextInputType.text,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        size: 20.r,
                                        _isPasswordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible = !_isPasswordVisible;
                                        });
                                      },
                                    ),
                                    hintText: S.of(context).EnterYourPassword,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return S
                                            .of(context)
                                            .PleaseEnterYourPassword;
                                      }
                                      if (value.length < 6) {
                                        return S
                                            .of(context)
                                            .PasswordMustBeAtLeast6CharactersLong;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20.h),

                                  // Login button
                                  state is RegisterLoading
                                      ? Center(
                                        child: CircularProgressIndicator(
                                          color: const Color(0xFF6D3A2D),
                                          strokeWidth: 3,
                                        ),
                                      )
                                      : CustomElevatedButton(
                                        onPressed: (){
                                          _register(context);
                                        },
                                        text: S.of(context).Register,
                                        width: MediaQuery.of(context).size.width,
                                      ),
                                  SizedBox(height: 20.h),

                                  // OR section
                                  Center(
                                    child: Text(
                                      S.of(context).OR,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),

                                  // Social login buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.email,
                                          color: Colors.red,
                                          size: 18.r,
                                        ),
                                        label: Text(
                                          'Gmail',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      ElevatedButton.icon(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.facebook,
                                          color: Colors.blue,
                                          size: 18.r,
                                        ),
                                        label: Text(
                                          'Facebook',
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
