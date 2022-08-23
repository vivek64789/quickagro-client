import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/order_provider.dart';
import 'package:quickagro/providers/payment_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/cart.dart';
import 'package:quickagro/screens/pages/profile_page/profile_add_address.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/payment_methods.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/address_card.dart';
import 'package:provider/provider.dart';

bool _loading = false;

int _selectedAddress = -1;
int _selectedPaymentMethod = 0;

String _preferredDeliveryDate = "Any";
String _preferredDeliveryTime = "Any";

DateTime selectedDate = DateTime.now();
TimeOfDay selectedFromTime = TimeOfDay.now();
TimeOfDay selectedToTime = TimeOfDay.now();

List<String> _weekDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
List<String> _month = [
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

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  void initState() {
    getAllAddress();
    super.initState();
    _loading = false;

    _selectedAddress = -1;
    _selectedPaymentMethod = 0;

    _preferredDeliveryDate = "Any";
    _preferredDeliveryTime = "Any";

    selectedDate = DateTime.now();
    selectedFromTime = TimeOfDay.now();
    selectedToTime = TimeOfDay.now();
  }

  @override
  void didChangeDependencies() {
    Provider.of<UserProfileProvider>(context, listen: false).getAllAddress();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: Container(
        height: height,
        width: width,
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
                          "Checkout",
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
                        Positioned(
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
                              cartProvider.cartItems["items"].length.toString(),
                              style: TextStyle(color: white, fontSize: 10.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(width * 0.04),
                  children: [
                    Text(
                      "Shipping to",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Column(
                      children: getAddressWidgets(
                          Provider.of<UserProfileProvider>(context).allAddress),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => ProfileAddAddress());
                          },
                          style: TextButton.styleFrom(
                            primary: primaryColor,
                          ),
                          child: Row(
                            children: [
                              Icon(FeatherIcons.plus),
                              SizedBox(width: width * 0.01),
                              Text(
                                "Add new address",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "Preferred delivery time",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            selectDate(context);
                          },
                          highlightColor: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(borderRadius),
                          child: Container(
                            padding: EdgeInsets.all(width * 0.02),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                        Text(
                                          _preferredDeliveryDate,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                  ],
                                ),
                                Icon(
                                  FeatherIcons.chevronDown,
                                  color: textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: width * 0.025),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              selectTime(context);
                            },
                            highlightColor: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Container(
                              padding: EdgeInsets.all(width * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(borderRadius),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Time",
                                            style: TextStyle(
                                              fontSize: 10.sp,
                                              color: textColor,
                                            ),
                                          ),
                                          Text(
                                            _preferredDeliveryTime,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    FeatherIcons.chevronDown,
                                    color: textColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "Payment method",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    RadioListTile(
                      value: 0,
                      groupValue: _selectedPaymentMethod,
                      onChanged: _handlePaymentMethodChanged,
                      title: Text(
                        paymentMethods[0],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                    RadioListTile(
                      value: 1,
                      groupValue: _selectedPaymentMethod,
                      onChanged: _handlePaymentMethodChanged,
                      title: Text(
                        paymentMethods[1],
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                child: Column(
                  children: [
                    SizedBox(height: height * 0.005),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total ${cartProvider.cartItems["items"].length} items in cart",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: textColor,
                          ),
                        ),
                        Text(
                          currencySymbol +
                              cartProvider.cartItems["totalPrice"].toString(),
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
                      child: _loading
                          ? Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () async {
                                placeOrder();
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
                                "Place order",
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
            ],
          ),
        ),
      ),
    );
  }

  selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _preferredDeliveryDate =
            "${_weekDay[selectedDate.weekday - 1]}, ${_month[selectedDate.month - 1]} ${selectedDate.day}";
      });
  }

  selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedFromTime,
        helpText: "Select From Time: ");

    if (picked != null && picked != selectedFromTime)
      setState(() {
        selectedFromTime = picked;
        _preferredDeliveryTime =
            "${selectedFromTime.hour}:${selectedFromTime.minute.toString().length == 1 ? "0" : ""}${selectedFromTime.minute} ${selectedFromTime.period == DayPeriod.am ? "AM" : "PM"} - ${selectedToTime.hour}:${selectedToTime.minute.toString().length == 1 ? "0" : ""}${selectedToTime.minute} ${selectedToTime.period == DayPeriod.am ? "AM" : "PM"}";
      });

    final TimeOfDay? picked2 = await showTimePicker(
        context: context,
        initialTime: selectedToTime,
        helpText: "Select To Time: ");

    if (picked2 != null && picked2 != selectedToTime)
      setState(() {
        selectedToTime = picked2;
        _preferredDeliveryTime =
            "${selectedFromTime.replacing(hour: picked2.hourOfPeriod).hour}:${selectedFromTime.minute.toString().length == 1 ? "0" : ""}${selectedFromTime.minute} ${selectedFromTime.period == DayPeriod.am ? "AM" : "PM"} - ${selectedToTime.replacing(hour: picked2.hourOfPeriod).hour}:${selectedToTime.minute.toString().length == 1 ? "0" : ""}${selectedToTime.minute} ${selectedToTime.period == DayPeriod.am ? "AM" : "PM"}";
      });
  }

  String getAddress() {
    return Provider.of<UserProfileProvider>(context, listen: false)
        .allAddress[_selectedAddress]["address"];
  }

  String getPaymentMethod() {
    return paymentMethods[_selectedPaymentMethod];
  }

  _handlePaymentMethodChanged(int? value) {
    setState(() {
      _selectedPaymentMethod = value!;
    });
  }

  List<Widget> getAddressWidgets(List<dynamic> addressList) {
    List<Widget> widgets = [];
    for (var address in addressList) {
      widgets.add(AddressCard(
        id: address["_id"],
        title: address["title"],
        address: address["address"],
        showRadio: true,
        showDelete: false,
        isSelected: _selectedAddress == addressList.indexOf(address),
        onTap: () {
          setState(() {
            _selectedAddress = addressList.indexOf(address);
          });
        },
      ));
    }
    return widgets;
  }

  placeOrder() async {
    if (_selectedAddress == -1) {
      return Fluttertoast.showToast(
          msg: "Please select address", backgroundColor: primaryColor);
    }
    setState(() {
      _loading = true;
    });
    if (_selectedPaymentMethod == 0) {
      await Provider.of<OrderProvider>(context, listen: false).createNewOrder(
          getPaymentMethod(),
          getAddress(),
          _preferredDeliveryDate,
          _preferredDeliveryTime);
    } else {
      int amount = int.parse(Provider.of<CartProvider>(context, listen: false)
          .cartItems["totalPrice"]
          .toString());
      bool paymentStatus =
          await Provider.of<PaymentProvider>(context, listen: false)
              .processPayment(amount);
      if (paymentStatus) {
        await Provider.of<OrderProvider>(context, listen: false).createNewOrder(
            getPaymentMethod(),
            getAddress(),
            _preferredDeliveryDate,
            _preferredDeliveryTime);
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong",
          backgroundColor: primaryColor,
        );
      }
    }
    setState(() {
      _loading = false;
    });
  }

  getAllAddress() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<UserProfileProvider>(context, listen: false)
        .getAllAddress();
    setState(() {
      _loading = false;
    });
  }
}
