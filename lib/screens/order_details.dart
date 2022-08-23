import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/cancel_order.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/server.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/courier_contact_card.dart';
import 'package:quickagro/widgets/order_detail_card.dart';
import 'package:quickagro/widgets/product_list_card_mini.dart';
import 'package:quickagro/widgets/track_order_route_line.dart';
import 'package:quickagro/widgets/track_order_route_spot.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

bool _delivered = false;

class OrderDetails extends StatefulWidget {
  final Map order;
  OrderDetails(this.order);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Socket? socket;

  @override
  void initState() {
    setState(() {
      _delivered = false;
    });
    super.initState();
    connectToWebSocket();
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

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
                    "Order Details",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(width * 0.02),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order #${widget.order["orderId"]}",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15.sp,
                          ),
                        ),
                        widget.order["isDelivered"] || _delivered
                            ? SizedBox.shrink()
                            : TextButton(
                                onPressed: () {
                                  Get.off(
                                      () => CancelOrder(widget.order["_id"]));
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(width * 0.02),
                                  side: BorderSide(
                                    color: primaryColor,
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                  ),
                                ),
                                child: Text(
                                  "Cancel order",
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Icon(
                          FeatherIcons.circle,
                          color: widget.order["isCancelled"]
                              ? Colors.grey
                              : !widget.order["isCancelled"] &&
                                      !widget.order["isDelivered"] &&
                                      !_delivered
                                  ? Colors.blue
                                  : Colors.green,
                        ),
                        SizedBox(width: width * 0.02),
                        Text(
                          _delivered ? "Delivered" : widget.order["status"],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: widget.order["isCancelled"]
                                ? Colors.grey
                                : !widget.order["isCancelled"] &&
                                        !widget.order["isDelivered"] &&
                                        !_delivered
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
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      children: getMiniProductListCards(widget.order),
                    ),
                    Divider(),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11.sp,
                          ),
                        ),
                        Text(
                          "$currencySymbol${widget.order["totalPrice"] + widget.order["discountAmount"]}",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Discount",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11.sp,
                          ),
                        ),
                        Text(
                          "-$currencySymbol${widget.order["discountAmount"]}",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11.sp,
                          ),
                        ),
                        Text(
                          "$currencySymbol${widget.order["totalPrice"]}",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Divider(),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    OrderDetailCard(
                      address: widget.order["address"],
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    widget.order["courier"] == null
                        ? SizedBox.shrink()
                        : CourierContactCard(
                            courierName: widget.order["courier"]["name"],
                            phone: widget.order["courier"]["phone"],
                            email: widget.order["courier"]["email"]),
                    SizedBox(height: height * 0.02),
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
                          widget.order["preferredDeliveryDate"],
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
                          widget.order["preferredDeliveryTime"],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12.sp,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Divider(),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    TrackOrderRouteSpot(
                      true,
                      "Order placed",
                      getFormattedDateTime(widget.order["date"].toString()),
                    ),
                    TrackOrderRouteLine(
                        widget.order["status"] == "Processing" ||
                            widget.order["status"] == "Out for delivery" ||
                            widget.order["isDelivered"]),
                    TrackOrderRouteSpot(
                      widget.order["status"] == "Processing" ||
                          widget.order["status"] == "Out for delivery" ||
                          widget.order["isDelivered"],
                      "Items processing",
                      "",
                    ),
                    TrackOrderRouteLine(
                        widget.order["status"] == "Out for delivery" ||
                            widget.order["isDelivered"]),
                    TrackOrderRouteSpot(
                      widget.order["status"] == "Out for delivery" ||
                          widget.order["isDelivered"],
                      "Out for delivery",
                      widget.order["status"] == "Out for delivery" ||
                              widget.order["isDelivered"]
                          ? "You courier is on the way"
                          : "",
                    ),
                    TrackOrderRouteLine(false),
                    TrackOrderRouteSpot(
                      false,
                      "Shopping delivered",
                      widget.order["preferredDeliveryDate"] == "Any" ||
                              widget.order["preferredDeliveryTime"] == "Any"
                          ? ""
                          : "Expected at ${widget.order["preferredDeliveryDate"]} ${widget.order["preferredDeliveryTime"]}",
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Divider(),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    widget.order["isDelivered"] || _delivered
                        ? Column(
                            children: [
                              Icon(
                                FeatherIcons.checkCircle,
                                color: Colors.green,
                                size: width * 0.4,
                              ),
                              SizedBox(height: height * 0.02),
                              Text(
                                "Order Delivered!",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "Thank you for shopping!",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: textColor.withOpacity(0.5),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Order Verification Code:",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                widget.order["verificationCode"].toString(),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              Text(
                                "Tell this verification code / Show QR Code to the courier to get the delivery",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                    widget.order["isDelivered"] || _delivered
                        ? SizedBox.shrink()
                        : Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.2,
                              vertical: width * 0.1,
                            ),
                            child: PrettyQr(
                              elementColor: primaryColor,
                              data: widget.order["verificationCode"].toString(),
                              roundEdges: true,
                            ),
                          ),
                    SizedBox(
                      height: height * 0.2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getMiniProductListCards(Map order) {
    List<Widget> widgets = [];
    for (int i = 0; i < order["items"].length; i++) {
      widgets.add(
        ProductListCardMini(
          title: order["items"][i]["title"] +
              " (${order["items"][i]["quantity"]})",
          weight: order["items"][i]["weight"],
          price: order["items"][i]["price"],
          images: order["items"][i]["images"],
        ),
      );
    }
    return widgets;
  }

  void connectToWebSocket() {
    try {
      socket = io(serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket?.connect();

      socket?.on("deliver", (message) {
        if (message.toString() == widget.order["verificationCode"].toString()) {
          setState(() {
            _delivered = true;
          });
        }
      });
    } catch (e) {}
  }

  getFormattedDateTime(String dateTime) {
    List<String> month = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return "${dateTime.split("T")[0].split("-")[0]} ${month[int.parse(dateTime.split("T")[0].toString().split("-")[1].toString()) - 1]} ${dateTime.split("T")[0].split("-")[2]}";
  }
}
