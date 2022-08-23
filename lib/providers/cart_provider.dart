import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CartProvider extends ChangeNotifier {
  Map<String, dynamic> cartItems = {
    "items": [],
    "coupon": "",
    "discountAmount": 0,
    "totalPrice": 0,
  };

  setDiscount(String couponId, int value, String discountType) {
    clearDiscount();
    cartItems["coupon"] = couponId;
    if (discountType == "amount") {
      cartItems["discountAmount"] = int.parse(value.toString());
    } else {
      int totalPrice = int.parse(cartItems["totalPrice"].toString());
      cartItems["discountAmount"] = (totalPrice * (value / 100)).toInt();
    }

    cartItems["totalPrice"] =
        cartItems["totalPrice"] - cartItems["discountAmount"];
    notifyListeners();
  }

  clearDiscount() {
    cartItems["totalPrice"] = int.parse(cartItems["totalPrice"].toString()) +
        int.parse(cartItems["discountAmount"].toString());
    cartItems["coupon"] = "";
    cartItems["discountAmount"] = 0;
    notifyListeners();
  }

  pullCartItems() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
    };
    var response = await http.get(
      Uri.parse("$serverUrl/cart"),
      headers: headers,
    );

    cartItems = jsonDecode(response.body);

    notifyListeners();
  }

  pushCartItems() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {"cartItems": cartItems};

    await http.post(Uri.parse("$serverUrl/cart"),
        headers: headers, body: jsonEncode(body));

    notifyListeners();
  }

  addToCart(String productId, String title, String weight, String price,
      String stock, List<dynamic> images, bool isBundle) {
    bool isExist = false;
    List<dynamic> items = cartItems["items"];
    int totalPrice = 0;

    for (Map item in items) {
      if (item.keys.toList()[0] == productId) {
        isExist = true;
        int quantity = item[productId]["quantity"];
        quantity++;
        item[productId]["quantity"] = quantity;
      }
      totalPrice +=
          (int.parse(item[item.keys.toList()[0]]["quantity"].toString()) *
              int.parse(item[item.keys.toList()[0]]["price"].toString()));
    }

    if (!isExist) {
      totalPrice += int.parse(price);
      cartItems["items"].add({
        productId: {
          "title": title,
          "weight": weight,
          "price": price,
          "quantity": 1,
          "stock": stock,
          "images": images,
          "isBundle": isBundle
        }
      });
    }

    cartItems["totalPrice"] = totalPrice;

    pushCartItems();

    notifyListeners();
  }

  subtractFromCart(String productId) {
    List<dynamic> items = cartItems["items"];
    List<dynamic> newCartItems = [];
    int quantity = -1;
    int totalPrice = cartItems["totalPrice"];

    for (Map item in items) {
      if (item.keys.toList()[0] == productId) {
        quantity = item[productId]["quantity"];
        if (quantity > 0) {
          quantity--;
          totalPrice -= int.parse(item[productId]["price"].toString());
        }
        item[productId]["quantity"] = quantity;
      }
    }

    if (quantity == 0) {
      for (Map item in items) {
        if (item.keys.toList()[0] != productId) {
          newCartItems.add(item);
        }
      }
      cartItems["items"] = newCartItems;
    }

    cartItems["totalPrice"] = totalPrice;

    pushCartItems();

    notifyListeners();
  }

  removeFromCart(String productId) {
    List<dynamic> items = cartItems["items"];
    List<dynamic> newCartItems = [];
    int totalPrice = 0;
    for (Map item in items) {
      if (item.keys.toList()[0] != productId) {
        newCartItems.add(item);
        totalPrice +=
            (int.parse(item[item.keys.toList()[0]]["quantity"].toString()) *
                int.parse(item[item.keys.toList()[0]]["price"].toString()));
      }
    }
    cartItems["items"] = newCartItems;
    cartItems["totalPrice"] = totalPrice;

    pushCartItems();

    notifyListeners();
  }

  int getQuantity(String productId) {
    List<dynamic> items = cartItems["items"];
    int quantity = 0;
    for (Map item in items) {
      if (item.keys.toList()[0] == productId) {
        quantity = item[productId]["quantity"];
      }
    }

    return quantity;
  }

  emptyCartItems() {
    cartItems = {
      "items": [],
      "coupon": "",
      "discountAmount": 0,
      "totalPrice": 0,
    };
    pushCartItems();
  }
}
