import 'package:flutter/material.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCard extends StatelessWidget {
  final String cardNumber;
  final String cardHolderName;
  final String validTill;
  final Color color;

  CreditCard({
    required this.color,
    required this.cardNumber,
    required this.cardHolderName,
    required this.validTill,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(width * 0.025),
          padding: EdgeInsets.all(width * 0.05),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CREDIT CARD",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: white,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardNumber,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cardHolderName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: white,
                        ),
                      ),
                      Text(
                        "Valid till $validTill",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(width * 0.025),
          padding: EdgeInsets.all(width * 0.05),
          height: height * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                white.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
