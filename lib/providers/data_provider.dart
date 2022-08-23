import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/screens/customer_support.dart';
import 'package:quickagro/screens/notices.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DataProvider extends ChangeNotifier {
  List<dynamic> categories = [];
  List<dynamic> bundles = [];
  List<dynamic> products = [];
  List<dynamic> myCoupons = [];
  List<dynamic> categoryProducts = [];

  List<dynamic> popularProducts = [];
  List<dynamic> relatedProducts = [];

  List<dynamic> adminContacts = [];

  Map notices = {};

  int availableCouponsCount = 0;

  fetchCategories() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {"Authorization": "JWT $token"};
    var response =
        await http.get(Uri.parse("$serverUrl/categories"), headers: headers);
    categories = jsonDecode(response.body);
    notifyListeners();
  }

  fetchBundles() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {"Authorization": "JWT $token"};
    var response =
        await http.get(Uri.parse("$serverUrl/bundles"), headers: headers);
    bundles = jsonDecode(response.body);
    notifyListeners();
  }

  fetchProducts() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {"Authorization": "JWT $token"};
    var response =
        await http.get(Uri.parse("$serverUrl/products"), headers: headers);
    products = jsonDecode(response.body);
    notifyListeners();
  }

  fetchPopularProducts() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {"Authorization": "JWT $token"};
    var response = await http.get(Uri.parse("$serverUrl/products/popular"),
        headers: headers);
    popularProducts = jsonDecode(response.body);
    notifyListeners();
  }

  fetchRelatedProducts(String productId) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json",
    };
    Map<String, dynamic> body = {"productId": productId};
    var response = await http.post(
      Uri.parse("$serverUrl/products/get-related-products"),
      headers: headers,
      body: jsonEncode(body),
    );

    relatedProducts = jsonDecode(response.body);
    notifyListeners();
  }

  fetchMyCoupons() async {
    availableCouponsCount = 0;
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {"Authorization": "JWT $token"};
    var response = await http.post(Uri.parse("$serverUrl/users/my-coupons"),
        headers: headers);
    myCoupons = jsonDecode(response.body);

    for (var coupon in myCoupons) {
      if (!coupon["isRedeemed"]) {
        availableCouponsCount++;
      }
    }

    notifyListeners();
  }

  addMyCoupon(String couponCode) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"couponCode": couponCode};
    var response = await http.post(
      Uri.parse("$serverUrl/users/add-coupon"),
      headers: headers,
      body: jsonEncode(body),
    );
    return response;
  }

  requestProduct(List<String> items, String image) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"items": items, "image": image};
    var response = await http.post(
      Uri.parse("$serverUrl/products/request"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text("Request Sent!"),
              content: Text("Product request sent. Thank you!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          });
      return 200;
    } else {
      Fluttertoast.showToast(
          msg: jsonDecode(response.body)["msg"] == null
              ? "Something went wrong"
              : jsonDecode(response.body)["msg"],
          backgroundColor: primaryColor);
      return 400;
    }
  }

  fetchCategoryProducts(String categoryId) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"categoryId": categoryId};
    var response = await http.post(
      Uri.parse("$serverUrl/products/get-products-by-category"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      categoryProducts = jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
          msg: "Couldn't fetch category products",
          backgroundColor: primaryColor);
    }
    notifyListeners();
  }

  fetchNotices() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    var response =
        await http.get(Uri.parse("$serverUrl/notices"), headers: headers);

    if (response.statusCode == 200) {
      notices = jsonDecode(response.body);
    }
    notifyListeners();
  }

  updateNoticeSeen() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    await http.post(Uri.parse("$serverUrl/notices/seen"),
        headers: headers, body: jsonEncode({}));
  }

  getAdminContacts() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
    };
    var response = await http.get(
      Uri.parse("$serverUrl/users/get-admin-contacts"),
      headers: headers,
    );
    adminContacts = jsonDecode(response.body);
  }

  updateFirebaseToken() async {
    await Firebase.initializeApp();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message?.data["type"] == "chat") {
        Get.to(() => CustomerSupport());
      } else if (message?.data["type"] == "notice") {
        Get.to(() => Notices());
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data["type"] == "chat") {
        Get.to(() => CustomerSupport());
      } else if (message.data["type"] == "notice") {
        Get.to(() => Notices());
      }
    });
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((firebaseToken) async {
      String token =
          Provider.of<AuthProvider>(Get.context!, listen: false).token;
      Map<String, String> headers = {
        "Authorization": "JWT $token",
        "Content-Type": "application/json"
      };
      Map<String, dynamic> body = {"token": firebaseToken};
      await http.post(Uri.parse("$serverUrl/users/update-firebase-token"),
          headers: headers, body: jsonEncode(body));
    });
  }
}
