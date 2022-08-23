import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/utils/get_responsive.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/bundles.dart';
import 'package:quickagro/screens/notices.dart';
import 'package:quickagro/screens/products.dart';
import 'package:quickagro/screens/search_results.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:quickagro/widgets/category_card.dart';
import 'package:quickagro/widgets/bundle_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/product_list_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:proximity_sensor/proximity_sensor.dart';

bool _loadingCategories = false;
bool _loadingBundles = false;
bool _loadingProducts = false;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    if (Provider.of<DataProvider>(context, listen: false).categories.length ==
        0) {
      getData();
    }
    listenProximitySensor();
    super.initState();
    _loadingCategories = false;
    _loadingBundles = false;
    _loadingProducts = false;
  }

  Future<void> listenProximitySensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  _refreshContent() async {
    _loadingBundles = true;
    _loadingCategories = true;
    _loadingProducts = true;
    await getData();
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var dataProvider = Provider.of<DataProvider>(context);
    _isNear ? _refreshContent() : "";
    return Container(
      padding: EdgeInsets.only(left: width * 0.02, top: width * 0.02),
      height: height,
      width: width,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: Icon(
                          FeatherIcons.menu,
                          color: textColor,
                        ),
                        tooltip: "Menu",
                      ),
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.02),
                          child: IconButton(
                            onPressed: () {
                              Get.to(() => Notices());
                            },
                            icon: Icon(
                              FeatherIcons.bell,
                              color: textColor,
                            ),
                            tooltip: "Notices",
                          ),
                        ),
                        dataProvider.notices["seen"]
                            ? SizedBox.shrink()
                            : Positioned(
                                top: width * 0.015,
                                right: width * 0.025,
                                child: Container(
                                  width: width * 0.015,
                                  height: width * 0.015,
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(borderRadius)),
                                ),
                              ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.02),
                      child: IconButton(
                        onPressed: () {
                          Get.to(() => SearchResults());
                        },
                        icon: Icon(
                          FeatherIcons.search,
                          color: textColor,
                        ),
                        tooltip: "Search",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: height * 0.01),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await getData();
                },
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Get your ",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  color: textColor,
                                ),
                              ),
                              Text(
                                "Fresh Vegetables",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                  color: textColor,
                                ),
                              )
                            ],
                          ),
                          Text(
                            "delivered quickly",
                            style: TextStyle(
                              fontSize: 17.sp,
                              color: textColor,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: isTablet ? height * 0.3 : height * 0.15,
                      child: _loadingCategories
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: dataProvider.categories.length,
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                  dataProvider.categories[index]["_id"],
                                  dataProvider.categories[index]["name"],
                                  dataProvider.categories[index]["image"],
                                  key: Key("categoryCard" + index.toString()),
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.02, top: width * 0.02),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: width * 0.02),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Bundle Offers",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                      primary: primaryColor),
                                  onPressed: () {
                                    Get.to(() => Bundles());
                                  },
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: isTablet ? height * 0.5 : height * 0.28,
                            child: _loadingBundles
                                ? Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dataProvider.bundles.length,
                                    itemBuilder: (context, index) {
                                      return BundleCard(
                                        bundleId: dataProvider.bundles[index]
                                            ["_id"],
                                        title: dataProvider.bundles[index]
                                            ["title"],
                                        subtitle: dataProvider.bundles[index]
                                            ["subtitle"],
                                        description: dataProvider.bundles[index]
                                            ["description"],
                                        price: dataProvider.bundles[index]
                                                ["price"]
                                            .toString(),
                                        image: dataProvider.bundles[index]
                                            ["image"],
                                        stock: dataProvider.bundles[index]
                                                ["stock"]
                                            .toString(),
                                      );
                                    },
                                  ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Popular",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: width * 0.02),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: primaryColor),
                                  onPressed: () {
                                    Get.to(() => Products());
                                  },
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          _loadingProducts
                              ? Center(child: CircularProgressIndicator())
                              : Column(
                                  children: getProductListCards(
                                      dataProvider.popularProducts),
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

  List<Widget> getProductListCards(List<dynamic> products) {
    List<Widget> widgets = [];
    for (int i = 0; i < products.length; i++) {
      widgets.add(
        ProductListCard(
          true,
          productId: products[i]["_id"],
          title: products[i]["title"],
          weight: products[i]["weight"],
          description: products[i]["description"],
          price: products[i]["price"].toString(),
          stock: products[i]["stock"].toString(),
          images: products[i]["images"],
        ),
      );
    }
    return widgets;
  }

  getData() async {
    setState(() {
      _loadingBundles = true;
      _loadingProducts = true;
      _loadingCategories = true;
    });
    await Provider.of<DataProvider>(context, listen: false).fetchNotices();
    await Provider.of<DataProvider>(context, listen: false).fetchCategories();
    setState(() {
      _loadingCategories = false;
    });
    await Provider.of<DataProvider>(context, listen: false).fetchBundles();
    setState(() {
      _loadingBundles = false;
    });
    await Provider.of<DataProvider>(context, listen: false)
        .fetchPopularProducts();
    setState(() {
      _loadingProducts = false;
    });
  }
}
