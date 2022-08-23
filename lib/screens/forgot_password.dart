import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/forgot_password_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

bool _loading = false;
String _email = "";
String _code = "";
String _newPassword = "";

bool _showPassword = false;

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    super.initState();
    setState(() {
      _loading = false;
      _email = "";
    });
    Provider.of<ForgotPasswordProvider>(context, listen: false).resetForm();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var forgotPassProvider = Provider.of<ForgotPasswordProvider>(context);
    TextEditingController _controller = new TextEditingController();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        width: width,
        height: height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Forgot Password",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                forgotPassProvider.emailSent
                    ? "Enter new password."
                    : forgotPassProvider.emailSent
                        ? "Enter the verification code sent to your email ${forgotPassProvider.email}."
                        : "Enter your email to get a verification code.",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                forgotPassProvider.codeValidate
                    ? "New password"
                    : forgotPassProvider.emailSent
                        ? "Verification Code"
                        : "Email",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor,
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              forgotPassProvider.codeValidate
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (text) {
                              _newPassword = text;
                            },
                            obscureText: !_showPassword,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              fillColor: textColor.withOpacity(0.1),
                              filled: true,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                                icon: Icon(
                                  _showPassword
                                      ? FeatherIcons.eyeOff
                                      : FeatherIcons.eye,
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    )
                  : forgotPassProvider.emailSent
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                onChanged: (text) {
                                  _code = text;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  fillColor: textColor.withOpacity(0.1),
                                  filled: true,
                                ),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                onChanged: (text) {
                                  _email = text;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  fillColor: textColor.withOpacity(0.1),
                                  filled: true,
                                ),
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ],
                        ),
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                width: double.infinity,
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });
                          if (forgotPassProvider.codeValidate) {
                            await Provider.of<ForgotPasswordProvider>(context,
                                    listen: false)
                                .changePassword(_newPassword);
                            Get.back();
                          } else if (forgotPassProvider.emailSent) {
                            await Provider.of<ForgotPasswordProvider>(context,
                                    listen: false)
                                .verifyCode(_code);
                          } else {
                            await Provider.of<ForgotPasswordProvider>(context,
                                    listen: false)
                                .forgotPassword(_email);
                          }
                          setState(() {
                            _controller.clear();
                            _loading = false;
                          });
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
                          forgotPassProvider.codeValidate
                              ? "Change Password"
                              : forgotPassProvider.emailSent
                                  ? "Verify"
                                  : "Send",
                          style: TextStyle(
                            color: white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
