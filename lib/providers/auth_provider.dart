import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickagro/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String email = "";
  String name = "";
  String token = "";
  String type = "";
  String profilePic = "";

  changeEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  changeName(String newName) {
    name = newName;
    notifyListeners();
  }

  changeToken(String newToken) {
    token = newToken;
    notifyListeners();
  }

  changeType(String newType) {
    type = newType;
    notifyListeners();
  }

  changeProfilePic(String newProfilePic) {
    profilePic = newProfilePic;
    notifyListeners();
  }

  setAllValues(String newEmail, String newName, String newToken, String newType,
      String newProfilePic) {
    email = newEmail;
    name = newName;
    token = newToken;
    type = newType;
    profilePic = newProfilePic;
    notifyListeners();
  }

  clearAllValues() {
    email = "";
    name = "";
    token = "";
    type = "";
    profilePic = "";
    notifyListeners();
  }

  setSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("name", name);
    prefs.setString("token", token);
    prefs.setString("type", type);
  }

  getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") == null ? "" : prefs.getString("email")!;
    name = prefs.getString("name") == null ? "" : prefs.getString("name")!;
    token = prefs.getString("token") == null ? "" : prefs.getString("token")!;
    type = prefs.getString("type") == null ? "" : prefs.getString("type")!;
  }

  logOut() async {
    clearAllValues();
    await setSharedPreferences();
    Get.offAll(() => Login());
  }
}
