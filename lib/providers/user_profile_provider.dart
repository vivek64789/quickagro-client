import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserProfileProvider extends ChangeNotifier {
  String name = "";
  String phone = "";
  String defaultAddress = "";
  String email = "";
  String profilePic = "";
  String userId = "";

  Map stats = {"totalOrders": 0, "saved": 0, "spent": 0};

  List<dynamic> allAddress = [];

  getProfile() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
    };
    var response = await http.get(
      Uri.parse("$serverUrl/users/profile"),
      headers: headers,
    );

    var data = jsonDecode(response.body);
    name = data["name"];
    phone = data["phone"];
    defaultAddress = data["defaultAddress"];
    email = data["email"];
    profilePic = data["profilePic"];
    userId = data["_id"];

    notifyListeners();
  }

  getStats() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
    };
    var response = await http.get(
      Uri.parse("$serverUrl/users/profile/stats"),
      headers: headers,
    );

    stats = jsonDecode(response.body);

    notifyListeners();
  }

  getAllAddress() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
    };
    var response = await http.get(
      Uri.parse("$serverUrl/users/address"),
      headers: headers,
    );

    allAddress = jsonDecode(response.body);
    notifyListeners();
    return;
  }

  addAddress(String title, String address) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"title": title, "address": address};
    var response = await http.post(
      Uri.parse("$serverUrl/users/address"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Address added!",
        backgroundColor: primaryColor,
      );
      allAddress = jsonDecode(response.body);
      if (defaultAddress == "") {
        defaultAddress = address;
      }
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: primaryColor,
      );
    }
    notifyListeners();
  }

  removeAddress(String addressId) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"addressId": addressId};
    var response = await http.post(
      Uri.parse("$serverUrl/users/address/remove"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Address removed!",
        backgroundColor: primaryColor,
      );
      allAddress = jsonDecode(response.body);
      if (!allAddress.toString().contains(defaultAddress)) {
        defaultAddress = "";
      }
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: primaryColor,
      );
    }
    notifyListeners();
  }

  updatePhoneNumber(String newPhone) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {"phone": newPhone};
    var response = await http.post(
      Uri.parse("$serverUrl/users/phone"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Phone number updated!",
        backgroundColor: primaryColor,
      );
      phone = newPhone;
    } else {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: primaryColor,
      );
    }
    notifyListeners();
  }

  changePassword(String currentPassword, String newPassword) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {
      "currentPassword": currentPassword,
      "newPassword": newPassword
    };

    var response = await http.post(
      Uri.parse("$serverUrl/users/change-password"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Password changed successfully!", backgroundColor: primaryColor);
      Get.back();
    } else {
      Fluttertoast.showToast(msg: response.body, backgroundColor: primaryColor);
    }
  }

  uploadProfilePic() async {
    Firebase.initializeApp();
    File imageFile;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    imageFile = File(pickedFile.path);

    var authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);
    String fileName = authProvider.email + "_profilePic";
    var uploadTask = await FirebaseStorage.instance
        .ref()
        .child("uploads/$fileName")
        .putFile(imageFile);
    uploadTask.ref.getDownloadURL().then((value) {
      changeProfilePic(value);
    });
    return;
  }

  changeProfilePic(String profilePicUrl) async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };

    Map<String, dynamic> body = {"profilePic": profilePicUrl};

    var response = await http.post(
      Uri.parse("$serverUrl/users/change-profile-pic"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      profilePic = profilePicUrl;
      Fluttertoast.showToast(
          msg: "Profile photo updated!", backgroundColor: primaryColor);
      Get.back();
    } else {
      Fluttertoast.showToast(msg: response.body, backgroundColor: primaryColor);
    }
    notifyListeners();
  }
}
