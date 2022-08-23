import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool _loading = false;

String _currentPassword = "";
String _newPassword = "";

bool _showCurrentPassword = false;
bool _showNewPassword = false;

class ProfileChangePassword extends StatefulWidget {
  const ProfileChangePassword({Key? key}) : super(key: key);

  @override
  _ProfileChangePasswordState createState() => _ProfileChangePasswordState();
}

class _ProfileChangePasswordState extends State<ProfileChangePassword> {
  @override
  void initState() {
    _currentPassword = "";
    _newPassword = "";
    _showCurrentPassword = false;
    _showNewPassword = false;
    _loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
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
                    "Change Password",
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
                "Current Password",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextField(
                obscureText: !_showCurrentPassword,
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  _currentPassword = text;
                },
                decoration: InputDecoration(
                  fillColor: textColor.withOpacity(0.1),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                    icon: Icon(
                      _showCurrentPassword
                          ? FeatherIcons.eyeOff
                          : FeatherIcons.eye,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Text(
                "New Password",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextField(
                obscureText: !_showNewPassword,
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  _newPassword = text;
                },
                decoration: InputDecoration(
                  fillColor: textColor.withOpacity(0.1),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                    icon: Icon(
                      _showNewPassword ? FeatherIcons.eyeOff : FeatherIcons.eye,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: textColor,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                width: double.infinity,
                child: _loading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : TextButton(
                        onPressed: () async {
                          if (_currentPassword.length < 6 ||
                              _newPassword.length < 6) {
                            Fluttertoast.showToast(
                              msg: "Password must have atleast 6 characters",
                              backgroundColor: primaryColor,
                            );
                            return;
                          }
                          setState(() {
                            _loading = true;
                          });
                          await Provider.of<UserProfileProvider>(context,
                                  listen: false)
                              .changePassword(_currentPassword, _newPassword);
                          setState(() {
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
                          "Change Password",
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
