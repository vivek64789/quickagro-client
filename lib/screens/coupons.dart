import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/cart.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/coupon_card.dart';
import 'package:provider/provider.dart';

bool _loading = false;

class Coupons extends StatefulWidget {
  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  @override
  void initState() {
    fetchMyCoupons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          "My Coupons",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.to(() => Cart());
                          },
                          icon: Icon(
                            FeatherIcons.shoppingBag,
                            color: primaryColor,
                          ),
                          tooltip: "Cart",
                        ),
                        Provider.of<CartProvider>(context)
                                    .cartItems["items"]
                                    .length ==
                                0
                            ? SizedBox.shrink()
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: width * 0.045,
                                  height: width * 0.045,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    Provider.of<CartProvider>(context)
                                        .cartItems["items"]
                                        .length
                                        .toString(),
                                    style: TextStyle(
                                        color: white, fontSize: 10.sp),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              String _code = "";
                              return AlertDialog(
                                title: Text("Enter Coupon Code"),
                                content: TextField(
                                  onChanged: (text) {
                                    _code = text;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.card_giftcard),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        var resp = await dataProvider
                                            .addMyCoupon(_code);
                                        if (resp.statusCode == 200) {
                                          Fluttertoast.showToast(
                                              msg: "Coupon Added",
                                              backgroundColor: primaryColor);
                                          Provider.of<DataProvider>(context,
                                                  listen: false)
                                              .fetchMyCoupons();
                                          Get.back();
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: resp.body,
                                              backgroundColor: primaryColor);
                                          Get.back();
                                        }
                                      },
                                      child: Text("SUBMIT"))
                                ],
                              );
                            });
                      },
                      style: TextButton.styleFrom(
                        primary: primaryColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.card_giftcard),
                          SizedBox(width: width * 0.01),
                          Text(
                            "Enter coupon code",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(bottom: height * 0.02),
                        children: getCouponWidgets(dataProvider.myCoupons),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCouponWidgets(List<dynamic> myCoupons) {
    List<Widget> widgets = [];
    for (var coupon in myCoupons) {
      widgets.add(CouponCard(
        title: coupon["title"],
        subtitle: coupon["subtitle"],
        offerValue: coupon["offerValue"].toString(),
        offerType: coupon["offerType"],
        code: coupon["code"],
        isRedeemed: coupon["isRedeemed"],
      ));
    }
    return widgets;
  }

  fetchMyCoupons() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<DataProvider>(context, listen: false).fetchMyCoupons();
    setState(() {
      _loading = false;
    });
  }
}
