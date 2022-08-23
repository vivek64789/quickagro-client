import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/categories.dart';
import 'package:quickagro/screens/coupons.dart';
import 'package:quickagro/screens/customer_support.dart';
import 'package:quickagro/screens/product_request.dart';
import 'package:quickagro/screens/top_deals.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/menu_button.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    var userProfileProvider = Provider.of<UserProfileProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(width * 0.03),
        width: width * 0.8,
        height: height,
        decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context).isDarkTheme
              ? Provider.of<ThemeProvider>(context).scaffoldColor
              : primaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(borderRadius),
            bottomRight: Radius.circular(borderRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    FeatherIcons.x,
                    color: white,
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: width * 0.07,
                      backgroundColor:
                          Provider.of<ThemeProvider>(context).isDarkTheme
                              ? primaryColor.withOpacity(0.5)
                              : white.withOpacity(0.5),
                      backgroundImage: userProfileProvider.profilePic == ""
                          ? null
                          : Image.network(userProfileProvider.profilePic).image,
                    ),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userProfileProvider.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: white,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.005,
                        ),
                        Text(
                          userProfileProvider.email,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: white.withOpacity(0.8),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                MenuButton(
                  () {
                    Get.to(
                      () => Categories(),
                    );
                  },
                  FeatherIcons.list,
                  "All categories",
                ),
                MenuButton(
                  () {
                    Get.to(
                      () => TopDeals(),
                    );
                  },
                  FeatherIcons.trendingUp,
                  "Top Deals",
                ),
                MenuButton(
                  () {
                    Get.to(
                      () => ProductRequest(),
                    );
                  },
                  FeatherIcons.fileText,
                  "Make product request",
                ),
                MenuButton(
                  () {
                    Get.to(
                      () => Coupons(),
                    );
                  },
                  Icons.card_giftcard,
                  "Coupons",
                ),
                MenuButton(
                  () {
                    Get.to(() => CustomerSupport());
                  },
                  FeatherIcons.messageCircle,
                  "Live Chat",
                ),
              ],
            ),
            Column(
              children: [
                MenuButton(
                  () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .changeTheme(
                      !Provider.of<ThemeProvider>(context, listen: false)
                          .isDarkTheme,
                    );
                  },
                  Provider.of<ThemeProvider>(context).isDarkTheme
                      ? FeatherIcons.sun
                      : FeatherIcons.moon,
                  Provider.of<ThemeProvider>(context).isDarkTheme
                      ? "Light Mode"
                      : "Dark Mode",
                  autoClose: false,
                ),
                MenuButton(
                  () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Log Out"),
                            content: Text("Are you sure, want to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "CANCEL",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  authProvider.logOut();
                                },
                                child: Text("LOG OUT"),
                              ),
                            ],
                          );
                        });
                  },
                  FeatherIcons.logOut,
                  "Logout",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
