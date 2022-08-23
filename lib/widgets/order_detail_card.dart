import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderDetailCard extends StatelessWidget {
  final String address;

  OrderDetailCard({required this.address});

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Container(
      padding: EdgeInsets.all(width * 0.025),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(FeatherIcons.mapPin, color: textColor),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  SizedBox(
                    width: width * 0.6,
                    child: Text(
                      address,
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
