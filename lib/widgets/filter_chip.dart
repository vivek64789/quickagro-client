import 'package:flutter/material.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterChipButton extends StatelessWidget {
  final String title;
  final bool enabled;
  final Function onTap;

  FilterChipButton({
    required this.title,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;
    return Padding(
      padding: EdgeInsets.only(right: width * 0.02),
      child: TextButton(
        onPressed: () {
          onTap();
        },
        style: TextButton.styleFrom(
          backgroundColor: enabled ? primaryColor : scaffoldColor,
          padding: EdgeInsets.all(width * 0.025),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color:
                  enabled ? Colors.transparent : Colors.grey.withOpacity(0.4),
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: enabled ? white : textColor.withOpacity(0.7),
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
