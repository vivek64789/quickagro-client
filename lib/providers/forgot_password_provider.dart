import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordProvider extends ChangeNotifier {
  bool emailSent = false;
  bool codeValidate = false;
  String email = "";
  String code = "";
  String newPassword = "";

  resetForm() {
    emailSent = false;
    codeValidate = false;
    email = "";
    code = "";
    newPassword = "";
  }

  forgotPassword(String email_) async {
    email = email_;
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {"email": email};

    var response = await http.post(
        Uri.parse("$serverUrl/users/forgot-password"),
        headers: headers,
        body: jsonEncode(body));

    if (response.statusCode == 200 && response.body.contains("OK")) {
      Fluttertoast.showToast(
        msg: "Email Sent!",
        backgroundColor: primaryColor,
        toastLength: Toast.LENGTH_LONG,
      );
      emailSent = true;
      notifyListeners();
    } else if (response.statusCode == 404) {
      Fluttertoast.showToast(
        msg: "User not found",
        backgroundColor: primaryColor,
        toastLength: Toast.LENGTH_LONG,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: primaryColor,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  verifyCode(String code_) async {
    code = code_;
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {"email": email, "code": int.parse(code)};

    var response = await http.post(Uri.parse("$serverUrl/users/verify-code"),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Verified!",
        backgroundColor: primaryColor,
        toastLength: Toast.LENGTH_LONG,
      );
      codeValidate = true;
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: "Invalid Code",
        backgroundColor: primaryColor,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  changePassword(String newPassword) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {
      "email": email,
      "code": int.parse(code),
      "password": newPassword
    };

    var response = await http.post(
        Uri.parse("$serverUrl/users/forgot-password/change-pass"),
        headers: headers,
        body: jsonEncode(body));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Password Changed!",
        backgroundColor: primaryColor,
        toastLength: Toast.LENGTH_LONG,
      );
      resetForm();
      notifyListeners();
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: primaryColor,
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }
}
