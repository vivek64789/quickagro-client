import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/order_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/order_detail_card.dart';
import 'package:quickagro/widgets/order_summary_card.dart';
import 'package:quickagro/widgets/product_list_card_mini.dart';
import 'package:provider/provider.dart';

bool _loading = false;

class OrderSummary extends StatefulWidget {
  final Map order;

  OrderSummary(this.order);

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  void initState() {
    getOrderSummary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var orderProvider = Provider.of<OrderProvider>(context);

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
                    "Order Summary",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.025,
              ),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(width * 0.02),
                        children: [
                          OrderSummaryCard(
                            orderId: widget.order["orderId"].toString(),
                            paymentMethod: widget.order["paymentMethod"],
                            status: widget.order["status"],
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Container(
                            padding: EdgeInsets.all(width * 0.03),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Items",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                    // IconButton(
                                    //   onPressed: () {},
                                    //   icon: Icon(
                                    //     FeatherIcons.edit2,
                                    //     color: textColor,
                                    //   ),
                                    //   tooltip: "Edit",
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Column(
                                  children: getMiniProductListCards(
                                      orderProvider.orderSummary),
                                ),
                                Divider(),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Subtotal",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                    Text(
                                      "$currencySymbol${orderProvider.orderSummary["totalPrice"] + orderProvider.orderSummary["discountAmount"]}",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Discount",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                    Text(
                                      "-$currencySymbol${orderProvider.orderSummary["discountAmount"]}",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 11.sp,
                                      ),
                                    ),
                                    Text(
                                      "$currencySymbol${orderProvider.orderSummary["totalPrice"]}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          OrderDetailCard(
                              address: orderProvider.orderSummary["address"]),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(FeatherIcons.calendar, color: textColor),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    "Preferred Delivery Date: ",
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                orderProvider
                                    .orderSummary["preferredDeliveryDate"],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12.sp,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(FeatherIcons.clock, color: textColor),
                                  SizedBox(
                                    width: width * 0.02,
                                  ),
                                  Text(
                                    "Preferred Delivery Time: ",
                                    style: TextStyle(
                                        color: textColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                orderProvider
                                    .orderSummary["preferredDeliveryTime"],
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 12.sp,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: TextButton(
              //     onPressed: () {

              //     },
              //     style: TextButton.styleFrom(
              //       primary: Colors.red[900],
              //       backgroundColor: primaryColor,
              //       padding: EdgeInsets.symmetric(
              //         vertical: height * 0.015,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(borderRadius),
              //       ),
              //     ),
              //     child: Text(
              //       "Reorder",
              //       style: TextStyle(
              //         color: white,
              //         fontSize: 12.sp,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getMiniProductListCards(Map orderSummary) {
    List<Widget> widgets = [];
    for (int i = 0; i < orderSummary["items"].length; i++) {
      widgets.add(
        ProductListCardMini(
          title: orderSummary["items"][i]["title"] +
              " (${orderSummary["items"][i]["quantity"]})",
          weight: orderSummary["items"][i]["weight"],
          price: orderSummary["items"][i]["price"],
          images: orderSummary["items"][i]["images"],
        ),
      );
    }
    return widgets;
  }

  getOrderSummary() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<OrderProvider>(context, listen: false)
        .getOrderSummary(widget.order["_id"]);
    setState(() {
      _loading = false;
    });
  }
}
