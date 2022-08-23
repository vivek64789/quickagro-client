import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/cart.dart';
import 'package:quickagro/screens/pages/order_history_page.dart';
import 'package:quickagro/screens/pages/home_page.dart';
import 'package:quickagro/screens/pages/search_page.dart';
import 'package:quickagro/widgets/drawer.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'pages/profile_page.dart';
import 'package:shake/shake.dart';
import 'package:light/light.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ShakeDetector? detector;
  String _luxString = 'Unknown';
  late Light _light;
  late StreamSubscription _subscription;

  @override
  void initState() {
    Provider.of<ThemeProvider>(context, listen: false).loadTheme();
    Provider.of<DataProvider>(context, listen: false).updateFirebaseToken();
    initPlatformState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: () => {
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
                      Provider.of<AuthProvider>(context, listen: false)
                          .logOut();
                    },
                    child: Text("LOG OUT"),
                  ),
                ],
              );
            })
      },
    );

    // Notifications
    AwesomeNotifications().initialize(
      "resource://drawable/logo", // icon for your app notification
      [
        NotificationChannel(
          channelGroupKey: 'basic_tests',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
          enableLights: true,
          enableVibration: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_tests', channelGroupName: 'Basic tests'),
      ],
    );
    super.initState();
  }

  void onData(int luxValue) async {
    bool isAutoDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).isAutoDarkTheme;
    if (isAutoDarkTheme) {
      setState(() {
        _luxString = "$luxValue";
      });
    }
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    bool isAutoDarkTheme =
        Provider.of<ThemeProvider>(context, listen: false).isAutoDarkTheme;
    try {
      if (isAutoDarkTheme) {
        if (int.parse(_luxString) > 80) {
          Provider.of<ThemeProvider>(context, listen: false).changeTheme(false);
        } else {
          Provider.of<ThemeProvider>(context, listen: false).changeTheme(true);
        }
      }
    } catch (e) {
      return Center(child: CircularProgressIndicator());
    }
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Exit App?"),
                      content: Text("Are you sure, want to exit?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text(
                              "CANCEL",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            )),
                        TextButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: Text("EXIT"),
                        ),
                      ]);
                }) ??
            false;
      },
      child: Scaffold(
        drawer: MenuDrawer(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          tooltip: "Cart",
          backgroundColor: primaryColor,
          onPressed: () {
            Get.to(() => Cart());
          },
          child: Icon(FeatherIcons.shoppingBag),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Provider.of<ThemeProvider>(context).scaffoldColor,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 10.sp,
          ),
          unselectedItemColor: textColor,
          currentIndex: _currentPageIndex,
          elevation: 0,
          selectedItemColor: primaryColor,
          onTap: (int index) {
            _pageController.jumpToPage(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                FeatherIcons.home,
                key: Key('NavIconHome'),
              ),
              // label: "Home $_luxString",
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.search, key: Key('NavIconSearch')),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.fileText, key: Key('NavIconOrders')),
              label: "Orders",
            ),
            BottomNavigationBarItem(
              icon: Icon(FeatherIcons.user, key: Key('NavIconProfile')),
              label: "Profile",
            ),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 4,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _pages[index];
          },
        ),
      ),
    );
  }

  int _currentPageIndex = 0;

  PageController _pageController = new PageController();

  List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    OrderHistoryPage(),
    ProfilePage()
  ];
}
