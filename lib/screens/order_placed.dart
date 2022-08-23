import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/utils/get_responsive.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/home.dart';
import 'package:quickagro/screens/order_summary.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderPlaced extends StatefulWidget {
  final Map order;

  OrderPlaced(this.order);
  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Get.offAll(() => Home());
                },
                icon: Icon(
                  FeatherIcons.x,
                  color: textColor,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: isTablet ? width * 0.5 : width * 0.2,
                        child: Lottie.asset(
                          'assets/animations/check_anim.json',
                          repeat: false,
                        ),
                      ),
                      Text(
                        "Order placed successfully",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Order ID: ${widget.order["orderId"]}",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(() => OrderSummary(widget.order));
                        },
                        child: Text(
                          "View details",
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                        width: width * 0.5,
                        child: TextButton(
                          onPressed: () {
                            Get.offAll(() => Home());
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
                                "Go Home",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 14.sp,
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
                      SizedBox(
                        height: height * 0.1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
