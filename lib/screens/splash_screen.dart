import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/home.dart';
import 'package:quickagro/screens/login.dart';
import 'package:quickagro/utils/size.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icon/icon.png",
                width: width * 0.25,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }

  getData() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.getSharedPreferences();
    if (authProvider.token.length == 0) {
      Get.offAll(() => Login());
    } else {
      await Provider.of<CartProvider>(context, listen: false).pullCartItems();
      await Provider.of<UserProfileProvider>(context, listen: false)
          .getProfile();
      await Provider.of<UserProfileProvider>(context, listen: false).getStats();
      await Provider.of<DataProvider>(context, listen: false).fetchNotices();
      Get.offAll(() => Home());
    }
  }
}
