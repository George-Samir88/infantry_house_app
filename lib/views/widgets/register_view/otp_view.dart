import 'package:flutter/material.dart';

import 'otp_view_body.dart';

class OtpView extends StatelessWidget {
  const OtpView({super.key,});


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white, // Coffee brown background
        body: OtpViewBody(),
      ),
    );
  }
}
