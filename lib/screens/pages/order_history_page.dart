import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/providers/order_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/home.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/error_message_widget.dart';
import 'package:quickagro/widgets/order_history_card.dart';
import 'package:quickagro/widgets/tab_button.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

bool _loading = false;
bool _activeOrders = true;

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  @override
  void initState() {
    super.initState();
    _loading = false;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var orderProvider = Provider.of<OrderProvider>(context);

    return Container(
      padding: EdgeInsets.all(width * 0.02),
      height: height,
      width: width,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FeatherIcons.chevronLeft,
                    color: textColor,
                  ),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  "Order History",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: textColor,
                  ),
                ),
              ],
            ),
            _loading
                ? Expanded(child: Center(child: CircularProgressIndicator()))
                : orderProvider.orders.length == 0
                    ? ErrorMessageWidget(
                        animPath:
                            'assets/animations/empty-sad-shopping-bag.json',
                        title: "No order history",
                        description:
                            "Buy something to see your order here. Have fun shopping!",
                        actionTitle: "Lets Shop",
                        onTapAction: () {
                          Get.offAll(
                            () => Home(),
                          );
                        },
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: width * 0.02),
                              padding: EdgeInsets.all(width * 0.01),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TabButton(_activeOrders,
                                        "Active (${orderProvider.activeOrdersCount})",
                                        () {
                                      setState(() {
                                        _activeOrders = true;
                                      });
                                    }),
                                  ),
                                  SizedBox(
                                    width: width * 0.01,
                                  ),
                                  Expanded(
                                    child: TabButton(!_activeOrders,
                                        "Past Orders (${orderProvider.pastOrdersCount})",
                                        () {
                                      setState(() {
                                        _activeOrders = false;
                                      });
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  await getData();
                                },
                                child: ListView.builder(
                                  padding: EdgeInsets.all(width * 0.02),
                                  itemCount: orderProvider.orders.length,
                                  itemBuilder: (context, index) {
                                    var order = orderProvider.orders[index];
                                    return _activeOrders &&
                                            (order["isCancelled"] ||
                                                order["isDelivered"])
                                        ? SizedBox.shrink()
                                        : !_activeOrders &&
                                                !order["isCancelled"] &&
                                                !order["isDelivered"]
                                            ? SizedBox.shrink()
                                            : OrderHistoryCard(
                                                order: order,
                                              );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  getData() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<OrderProvider>(context, listen: false).getOrderHistory();
    setState(() {
      _loading = false;
    });
  }
}
