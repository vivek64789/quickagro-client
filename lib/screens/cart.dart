import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/checkout.dart';
import 'package:quickagro/screens/home.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/cart_product_list_card.dart';
import 'package:quickagro/widgets/error_message_widget.dart';
import 'package:provider/provider.dart';

int _selectedCouponIndex = -1;

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  @override
  void initState() {
    setState(() {
      _selectedCouponIndex = -1;
    });
    super.initState();
    Provider.of<DataProvider>(context, listen: false).fetchMyCoupons();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;
    var cartProvider = Provider.of<CartProvider>(context);
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
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
                          "Cart",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${cartProvider.cartItems["items"].length} items",
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
              cartProvider.cartItems["items"].length == 0
                  ? ErrorMessageWidget(
                      animPath: 'assets/animations/shopping-bag-error.json',
                      title: "Empty Cart",
                      description:
                          "Looks like you haven't added any items yet.",
                      actionTitle: "Lets Shop",
                      onTapAction: () {
                        Get.offAll(() => Home());
                      },
                    )
                  : Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(width * 0.02),
                        physics: BouncingScrollPhysics(),
                        children: getCartProductListCards(
                            cartProvider.cartItems["items"]),
                      ),
                    ),
              cartProvider.cartItems["items"].length == 0
                  ? SizedBox.shrink()
                  : Container(
                      padding: EdgeInsets.all(width * 0.04),
                      decoration: BoxDecoration(
                        color: scaffoldColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius * 3),
                          topRight: Radius.circular(borderRadius * 3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: Offset(0, -2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 200),
                        clipBehavior: Clip.none,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dataProvider.availableCouponsCount != 0
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      bottom: height * 0.01,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Coupons Available",
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedCouponIndex = -1;
                                            });
                                            cartProvider.clearDiscount();
                                          },
                                          child: Text("CLEAR"),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            dataProvider.availableCouponsCount != 0
                                ? SizedBox(
                                    height: height * 0.15,
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: Provider.of<DataProvider>(
                                              context)
                                          .myCoupons
                                          .map(
                                            (coupon) => coupon["isRedeemed"]
                                                ? SizedBox.shrink()
                                                : ListTile(
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedCouponIndex =
                                                            dataProvider
                                                                .myCoupons
                                                                .indexOf(
                                                                    coupon);
                                                      });
                                                      cartProvider.setDiscount(
                                                        coupon["_id"],
                                                        coupon["offerValue"],
                                                        coupon["offerType"],
                                                      );
                                                    },
                                                    title: Text(coupon["title"],
                                                        style: TextStyle(
                                                          color: textColor,
                                                        )),
                                                    subtitle: Text(
                                                        "${coupon["offerType"] == 'amount' ? currencySymbol : ""}${coupon["offerValue"]}${coupon["offerType"] == 'amount' ? "" : "%"} off",
                                                        style: TextStyle(
                                                          color: textColor,
                                                        )),
                                                    trailing: dataProvider
                                                                .myCoupons
                                                                .indexOf(
                                                                    coupon) ==
                                                            _selectedCouponIndex
                                                        ? Icon(
                                                            FeatherIcons.check,
                                                            color: primaryColor,
                                                          )
                                                        : SizedBox.shrink(),
                                                  ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            SizedBox(height: height * 0.005),
                            _selectedCouponIndex == -1
                                ? SizedBox.shrink()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Discount Applied",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: textColor,
                                        ),
                                      ),
                                      Text(
                                        "- " +
                                            currencySymbol +
                                            "${cartProvider.cartItems["discountAmount"]}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                            SizedBox(height: height * 0.005),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                Text(
                                  currencySymbol +
                                      "${cartProvider.cartItems["totalPrice"]}",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Get.to(() => CheckOut());
                                },
                                style: TextButton.styleFrom(
                                  primary: Colors.red[900],
                                  backgroundColor: primaryColor,
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.015,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(borderRadius),
                                  ),
                                ),
                                child: Text(
                                  "Proceed to checkout",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
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

  List<Widget> getCartProductListCards(List<dynamic> cartItems) {
    List<Widget> widgets = [];
    for (Map item in cartItems) {
      widgets.add(
        CartProductListCard(
          productId: item.keys.toList()[0],
          title: item[item.keys.toList()[0]]["title"],
          weight: item[item.keys.toList()[0]]["weight"],
          price: item[item.keys.toList()[0]]["price"].toString(),
          quantity: item[item.keys.toList()[0]]["quantity"],
          image: item[item.keys.toList()[0]]["images"][0],
          onDismissed: (dismissDirection) {
            Provider.of<CartProvider>(context, listen: false)
                .removeFromCart(item.keys.toList()[0]);
          },
        ),
      );
    }
    return widgets;
  }
}
