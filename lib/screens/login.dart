import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickagro/providers/fingerprint_provider.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/forgot_password.dart';
import 'package:quickagro/screens/home.dart';
import 'package:quickagro/screens/register.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shake/shake.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  ShakeDetector? detector = ShakeDetector.autoStart(onPhoneShake: () {});
  bool _loading = false;

  bool _showPassword = false;
  String _email = "";
  String _password = "";
  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).loadTheme();
    Provider.of<FingerprintProvider>(context, listen: false)
        .getFingerprintSharedPreferences();
    Provider.of<FingerprintProvider>(context, listen: false).checkBiometrics();
    Provider.of<FingerprintProvider>(context, listen: false)
        .fetchAvailableBiometrics();

    super.initState();
    _loading = false;
    _showPassword = false;
    _email = "";
    _password = "";
  }

  @override
  void didChangeDependencies() {
    bool isFingerprintEnabled =
        Provider.of<FingerprintProvider>(context).isFingerprintEnabled;

    detector = ShakeDetector.autoStart(
      onPhoneShake: () => {isFingerprintEnabled ? loginUsingFingerPrint() : ""},
    );
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    var isFingerprintEnabled =
        Provider.of<FingerprintProvider>(context).isFingerprintEnabled;

    var fingerprintProvider = Provider.of<FingerprintProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.04),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.3),
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0),
              primaryColor.withOpacity(0),
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.3),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        width: width,
        height: height,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor,
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: Key("email"),
                      onChanged: (text) {
                        _email = text;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: textColor.withOpacity(0.1),
                        filled: true,
                      ),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Text(
                "Password",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: textColor,
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: Key("password"),
                      onChanged: (text) {
                        _password = text;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        fillColor: textColor.withOpacity(0.1),
                        filled: true,
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Material(
                            color: Colors.transparent,
                            child: Icon(
                              _showPassword
                                  ? FeatherIcons.eyeOff
                                  : FeatherIcons.eye,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => ForgotPassword());
                },
                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                width: double.infinity,
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : TextButton(
                        key: Key("login"),
                        onPressed: () {
                          login();
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.red[900],
                          backgroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              isFingerprintEnabled
                  ? SizedBox(
                      width: width,
                      child: TextButton(
                        child: Text(
                          "Login using Fingerprint?",
                          style: TextStyle(),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: loginUsingFingerPrint,
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not Registered?",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textColor,
                    ),
                  ),
                  TextButton(
                    key: Key("gotoRegister"),
                    onPressed: () {
                      Get.off(() => Register());
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginUsingFingerPrint() async {
    setState(() {
      _loading = true;
    });

    await Provider.of<FingerprintProvider>(context, listen: false)
        .authenticateUser();
    var result = Provider.of<FingerprintProvider>(context, listen: false)
        .isAuthenticated;
    if (result) {
      Map<String, String> headers = {"Content-Type": "application/json"};

      Map<String, dynamic> body = {
        "uid": Provider.of<UserProfileProvider>(context, listen: false).userId
      };

      var response = await http.post(
        Uri.parse("$serverUrl/login_fingerprint"),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Logged In!",
          backgroundColor: primaryColor,
        );

        var responseBody = jsonDecode(response.body);

        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.setAllValues(
            responseBody["email"],
            responseBody["name"],
            responseBody["token"],
            responseBody["type"],
            responseBody["profilePic"]);
        await authProvider.setSharedPreferences();

        await Provider.of<CartProvider>(context, listen: false).pullCartItems();
        await Provider.of<UserProfileProvider>(context, listen: false)
            .getProfile();
        await Provider.of<UserProfileProvider>(context, listen: false)
            .getStats();
        await Provider.of<DataProvider>(context, listen: false).fetchNotices();

        Get.offAll(() => Home());
      } else if (response.statusCode == 403) {
        Fluttertoast.showToast(
          msg: "Unauthorized Fingerprint",
          backgroundColor: primaryColor,
        );
      } else {
        setState(() {
          _loading = false;
        });
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

  login() async {
    setState(() {
      _loading = true;
    });
    if (!_email.isEmail) {
      setState(() {
        _loading = false;
      });
      return Fluttertoast.showToast(
        msg: "Enter a valid email",
        backgroundColor: primaryColor,
      );
    }

    if (_password.length < 6 || _password.length > 20) {
      setState(() {
        _loading = false;
      });
      return Fluttertoast.showToast(
        msg: "Password should have minimum 6 and maximum 20 characters",
        backgroundColor: primaryColor,
      );
    }

    Map<String, String> headers = {"Content-Type": "application/json"};

    Map<String, dynamic> body = {
      "email": _email,
      "password": _password,
    };

    var response = await http.post(
      Uri.parse("$serverUrl/login"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Logged In!",
        backgroundColor: primaryColor,
      );

      var responseBody = jsonDecode(response.body);

      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAllValues(
          responseBody["email"],
          responseBody["name"],
          responseBody["token"],
          responseBody["type"],
          responseBody["profilePic"]);
      await authProvider.setSharedPreferences();

      await Provider.of<CartProvider>(context, listen: false).pullCartItems();
      await Provider.of<UserProfileProvider>(context, listen: false)
          .getProfile();
      await Provider.of<UserProfileProvider>(context, listen: false).getStats();
      await Provider.of<DataProvider>(context, listen: false).fetchNotices();

      Get.offAll(() => Home());
    } else if (response.statusCode == 403) {
      Fluttertoast.showToast(
        msg: "Incorrect email or password",
        backgroundColor: primaryColor,
      );
    } else {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: primaryColor,
      );
    }
    setState(() {
      _loading = false;
    });
  }
}
