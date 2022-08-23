import 'package:flutter/material.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/get_responsive.dart';
import 'package:quickagro/utils/size.dart';

class SmallSquareButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final Color color;

  SmallSquareButton(this.icon, this.onTap,
      {this.color = const Color(0xFFDC2E45)});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      borderRadius: BorderRadius.circular(
        borderRadius / 2,
      ),
      child: Container(
        width: width * 0.07,
        height: isTablet ? height * 0.07 : width * 0.07,
        decoration: BoxDecoration(
          color: color.withOpacity(color == white ? 0.7 : 0.2),
          borderRadius: BorderRadius.circular(
            borderRadius / 2,
          ),
        ),
        child: Icon(
          icon,
          color: primaryColor,
        ),
      ),
    );
  }
}
