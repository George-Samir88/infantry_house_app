import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infantry_house_app/global_variables.dart';
import 'package:infantry_house_app/utils/custom_elevated_button.dart';
import 'package:infantry_house_app/utils/custom_text_form_field.dart';

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
  bool _isPasswordVisible = false;

  void _register() {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, proceed with login logic

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OtpView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF6D3A2D), // Coffee brown background
        body: CustomScrollView(
          slivers: [
            // Fixed top section
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                height: size.height * 0.3,
                decoration: const BoxDecoration(
                  color: Color(0xFF6D3A2D),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Image.asset('assets/images/logo.png', height: 150.h),
                ),
              ),
            ),

            // Scrollable form section
            SliverFillRemaining(
              hasScrollBody: true,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
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
                                  fontSize:
                                      GlobalData().isTabletLayout
                                          ? 16.sp
                                          : 28.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6D3A2D),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${S.of(context).AlreadyHaveAnAccount} ',
                                    style: TextStyle(
                                      fontSize:
                                          GlobalData().isTabletLayout
                                              ? 10.sp
                                              : 14.sp,
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
                                        fontSize:
                                            GlobalData().isTabletLayout
                                                ? 10.sp
                                                : 14.sp,
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

                        // Email field
                        Text(
                          S.of(context).UserName,
                          style: TextStyle(
                            fontSize:
                                GlobalData().isTabletLayout ? 10.sp : 20.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          textEditingController: _userNameController,
                          textInputType: TextInputType.text,
                          hintText: S.of(context).EnterYourUserName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).PleaseEnterYourUserName;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Email field
                        Text(
                          S.of(context).PhoneNumber,
                          style: TextStyle(
                            fontSize:
                                GlobalData().isTabletLayout ? 10.sp : 20.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          textEditingController: _phoneController,
                          textInputType: TextInputType.phone,
                          hintText: S.of(context).EnterYourPhoneNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.of(context).PleaseEnterYourPhoneNumber;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Password field
                        Text(
                          S.of(context).Password,
                          style: TextStyle(
                            fontSize:
                                GlobalData().isTabletLayout ? 10.sp : 20.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        CustomTextFormField(
                          textEditingController: _passwordController,
                          obscureText: !_isPasswordVisible,
                          maxLines: 1,
                          textInputType: TextInputType.text,
                          suffixIcon: IconButton(
                            icon: Icon(
                              size: GlobalData().isTabletLayout ? 26.r : 20.r,
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
                              return S.of(context).PleaseEnterYourPassword;
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
                        CustomElevatedButton(
                          onPressed: _register,
                          text: S.of(context).Register,
                          width: MediaQuery.of(context).size.width,
                          //-------------------------------------------------------------------------------------
                          tabletLayout: GlobalData().isTabletLayout,
                        ),
                        SizedBox(height: 20.h),

                        // OR section
                        Center(
                          child: Text(
                            S.of(context).OR,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize:
                                  GlobalData().isTabletLayout ? 10.sp : 16.sp,
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
                                side: const BorderSide(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 10),
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
                                side: const BorderSide(color: Colors.grey),
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
  }
}
