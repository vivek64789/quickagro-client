import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/login.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/masked_text_input.dart';
import 'package:quickagro/utils/server.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

bool _loading = false;

bool _showPassword = false;
String _name = "";
String _email = "";
String _password = "";
String _countryCode = "";
String _phone = "";

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).loadTheme();
    super.initState();
    _loading = false;
    _showPassword = false;
    _name = "";
    _email = "";
    _password = "";
    _countryCode = "";
    _phone = "";
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                  "Register",
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
                  "Name",
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
                        key: Key("name"),
                        onChanged: (text) {
                          _name = text;
                        },
                        keyboardType: TextInputType.name,
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
                SizedBox(
                  height: height * 0.03,
                ),
                Text(
                  "Phone",
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
                    SizedBox(
                      width: width * 0.15,
                      child: TextField(
                        key: Key("phoneCode"),
                        onChanged: (text) {
                          _countryCode = text;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskedTextInputFormatter(
                            mask: 'xxx',
                            separator: '-',
                          ),
                        ],
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            fillColor: textColor.withOpacity(0.1),
                            filled: true,
                            hintText: "+xx"),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Expanded(
                      child: TextField(
                        key: Key("phone"),
                        onChanged: (text) {
                          _phone = text;
                        },
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskedTextInputFormatter(
                            mask: 'xxxxxxxxxx',
                            separator: '',
                          ),
                        ],
                        decoration: InputDecoration(
                            fillColor: textColor.withOpacity(0.1),
                            filled: true,
                            hintText: "xxxxxxxxxx"),
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
                  height: height * 0.04,
                ),
                SizedBox(
                  width: double.infinity,
                  child: _loading
                      ? Center(child: CircularProgressIndicator())
                      : TextButton(
                          key: Key("registerButton"),
                          onPressed: () {
                            register();
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
                            "Register",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Registered?",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: textColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.off(() => Login());
                      },
                      child: Text(
                        "Login",
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
      ),
    );
  }

  register() async {
    setState(() {
      _loading = true;
    });
    if (_name.length < 3) {
      setState(() {
        _loading = false;
      });
      return Fluttertoast.showToast(
        msg: "Name should have minimum 3 characters",
        backgroundColor: primaryColor,
      );
    }

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
      "name": _name,
      "email": _email,
      "password": _password,
      "type": "client",
      "phone": _countryCode + _phone,
    };

    print("$body this is body");

    var response = await http.post(
      Uri.parse("$serverUrl/register"),
      headers: headers,
      body: jsonEncode(body),
    );
    print("$response this is response from server");

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Registered!",
        backgroundColor: primaryColor,
      );

      Get.off(() => Login());
    } else if (response.statusCode == 400) {
      if (response.body.contains("email is already used")) {
        Fluttertoast.showToast(
          msg: "Already registered!",
          backgroundColor: primaryColor,
        );
      }
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
