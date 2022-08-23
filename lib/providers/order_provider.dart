import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickagro/providers/notification_provider.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/order_placed.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends ChangeNotifier {
  List<dynamic> orders = [];
  Map orderSummary = {};
  int activeOrdersCount = 0;
  int pastOrdersCount = 0;

  getOrderHistory() async {
    activeOrdersCount = 0;
    pastOrdersCount = 0;
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    var response = await http.get(
      Uri.parse("$serverUrl/orders/"),
      headers: headers,
    );

    orders = jsonDecode(response.body);

    for (Map order in orders) {
      if (order["status"] == "Delivered" ||
          order["status"].toString().contains("Cancelled")) {
        pastOrdersCount++;
      } else {
        activeOrdersCount++;
      }
    }

    notifyListeners();
  }

  createNewOrder(String paymentMethod, String address,
      String preferredDeliveryDate, String preferredDeliveryTime) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    var userProfileProvider =
        Provider.of<UserProfileProvider>(Get.context!, listen: false);
    var cartProvider = Provider.of<CartProvider>(Get.context!, listen: false);

    List<dynamic> cartItems = cartProvider.cartItems["items"];
    String coupon = cartProvider.cartItems["coupon"];
    int discountAmount = cartProvider.cartItems["discountAmount"];

    List<dynamic> items = [];
    for (var item in cartItems) {
      String productId = item.keys.toList()[0];
      items.add({
        "productId": productId,
        "title": item[productId]["title"],
        "weight": item[productId]["weight"],
        "price": item[productId]["price"],
        "quantity": item[productId]["quantity"],
        "stock": item[productId]["stock"],
        "images": item[productId]["images"],
        "isBundle": item[productId]["isBundle"],
      });
    }

    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {
      "items": items,
      "paymentMethod": paymentMethod,
      "address": address,
      "phone": userProfileProvider.phone,
      "coupon": coupon,
      "discountAmount": discountAmount,
      "preferredDeliveryDate": preferredDeliveryDate,
      "preferredDeliveryTime": preferredDeliveryTime
    };

    var response = await http.post(
      Uri.parse("$serverUrl/orders/new"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Order placed!", backgroundColor: primaryColor);
      Provider.of<NotificationProvider>(Get.context!, listen: false).notify(
          title: "Order Placed",
          body:
              "Your order has been placed successfully!, Please check email for more details",
          picture:
              "https://images.unsplash.com/photo-1494178270175-e96de2971df9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2048&q=80");
      Provider.of<CartProvider>(Get.context!, listen: false).emptyCartItems();

      Get.off(() => OrderPlaced(jsonDecode(response.body)));
    } else {
      Fluttertoast.showToast(msg: response.body, backgroundColor: primaryColor);
    }
  }

  cancelOrder(String orderObjId) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"orderObjId": orderObjId};

    var response = await http.post(
      Uri.parse("$serverUrl/orders/cancel-by-client"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Order cancelled", backgroundColor: primaryColor);
      getOrderHistory();
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong", backgroundColor: primaryColor);
    }
  }

  getOrderSummary(String orderObjId) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"orderObjId": orderObjId};

    var response = await http.post(
      Uri.parse("$serverUrl/orders/get-order-by-id"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      orderSummary = jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong", backgroundColor: primaryColor);
    }
  }
}
