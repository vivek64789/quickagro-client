import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class OTPVerification extends StatefulWidget {
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.3),
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0),
              primaryColor.withOpacity(0),
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.3),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        width: width,
        height: height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      FeatherIcons.chevronLeft,
                      color: textColor,
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.25,
              ),
              Text(
                "Enter the 4-digit number sent to",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: textColor,
                ),
              ),
              Text(
                "+1234567890",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Provider.of<ThemeProvider>(context).isDarkTheme
                          ? textColor.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(borderRadius)),
                child: OTPTextField(
                  length: 5,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: width * 0.15,
                  style: TextStyle(
                    fontSize: 17.sp,
                    color: textColor,
                  ),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onCompleted: (pin) {
                    Get.to(() => Home());
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Get.offAll(() => Home());
                  },
                  style: TextButton.styleFrom(
                    primary: Colors.red[900],
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: Text(
                    "Verify and proceed",
                    style: TextStyle(
                      color: white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Request new code in ",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textColor,
                    ),
                  ),
                  Text(
                    "00:20",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
