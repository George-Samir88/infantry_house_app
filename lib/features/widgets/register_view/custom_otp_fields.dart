import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomOtpFields extends StatefulWidget {
  const CustomOtpFields({super.key});

  @override
  State<CustomOtpFields> createState() => _CustomOtpFieldsState();
}

class _CustomOtpFieldsState extends State<CustomOtpFields> {
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  final List<TextEditingController> _controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());
  List<bool> enabledIndex = [true, false, false, false, false];

  void setEnabledToTargetFields({required int index}) {
    setState(() {
      enabledIndex[index] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        return SizedBox(
          width: 50.w,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            enabled: enabledIndex[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Color(0xFF6D3A2D), width: 2.w),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Color(0xFF6D3A2D), width: 3.w),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey, width: 2.w),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (value.isNotEmpty && index < 4) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                });
                setEnabledToTargetFields(index: index + 1);
              }
              if (value.isNotEmpty && index == 4) {
                FocusScope.of(context).unfocus();
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
            },
          ),
        );
      }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return OtpTextField(
  //     focusedBorderColor: Color(0xFF6D3A2D),
  //     cursorColor: Color(0xFF6D3A2D),
  //     inputFormatters: [
  //       LengthLimitingTextInputFormatter(5),
  //       FilteringTextInputFormatter.digitsOnly,
  //     ],
  //     numberOfFields: 5,
  //     enabled: false,
  //     borderColor: Color(0xFF6D3A2D),
  //     //set to true to show as box or false to show as dash
  //     showFieldAsBox: true,
  //     //runs when a code is typed in
  //     onCodeChanged: (String code) {
  //       print(code);
  //       if(code.length==1){
  //         FocusScope.of(context).nextFocus();
  //       }
  //     },
  //     //runs when every textfield is filled
  //     onSubmit: (String verificationCode) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text("Verification Code" , style: TextStyle(color: Colors.white,),),
  //             content: Text('Code entered is $verificationCode', style: TextStyle(color: Colors.white,),),
  //             backgroundColor:Color(0xFF6D3A2D),
  //           );
  //         },
  //       );
  //     }, // end onSubmit
  //   );
  // }
}
