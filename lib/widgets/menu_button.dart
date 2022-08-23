import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final String title;
  final bool autoClose;

  MenuButton(this.onTap, this.icon, this.title, {this.autoClose = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.015),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.black,
          padding: EdgeInsets.symmetric(
            vertical: height * 0.01,
            horizontal: width * 0.01,
          ),
        ),
        onPressed: () {
          if (autoClose) {
            Get.back();
          }
          onTap();
        },
        child: Row(
          children: [
            Icon(
              icon,
              color: white,
            ),
            SizedBox(
              width: width * 0.04,
            ),
            Text(
              title,
              style: TextStyle(
                color: white,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
