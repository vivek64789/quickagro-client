import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileStatistic extends StatelessWidget {
  final String value;
  final String label;

  ProfileStatistic({
    this.value = "",
    this.label = "",
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: textColor.withOpacity(0.7),
          ),
        )
      ],
    );
  }
}
