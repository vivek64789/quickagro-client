import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/search_results.dart';
// import 'package:quickagro/utils/sample_data.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/cart_items_fab.dart';
// import 'package:quickagro/widgets/filter_chip.dart';
import 'package:quickagro/widgets/product_list_card.dart';
import 'package:provider/provider.dart';

bool _loading = false;

class CategoryProducts extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  CategoryProducts(this.categoryId, this.categoryName);

  @override
  _CategoryProductsState createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  @override
  void initState() {
    fetchCategoryProducts();
    super.initState();
  }

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
                          widget.categoryName,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: textColor,
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
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : dataProvider.categoryProducts.length == 0
                        ? Center(
                            child: Text("No products in this category",
                                style: TextStyle(color: textColor)))
                        : ListView.builder(
                            padding: EdgeInsets.only(
                                top: width * 0.02, left: width * 0.04),
                            physics: BouncingScrollPhysics(),
                            itemCount: dataProvider.categoryProducts.length,
                            itemBuilder: (context, index) {
                              return ProductListCard(
                                false,
                                productId: dataProvider.categoryProducts[index]
                                    ["_id"],
                                title: dataProvider.categoryProducts[index]
                                    ["title"],
                                weight: dataProvider.categoryProducts[index]
                                    ["weight"],
                                description: dataProvider
                                    .categoryProducts[index]["description"],
                                price: dataProvider.categoryProducts[index]
                                        ["price"]
                                    .toString(),
                                images: dataProvider.categoryProducts[index]
                                    ["images"],
                                stock: dataProvider.categoryProducts[index]
                                        ["stock"]
                                    .toString(),
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

  // List<Widget> getFilterChipWidgets() {
  //   List<Widget> widgets = [];
  //   for (int i = 0; i < SampleData().filters.length; i++) {
  //     widgets.add(
  //       FilterChipButton(
  //         title: SampleData().filters[i],
  //         enabled: i == 0,
  //         onTap: () {},
  //       ),
  //     );
  //   }
  //   return widgets;
  // }

  fetchCategoryProducts() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<DataProvider>(context, listen: false)
        .fetchCategoryProducts(widget.categoryId);
    setState(() {
      _loading = false;
    });
  }
}
