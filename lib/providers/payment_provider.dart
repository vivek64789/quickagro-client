import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickagro/providers/notification_provider.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/keys.dart';
import 'package:quickagro/utils/server.dart';
import 'package:quickagro/utils/stripe_merchant_name.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class PaymentProvider extends ChangeNotifier {
  String clientSecret = "";
  Map<String, dynamic> paymentIntentData = {};

  processPayment(int amount) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {"amount": amount * 100, "currency": currency};

    var response = await http.post(
        Uri.parse("$serverUrl/payment/get-client-secret"),
        headers: headers,
        body: jsonEncode(body));

    clientSecret = jsonDecode(response.body)["clientSecret"];

    bool paymentStatus = await pay();
    return paymentStatus;
  }

  Future<bool> pay() async {
    Stripe.publishableKey = stripePublishableKey;
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: clientSecret,
      // applePay: true,
      // googlePay: true,
      style: Provider.of<ThemeProvider>(Get.context!, listen: false).isDarkTheme
          ? ThemeMode.dark
          : ThemeMode.light,
      // merchantCountryCode: countryCode,
      merchantDisplayName: stripeMerchantName,
    ));

    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Payment Cancelled", backgroundColor: primaryColor);
      Provider.of<NotificationProvider>(Get.context!, listen: false).notify(
          title: "Payment Cancelled", body: "You cancelled the payment");

      return false;
    }
  }
}
