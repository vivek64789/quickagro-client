import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:quickagro/widgets/product_list_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool _loading = false;

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: width * 0.02,
          left: width * 0.04,
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
                    "All Products",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: dataProvider.products.length,
                        itemBuilder: (context, index) {
                          return ProductListCard(
                            true,
                            productId: dataProvider.products[index]["_id"],
                            title: dataProvider.products[index]["title"],
                            weight: dataProvider.products[index]["weight"],
                            description: dataProvider.products[index]
                                ["description"],
                            price: dataProvider.products[index]["price"]
                                .toString(),
                            stock: dataProvider.products[index]["stock"]
                                .toString(),
                            images: dataProvider.products[index]["images"],
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

  fetchProducts() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<DataProvider>(context, listen: false).fetchProducts();
    setState(() {
      _loading = false;
    });
  }
}
