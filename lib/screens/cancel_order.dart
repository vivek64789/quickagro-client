import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/order_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/error_message_widget.dart';
import 'package:provider/provider.dart';

bool _loading = false;

class CancelOrder extends StatefulWidget {
  final String orderObjId;

  CancelOrder(this.orderObjId);

  @override
  _CancelOrderState createState() => _CancelOrderState();
}

class _CancelOrderState extends State<CancelOrder> {
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
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      FeatherIcons.chevronLeft,
                      color: textColor,
                    ),
                    tooltip: "Back",
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Cancel Order",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ErrorMessageWidget(
                            animPath:
                                "assets/animations/order-delivery-to-home.json",
                            title: "Order Cancellation",
                            description:
                                "Are you sure want to cancel this order?",
                            actionTitle: "Cancel Order",
                            onTapAction: () async {
                              setState(() {
                                _loading = true;
                              });
                              await Provider.of<OrderProvider>(context,
                                      listen: false)
                                  .cancelOrder(widget.orderObjId);
                              setState(() {
                                _loading = false;
                              });
                              Get.back();
                            },
                          ),
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
