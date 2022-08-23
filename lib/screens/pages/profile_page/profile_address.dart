import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/pages/profile_page/profile_add_address.dart';
import 'package:quickagro/utils/size.dart';
import 'package:quickagro/widgets/address_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool _loading = false;

class ProfileAddress extends StatefulWidget {
  const ProfileAddress({Key? key}) : super(key: key);

  @override
  _ProfileAddressState createState() => _ProfileAddressState();
}

class _ProfileAddressState extends State<ProfileAddress> {
  @override
  void initState() {
    super.initState();
    getAllAddress();
    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var userProfileProvider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
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
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Address",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              TextButton(
                onPressed: () {
                  Get.to(() => ProfileAddAddress());
                },
                child: Row(
                  children: [
                    Icon(
                      FeatherIcons.plus,
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      "Add address",
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: userProfileProvider.allAddress.length,
                        itemBuilder: (context, index) {
                          return AddressCard(
                            id: userProfileProvider.allAddress[index]["_id"],
                            title: userProfileProvider.allAddress[index]
                                ["title"],
                            address: userProfileProvider.allAddress[index]
                                ["address"],
                          );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getAllAddress() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<UserProfileProvider>(context, listen: false)
        .getAllAddress();
    setState(() {
      _loading = false;
    });
  }
}
