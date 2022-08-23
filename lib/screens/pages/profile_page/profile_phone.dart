import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool _loading = false;
String _phone = "";
TextEditingController _phoneController = TextEditingController();

class ProfilePhone extends StatefulWidget {
  const ProfilePhone();

  @override
  _ProfilePhoneState createState() => _ProfilePhoneState();
}

class _ProfilePhoneState extends State<ProfilePhone> {
  @override
  void initState() {
    _phoneController.text =
        Provider.of<UserProfileProvider>(context, listen: false).phone;
    _phone = _phoneController.text;
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
                    "Phone Number",
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
                "Phone Number",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor.withOpacity(0.7),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (text) {
                  _phone = text;
                },
                decoration: InputDecoration(
                  fillColor: textColor.withOpacity(0.1),
                  filled: true,
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
                    ? Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: () async {
                          setState(() {
                            _loading = true;
                          });
                          await Provider.of<UserProfileProvider>(context,
                                  listen: false)
                              .updatePhoneNumber(_phone);
                          setState(() {
                            _loading = false;
                          });
                          Get.back();
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
                          "Save",
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
