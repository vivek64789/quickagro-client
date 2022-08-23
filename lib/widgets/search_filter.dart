import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/search_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/filter_chip.dart';
import 'package:provider/provider.dart';

bool _expandSortBy = false;

TextEditingController _priceFromController = new TextEditingController();
TextEditingController _priceToController = new TextEditingController();

class SearchFilter extends StatefulWidget {
  @override
  _SearchFilterState createState() => _SearchFilterState();
}

class _SearchFilterState extends State<SearchFilter> {
  @override
  void initState() {
    var searchProvider = Provider.of<SearchProvider>(context, listen: false);
    bool isPriceFilterValid =
        searchProvider.priceFrom != -1 && searchProvider.priceTo != -1;
    _priceFromController.text =
        isPriceFilterValid ? searchProvider.priceFrom.toString() : "";
    _priceToController.text =
        isPriceFilterValid ? searchProvider.priceTo.toString() : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;
    var searchProvider = Provider.of<SearchProvider>(context, listen: false);

    return Container(
      color: scaffoldColor,
      width: width,
      height: height * 0.7,
      padding: EdgeInsets.all(width * 0.02),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  FeatherIcons.x,
                  color: textColor,
                ),
              ),
              Text(
                "Filter",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textColor,
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      searchProvider.resetFilters();
                      _priceFromController.text = "";
                      _priceToController.text = "";
                    },
                    style: TextButton.styleFrom(
                      primary: primaryColor,
                    ),
                    child: Text(
                      "Reset",
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: height * 0.02,
          ),
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                AnimatedSize(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  duration: Duration(milliseconds: 200),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _expandSortBy = !_expandSortBy;
                          });
                        },
                        highlightColor: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(borderRadius),
                        child: Container(
                          padding: EdgeInsets.all(width * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(borderRadius),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Sort By",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    searchProvider.sortBy == "popularity"
                                        ? "Popularity"
                                        : searchProvider.sortBy == "pricelth"
                                            ? "Price - Low to High"
                                            : searchProvider.sortBy ==
                                                    "pricehtl"
                                                ? "Price - High to Low"
                                                : "None",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: textColor,
                                    ),
                                  ),
                                  Icon(
                                    _expandSortBy
                                        ? FeatherIcons.chevronUp
                                        : FeatherIcons.chevronDown,
                                    color: textColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      _expandSortBy
                          ? Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Provider.of<SearchProvider>(context,
                                            listen: false)
                                        .setSortBy("popularity");
                                  },
                                  leading: searchProvider.sortBy == "popularity"
                                      ? Icon(FeatherIcons.check,
                                          color: primaryColor)
                                      : SizedBox.shrink(),
                                  title: Text("Popularity"),
                                ),
                                ListTile(
                                  onTap: () {
                                    Provider.of<SearchProvider>(context,
                                            listen: false)
                                        .setSortBy("pricelth");
                                  },
                                  leading: searchProvider.sortBy == "pricelth"
                                      ? Icon(FeatherIcons.check,
                                          color: primaryColor)
                                      : SizedBox.shrink(),
                                  title: Text("Price - Low to High"),
                                ),
                                ListTile(
                                  onTap: () {
                                    Provider.of<SearchProvider>(context,
                                            listen: false)
                                        .setSortBy("pricehtl");
                                  },
                                  leading: searchProvider.sortBy == "pricehtl"
                                      ? Icon(FeatherIcons.check,
                                          color: primaryColor)
                                      : SizedBox.shrink(),
                                  title: Text("Price - High to Low"),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Text(
                  "Price Range",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceFromController,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          searchProvider.changePriceFrom(int.parse(text));
                        },
                        decoration: InputDecoration(
                          hintText: "From",
                          fillColor: textColor.withOpacity(0.1),
                          filled: true,
                          prefixText: currencySymbol,
                          prefixStyle: TextStyle(color: textColor),
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _priceToController,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          searchProvider.changePriceTo(int.parse(text));
                        },
                        decoration: InputDecoration(
                          fillColor: textColor.withOpacity(0.1),
                          filled: true,
                          hintText: "To",
                          prefixText: currencySymbol,
                          prefixStyle: TextStyle(
                            color: textColor,
                          ),
                          hintStyle: TextStyle(
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.04,
                ),
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Wrap(
                    runSpacing: height * 0.01,
                    children: getFilterChipWidgets()),
                SizedBox(
                  height: height * 0.02,
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () async {
                Get.back();
                Provider.of<SearchProvider>(Get.context!, listen: false)
                    .setLoading(true);
                await searchProvider.searchProducts();
                Provider.of<SearchProvider>(Get.context!, listen: false)
                    .setLoading(false);
              },
              style: TextButton.styleFrom(
                primary: Colors.red[900],
                backgroundColor: primaryColor,
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.015,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              child: Text(
                "Apply Filter",
                style: TextStyle(
                  color: white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getFilterChipWidgets() {
    var searchProvider = Provider.of<SearchProvider>(context);
    var dataProvider = Provider.of<DataProvider>(context, listen: false);
    List<Widget> widgets = [];
    for (int i = 0; i < dataProvider.categories.length + 1; i++) {
      widgets.add(
        FilterChipButton(
          title: i == 0 ? "All" : dataProvider.categories[i - 1]["name"],
          enabled: i == searchProvider.selectedCategoryIndex,
          onTap: () {
            searchProvider.changeCategoryIndex(i);
            searchProvider.filterQuery = {};
            if (i == 0) {
              searchProvider.filterQuery.remove("category.name");
            } else {
              searchProvider.filterQuery["category.name"] =
                  dataProvider.categories[i - 1]["name"];
            }
            // Provider.of<SearchProvider>(context, listen: false).searchProducts(
            //     _searchKeyword == "" ? widget.keyword : _searchKeyword,
            //     searchProvider.filterQuery);
          },
        ),
      );
    }
    return widgets;
  }
}
