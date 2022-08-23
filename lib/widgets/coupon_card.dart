import 'package:flutter/material.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CouponCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showProgress;
  final String progressText;
  final double progressValue;
  final String offerType;
  final String offerValue;
  final String code;
  final bool isRedeemed;

  CouponCard({
    this.title = "",
    this.subtitle = "",
    this.showProgress = false,
    this.progressText = "",
    this.progressValue = 0.0,
    this.offerType = "amount",
    this.offerValue = "0",
    this.code = "",
    this.isRedeemed = false,
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Container(
      margin: EdgeInsets.only(
        top: width * 0.04,
        left: width * 0.04,
        right: width * 0.04,
        bottom: 0,
      ),
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
          border: Border.all(
        color: Colors.grey.withOpacity(0.4),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${offerType == 'amount' ? currencySymbol : ""}$offerValue${offerType == 'amount' ? "" : "%"} off",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Row(children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.025),
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                  child: Text(
                    code,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(
                  width: width * 0.02,
                ),
                isRedeemed
                    ? TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.025),
                          side: BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                        child: Text(
                          "Redeemed",
                          style: TextStyle(
                            color: white,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ]),
            ],
          ),
          SizedBox(
            height: height * 0.025,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: textColor,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          showProgress
              ? Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progressValue,
                        color: primaryColor,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      progressText,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
