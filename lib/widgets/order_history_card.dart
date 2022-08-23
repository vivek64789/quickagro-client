import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/cancel_order.dart';
import 'package:quickagro/screens/customer_support.dart';
import 'package:quickagro/screens/order_summary.dart';
import 'package:quickagro/screens/order_details.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderHistoryCard extends StatelessWidget {
  final Map order;

  OrderHistoryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      padding: EdgeInsets.only(
          top: width * 0.03,
          left: width * 0.03,
          right: width * 0.03,
          bottom: width * 0.02),
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
              Text(
                order["date"].toString().split("T")[0],
                style: TextStyle(fontSize: 14.sp, color: textColor),
              ),
              Row(
                children: [
                  Text(
                    currencySymbol + order["totalPrice"].toString(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Icon(FeatherIcons.chevronRight)
                ],
              ),
            ],
          ),
          SizedBox(
            height: height * 0.005,
          ),
          Text(
            "Order #${order["orderId"]}",
            style: TextStyle(
              fontSize: 13.sp,
              color: textColor.withOpacity(0.7),
            ),
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                FeatherIcons.shoppingBag,
                color: textColor.withOpacity(0.7),
              ),
              SizedBox(width: width * 0.02),
              SizedBox(
                width: width * 0.75,
                child: Text(
                  getItemsString(order["items"]),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: textColor.withOpacity(0.7),
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.015,
          ),
          Row(
            children: [
              Icon(
                FeatherIcons.circle,
                color: order["isCancelled"]
                    ? Colors.grey
                    : !order["isCancelled"] && !order["isDelivered"]
                        ? Colors.blue
                        : Colors.green,
              ),
              SizedBox(width: width * 0.02),
              Text(
                order["status"],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: order["isCancelled"]
                      ? Colors.grey
                      : !order["isCancelled"] && !order["isDelivered"]
                          ? Colors.blue
                          : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Divider(),
          Row(
            children: [
              order["isCancelled"] || order["isDelivered"]
                  ? SizedBox.shrink()
                  : Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.02,
                          ),
                        ),
                        onPressed: () {
                          if (!order["isCancelled"] && !order["isDelivered"]) {
                            Get.to(() => CancelOrder(order["_id"]));
                          }
                        },
                        child: Text(
                          "Cancel order",
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.02,
                    ),
                  ),
                  onPressed: () {
                    Get.to(() => order["isCancelled"]
                        ? CustomerSupport()
                        : !order["isCancelled"] && !order["isDelivered"]
                            ? OrderDetails(order)
                            : OrderSummary(order));
                  },
                  child: Text(
                    order["isCancelled"]
                        ? "Report your problem"
                        : !order["isCancelled"] && !order["isDelivered"]
                            ? "Order Details"
                            : "View Order Summary",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getItemsString(List<dynamic> items) {
    String itemsString = "";
    for (var item in items) {
      if (items.indexOf(item) != 0) itemsString += ", ";
      itemsString += item["title"] + " (${item["quantity"]})";
    }
    return itemsString;
  }
}
