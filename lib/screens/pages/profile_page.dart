import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickagro/providers/fingerprint_provider.dart';
import 'package:quickagro/providers/notification_provider.dart';
import 'package:quickagro/screens/my_cards.dart';
import 'package:quickagro/utils/get_responsive.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/screens/pages/profile_page/profile_address.dart';
import 'package:quickagro/screens/pages/profile_page/profile_change_password.dart';
import 'package:quickagro/screens/pages/profile_page/profile_phone.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/profile_detail_tile.dart';
import 'package:quickagro/widgets/profile_statistic.dart';
import 'package:provider/provider.dart';

bool _loading = false;
bool _uploadingProfilePic = false;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    Provider.of<FingerprintProvider>(context, listen: false)
        .getFingerprintSharedPreferences();
    Provider.of<FingerprintProvider>(context, listen: false).checkBiometrics();
    Provider.of<FingerprintProvider>(context, listen: false)
        .fetchAvailableBiometrics();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var userProfileProvider = Provider.of<UserProfileProvider>(context);
    bool isFingerprintEnabled =
        Provider.of<FingerprintProvider>(context).isFingerprintEnabled;

    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isAutoDarkTheme = themeProvider.isAutoDarkTheme;
    var fingerprintProvider = Provider.of<FingerprintProvider>(context);
    var notificationProvider = Provider.of<NotificationProvider>(context);

    return Container(
      padding: EdgeInsets.all(width * 0.02),
      height: height,
      width: width,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    FeatherIcons.chevronLeft,
                    color: textColor,
                  ),
                ),
                SizedBox(width: width * 0.02),
                Text(
                  "User Profile",
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
                  : RefreshIndicator(
                      onRefresh: () async {
                        await getData();
                      },
                      child: ListView(
                        children: [
                          SizedBox(
                            height: height * 0.04,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        primaryColor.withOpacity(0.4),
                                    radius: width * 0.1,
                                    child: _uploadingProfilePic
                                        ? CircularProgressIndicator()
                                        : SizedBox.shrink(),
                                    backgroundImage: userProfileProvider
                                                .profilePic ==
                                            ""
                                        ? null
                                        : Image.network(
                                                userProfileProvider.profilePic)
                                            .image,
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Tooltip(
                                      message: "Change Profile Photo",
                                      child: InkWell(
                                        onTap: () async {
                                          setState(() {
                                            _uploadingProfilePic = true;
                                          });
                                          await userProfileProvider
                                              .uploadProfilePic();
                                          setState(() {
                                            _uploadingProfilePic = false;
                                          });
                                        },
                                        borderRadius:
                                            BorderRadius.circular(width),
                                        child: Container(
                                          width: width * 0.075,
                                          height: width * 0.075,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            FeatherIcons.camera,
                                            color: white,
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                userProfileProvider.name,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.025,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ProfileStatistic(
                                value: userProfileProvider.stats["totalOrders"]
                                    .toString(),
                                label: "Orders",
                              ),
                              ProfileStatistic(
                                value: currencySymbol +
                                    userProfileProvider.stats["saved"]
                                        .toString(),
                                label: "Saved",
                              ),
                              ProfileStatistic(
                                value: currencySymbol +
                                    userProfileProvider.stats["spent"]
                                        .toString(),
                                label: "Spent",
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.04,
                          ),
                          Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            child: Column(
                              children: [
                                ProfileDetailTile(
                                  title: "Email",
                                  value: userProfileProvider.email,
                                ),
                                ProfileDetailTile(
                                  title: "Address",
                                  value: userProfileProvider.defaultAddress,
                                  onTap: () {
                                    Get.to(() => ProfileAddress());
                                  },
                                ),
                                ProfileDetailTile(
                                  title: "Phone number",
                                  value: userProfileProvider.phone,
                                  onTap: () {
                                    Get.to(() => ProfilePhone());
                                  },
                                ),
                                isMobile
                                    ? SizedBox(
                                        child: isFingerprintEnabled
                                            ? TextButton(
                                                child: Text(
                                                  "Disable Fingerprint",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                                onPressed: () async {
                                                  await fingerprintProvider
                                                      .authenticateUser();
                                                  var result =
                                                      fingerprintProvider
                                                          .isAuthenticated;
                                                  if (result) {
                                                    await Provider.of<
                                                                FingerprintProvider>(
                                                            context,
                                                            listen: false)
                                                        .disableFingerprint();

                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Fingerprint Disabled Successfully");
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Not Authenticated, Try Again");
                                                  }
                                                },
                                              )
                                            : TextButton(
                                                child:
                                                    Text("Enable Fingerprint"),
                                                onPressed: () async {
                                                  await fingerprintProvider
                                                      .authenticateUser();
                                                  var result =
                                                      fingerprintProvider
                                                          .isAuthenticated;
                                                  if (result) {
                                                    await Provider.of<
                                                                FingerprintProvider>(
                                                            context,
                                                            listen: false)
                                                        .enableFingerprint();

                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Fingerprint Enabled Successfully");
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Not Authenticated, Try Again");
                                                  }
                                                },
                                              ),
                                      )
                                    : Container(),
                                // SizedBox(
                                //   child: isAutoDarkTheme
                                //       ? TextButton(
                                //           onPressed: () async {
                                //             themeProvider
                                //                 .disableAutoDarkTheme();
                                //           },
                                //           child: Text(
                                //             "Disable Auto Dark Mode",
                                //             style: TextStyle(color: Colors.red),
                                //           ))
                                //       : TextButton(
                                //           onPressed: () async {
                                //             themeProvider.enableAutoDarkTheme();
                                //           },
                                //           child: Text(
                                //             "Enable Auto Dark Mode",
                                //           ),
                                //         ),
                                // ),
                                ProfileDetailTile(
                                  prefix: Padding(
                                    padding: EdgeInsets.only(
                                      right: width * 0.02,
                                    ),
                                    child: Icon(
                                      FeatherIcons.lock,
                                      color: textColor,
                                    ),
                                  ),
                                  value: "Change Password",
                                  onTap: () {
                                    Get.to(() => ProfileChangePassword());
                                  },
                                ),
                                ProfileDetailTile(
                                  prefix: Padding(
                                    padding: EdgeInsets.only(
                                      right: width * 0.02,
                                    ),
                                    child: Icon(
                                      FeatherIcons.creditCard,
                                      color: textColor,
                                    ),
                                  ),
                                  value: "Select Default Payment Card",
                                  onTap: () {
                                    Get.to(() => MyCards());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  getData() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<UserProfileProvider>(context, listen: false).getProfile();
    await Provider.of<UserProfileProvider>(context, listen: false).getStats();
    setState(() {
      _loading = false;
    });
  }
}
