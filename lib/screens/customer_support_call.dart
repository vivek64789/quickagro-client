import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

bool _loading = false;

class CustomerSupportCall extends StatefulWidget {
  @override
  _CustomerSupportCallState createState() => _CustomerSupportCallState();
}

class _CustomerSupportCallState extends State<CustomerSupportCall> {
  @override
  void initState() {
    super.initState();
    getAdminContacts();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        width: width,
        height: height,
        child: SafeArea(
          child: Column(
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
                    "Contact Admins",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                        itemCount: dataProvider.adminContacts.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              launch(
                                  "tel:${dataProvider.adminContacts[index]["phone"]}");
                            },
                            leading: Icon(
                              FeatherIcons.phone,
                              color: primaryColor,
                            ),
                            title: Text(
                              dataProvider.adminContacts[index]["name"],
                              style:
                                  TextStyle(color: textColor, fontSize: 14.sp),
                            ),
                            subtitle: Text(
                              dataProvider.adminContacts[index]["phone"],
                              style: TextStyle(
                                  color: textColor.withOpacity(0.8),
                                  fontSize: 12.sp),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAdminContacts() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<DataProvider>(context, listen: false).getAdminContacts();
    setState(() {
      _loading = false;
    });
  }
}
