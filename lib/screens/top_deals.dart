import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/search_results.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/cart_items_fab.dart';
import 'package:quickagro/widgets/bundle_card.dart';
import 'package:quickagro/widgets/product_list_card.dart';
import 'package:provider/provider.dart';

class TopDeals extends StatefulWidget {
  @override
  _TopDealsState createState() => _TopDealsState();
}

class _TopDealsState extends State<TopDeals> {
  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CartItemsFAB(),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          "Top Deals",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => SearchResults());
                      },
                      icon: Icon(
                        FeatherIcons.search,
                        color: textColor,
                      ),
                      tooltip: "Search",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, top: width * 0.02),
                      child: Text(
                        "Bundles",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      height: height * 0.3,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: dataProvider.bundles.length,
                        itemBuilder: (context, index) {
                          return BundleCard(
                            bundleId: dataProvider.bundles[index]["_id"],
                            title: dataProvider.bundles[index]["title"],
                            subtitle: dataProvider.bundles[index]["subtitle"],
                            description: dataProvider.bundles[index]
                                ["description"],
                            price:
                                dataProvider.bundles[index]["price"].toString(),
                            image: dataProvider.bundles[index]["image"],
                            stock:
                                dataProvider.bundles[index]["stock"].toString(),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.04, top: width * 0.02),
                      child: Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.02, left: width * 0.04),
                      child: Column(
                        children: getProductListCardWidgets(
                            dataProvider.popularProducts),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getProductListCardWidgets(List<dynamic> products) {
    List<Widget> widgets = [];
    for (int i = 0; i < products.length; i++) {
      widgets.add(
        ProductListCard(
          false,
          productId: products[i]["_id"],
          title: products[i]["title"],
          weight: products[i]["weight"],
          description: products[i]["description"],
          price: products[i]["price"].toString(),
          images: products[i]["images"],
          stock: products[i]["stock"].toString(),
        ),
      );
    }
    return widgets;
  }
}
