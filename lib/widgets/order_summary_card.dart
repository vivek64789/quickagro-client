import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderSummaryCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String paymentMethod;

  OrderSummaryCard(
      {required this.orderId,
      required this.status,
      required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Container(
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #$orderId",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    status == "Delivered"
                        ? FeatherIcons.checkCircle
                        : FeatherIcons.circle,
                    color: status == "Delivered" ? Colors.green : Colors.blue,
                  ),
                  SizedBox(width: width * 0.01),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: status == "Delivered" ? Colors.green : Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment method",
                style: TextStyle(
                  color: textColor,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                paymentMethod,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontSize: 9.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
