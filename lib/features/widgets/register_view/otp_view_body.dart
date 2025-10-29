import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_snackBar.dart';
import '../login_view/login_view.dart';
import 'manager/register_cubit.dart';

class OtpViewBody extends StatefulWidget {
  const OtpViewBody({super.key, required this.email});

  final String email;

  @override
  State<OtpViewBody> createState() => _OtpViewBodyState();
}

class _OtpViewBodyState extends State<OtpViewBody> {
  int _cooldown = 60; // ⏳ وقت الانتظار بالثواني
  Timer? _timer;

  void _startCooldown() {
    setState(() {
      _cooldown = 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _cooldown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterResendVerificationEmail) {
          showSnackBar(
            context: context,
            message: "تم إرسال رابط التفعيل إلى ${widget.email}",
            backgroundColor: Colors.green,
          );
          _startCooldown(); // 🕒 ابدأ العد بعد الإرسال
        } else if (state is RegisterFailure) {
          showSnackBar(
            context: context,
            message: state.error,
            backgroundColor: Colors.red,
          );
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 25.h),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: const Color(0xFF6D3A2D)),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 150.h,
                  scale: 0.8,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(color: Color(0xFF6D3A2D)),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(80),
                        ),
                      ),
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        children: [
                          SizedBox(height: 50.h),
                          Text(
                            S.of(context).ActivationLinkSent,
                            style: TextStyle(
                              color: const Color(0xFF6D3A2D),
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Text(
                            '${S.of(context).ActivationLinkSentToYourEmail} "${widget.email.toString()}" ${S.of(context).PleaseCheckYourInboxAndClickTheLinkToActivateYourAccount}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              wordSpacing: 1,
                            ),
                          ),
                          // SizedBox(height: 40.h),
                          // CustomOtpFields(),
                          SizedBox(height: 50.h),
                          Row(
                            children: [
                              Expanded(
                                child: CustomElevatedButton(
                                  onPressed:
                                      (_cooldown == 0 &&
                                              state is! RegisterLoading)
                                          ? () {
                                            context
                                                .read<RegisterCubit>()
                                                .resendVerificationEmail();
                                          }
                                          : null, // 🔒 الزر يتعطل لو في Cooldown
                                  text:
                                      _cooldown > 0
                                          ? "${S.of(context).ResendCoolDown} $_cooldown ${S.of(context).Seconds}"
                                          : S.of(context).ResendActivation,
                                  backGroundColor: Colors.grey.shade100,
                                  textColor: const Color(0xFF6D3A2D),
                                ),
                              ),
                              SizedBox(width: 5.h),
                              Expanded(
                                child: CustomElevatedButton(
                                  onPressed: () {
                                    showSnackBar(
                                      context: context,
                                      snackBarAction: SnackBarAction(
                                        label: '',
                                        onPressed: () {},
                                      ),
                                      message:
                                          S.of(context).LoggedInSuccessfully,
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginView(),
                                      ),
                                    );
                                  },
                                  text: S.of(context).GoToLogin,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
