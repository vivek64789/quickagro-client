import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/bundle_card.dart';
import 'package:provider/provider.dart';

class Bundles extends StatefulWidget {
  @override
  _BundlesState createState() => _BundlesState();
}

class _BundlesState extends State<Bundles> {
  @override
  void initState() {
    super.initState();
    Provider.of<DataProvider>(context, listen: false).fetchBundles();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(
          width * 0.02,
        ),
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
                    "All Bundles",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: (5 / 6),
                  children: getBundleCards(dataProvider.bundles),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getBundleCards(List<dynamic> bundles) {
    List<Widget> widgets = [];
    for (int i = 0; i < bundles.length; i++) {
      widgets.add(BundleCard(
        bundleId: bundles[i]["_id"],
        title: bundles[i]["title"],
        subtitle: bundles[i]["subtitle"],
        description: bundles[i]["description"],
        price: bundles[i]["price"].toString(),
        image: bundles[i]["image"],
        stock: bundles[i]["stock"].toString(),
      ));
    }
    return widgets;
  }
}
