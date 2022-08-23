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

String _title = "";
String _address = "";

class ProfileAddAddress extends StatefulWidget {
  const ProfileAddAddress({Key? key}) : super(key: key);

  @override
  _ProfileAddAddressState createState() => _ProfileAddAddressState();
}

class _ProfileAddAddressState extends State<ProfileAddAddress> {
  @override
  void initState() {
    _loading = false;
    _title = "";
    _address = "";
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
            child: Column(children: [
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
                    "Add Address",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Expanded(
                  child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Text(
                    "Title",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextField(
                    onChanged: (text) {
                      _title = text;
                    },
                    decoration: InputDecoration(
                        fillColor: textColor.withOpacity(0.1),
                        filled: true,
                        hintText: "Eg. Home, Office.."),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextField(
                    onChanged: (text) {
                      _address = text;
                    },
                    maxLines: 3,
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
                    height: height * 0.04,
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
                                  .addAddress(_title, _address);
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
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                            ),
                            child: Text(
                              "Add Address",
                              style: TextStyle(
                                color: white,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                  ),
                ],
              )),
            ]),
          )),
    );
  }
}
