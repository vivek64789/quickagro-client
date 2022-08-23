import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String animPath;
  final String title;
  final String description;
  final String actionTitle;
  final Function onTapAction;
  final bool showActionButton;

  ErrorMessageWidget({
    required this.animPath,
    required this.title,
    required this.description,
    required this.actionTitle,
    required this.onTapAction,
    this.showActionButton = true,
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.5,
            child: Lottie.asset(
              animPath,
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          SizedBox(
            width: width * 0.6,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 12.sp, color: textColor.withOpacity(0.7)),
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          !showActionButton
              ? SizedBox.shrink()
              : SizedBox(
                  width: width * 0.5,
                  child: TextButton(
                    onPressed: () {
                      onTapAction();
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          actionTitle,
                          style: TextStyle(
                            color: white,
                            fontSize: 12.sp,
                          ),
                        ),
                        Icon(
                          FeatherIcons.chevronRight,
                          color: white,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
