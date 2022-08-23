import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/product_request_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

bool _loading = false;

List<String> _requestItems = [];
String _imageUrl = "";
String _currentItem = "";

class ProductRequest extends StatefulWidget {
  @override
  _ProductRequestState createState() => _ProductRequestState();
}

class _ProductRequestState extends State<ProductRequest> {
  @override
  void initState() {
    super.initState();
    _requestItems = [];
    _imageUrl = "";
    _currentItem = "";
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      FeatherIcons.chevronLeft,
                      color: textColor,
                    ),
                    tooltip: "Back",
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Make Product Request",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Can't find your desired items in the shop?",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    InkWell(
                      onTap: () async {
                        if (_loading) {
                          Fluttertoast.showToast(
                              msg: "Uploading Image. Please wait..",
                              backgroundColor: primaryColor);
                          return;
                        }
                        setState(() {
                          _loading = true;
                        });
                        await uploadImage();
                        setState(() {
                          _loading = false;
                        });
                      },
                      highlightColor: primaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                        ),
                        padding: EdgeInsets.all(width * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FeatherIcons.uploadCloud,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Upload image",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: textColor,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.005,
                                ),
                                Text(
                                  "Choose image of your shopping list from gallery",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: textColor.withOpacity(0.7),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    _imageUrl == ""
                        ? SizedBox.shrink()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(borderRadius),
                            child: Image.network(
                              _imageUrl,
                              width: width * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      "Give us a list of products",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Column(children: getProductRequestWidgetList()),
                    Divider(),
                    TextButton(
                      onPressed: () {
                        if (_currentItem == "") {
                          Fluttertoast.showToast(
                              msg: "Item can't be empty",
                              backgroundColor: primaryColor);
                          return;
                        }
                        setState(() {
                          _requestItems.add(_currentItem);
                          _currentItem = "";
                        });
                      },
                      style: TextButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.01)),
                      child: Row(
                        children: [
                          Icon(FeatherIcons.plus),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Text(
                            "Add new item",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: _loading
                          ? Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () async {
                                if (_requestItems.length == 0) {
                                  Fluttertoast.showToast(
                                      msg: "Add at least 1 Item",
                                      backgroundColor: primaryColor);
                                  return;
                                }
                                setState(() {
                                  _loading = true;
                                  if (_currentItem != "") {
                                    _requestItems.add(_currentItem);
                                  }
                                  _currentItem = "";
                                });
                                int status = await Provider.of<DataProvider>(
                                        context,
                                        listen: false)
                                    .requestProduct(_requestItems, _imageUrl);
                                if (status == 200) {
                                  setState(() {
                                    _requestItems = [];
                                    _currentItem = "";
                                  });
                                }
                                setState(() {
                                  _loading = false;
                                });
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.red[900],
                                backgroundColor: primaryColor,
                                padding: EdgeInsets.symmetric(
                                  vertical: height * 0.015,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(borderRadius),
                                ),
                              ),
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getProductRequestWidgetList() {
    List<Widget> widgets = [];
    for (int i = 0; i < _requestItems.length + 1; i++) {
      widgets.add(ProductRequestList(
        number: i + 1,
        title: i == _requestItems.length ? "" : _requestItems[i],
        showTextField: i == _requestItems.length,
        onChanged: (text) {
          setState(() {
            _currentItem = text;
          });
        },
        onDelete: () {
          setState(() {
            _requestItems.removeAt(i);
            _currentItem = "";
          });
        },
      ));
    }
    return widgets;
  }

  uploadImage() async {
    Firebase.initializeApp();
    File imageFile;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      setState(() {
        _loading = false;
      });
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
      setState(() {
        _imageUrl = value;
      });
    });
    return;
  }
}
