import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/l10n.dart';
import '../../../global_variables.dart';
import '../../../utils/custom_elevated_button.dart';
import '../../../utils/custom_snackBar.dart';
import '../home_view/home_view.dart';
import 'custom_otp_fields.dart';

class OtpViewBody extends StatelessWidget {
  const OtpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
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
              height: 150,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        S.of(context).VerificationCodeSent,
                        style: TextStyle(
                          color: const Color(0xFF6D3A2D),
                          fontSize: GlobalData().isTabletLayout ? 14.sp : 24.sp,
                          fontWeight: FontWeight.bold,
                          wordSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        '${S.of(context).WeTextedYouA5DigitCodeTo} 01012345678 ${S.of(context).PleaseEnterItBelow}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: GlobalData().isTabletLayout ? 10.sp : 14.sp,
                          fontWeight: FontWeight.w600,
                          wordSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      CustomOtpFields(),
                      SizedBox(height: 50.h),
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: () {},
                              text: S.of(context).Resend,
                              backGroundColor: Colors.grey.shade100,
                              textColor: const Color(0xFF6D3A2D),
                              tabletLayout: GlobalData().isTabletLayout,
                            ),
                          ),
                          SizedBox(width: 20.h),
                          Expanded(
                            child: CustomElevatedButton(
                              onPressed: () {
                                showSnackBar(
                                  context: context,
                                  snackBarAction: SnackBarAction(
                                    label: '',
                                    onPressed: () {},
                                  ),
                                  message: S.of(context).LoggedInSuccessfully,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeView(),
                                  ),
                                );
                              },
                              text: S.of(context).Confirm,
                              tabletLayout: GlobalData().isTabletLayout,
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
  }
}
