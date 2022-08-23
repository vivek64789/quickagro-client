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
import 'package:quickagro/widgets/error_message_widget.dart';
import 'package:quickagro/widgets/filter_chip.dart';
import 'package:quickagro/widgets/product_list_card.dart';
import 'package:quickagro/widgets/search_filter.dart';
import 'package:provider/provider.dart';

bool _loading = false;

TextEditingController _textController = TextEditingController();

class SearchResults extends StatefulWidget {
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  void initState() {
    super.initState();
    searchProducts();
    _textController.text =
        Provider.of<SearchProvider>(context, listen: false).searchKeyword;
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var searchProvider = Provider.of<SearchProvider>(context);

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
                    tooltip: "Back",
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      onFieldSubmitted: (text) {
                        Provider.of<SearchProvider>(context, listen: false)
                            .changeSearchKeyword(text);
                        searchProducts();
                      },
                      onChanged: (text) {
                        Provider.of<SearchProvider>(context, listen: false)
                            .changeSearchKeyword(text);
                      },
                      autofocus: false,
                      textInputAction: TextInputAction.search,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(borderRadius),
                        ),
                        fillColor: textColor.withOpacity(0.1),
                        filled: true,
                        prefixIcon: Icon(
                          FeatherIcons.search,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.02),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SearchFilter();
                        },
                      );
                    },
                    icon: Icon(
                      FeatherIcons.filter,
                      color: primaryColor,
                    ),
                    tooltip: "Search Filter",
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: width * 0.02,
                        left: width * 0.02,
                        bottom: width * 0.02,
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: getFilterChipWidgets(),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    !searchProvider.isSearched ||
                            searchProvider.loading ||
                            _loading
                        ? SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(left: width * 0.02),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${searchProvider.searchResults.length} Product${searchProvider.searchResults.length > 1 ? "s" : ""} found for '${searchProvider.searchKeyword}' ${searchProvider.selectedCategoryIndex == 0 ? "" : " in " + searchProvider.filterQuery["category.name"]}",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    (searchProvider.priceFrom == -1 ||
                            searchProvider.priceFrom == -1)
                        ? SizedBox.shrink()
                        : !searchProvider.isSearched
                            ? SizedBox.shrink()
                            : Padding(
                                padding: EdgeInsets.only(
                                  left: width * 0.02,
                                  top: height * 0.01,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Price Range from $currencySymbol${searchProvider.priceFrom} to $currencySymbol${searchProvider.priceTo}",
                                        style: TextStyle(
                                          color: textColor.withOpacity(0.7),
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    SizedBox(height: height * 0.01),
                    _loading || searchProvider.loading
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : !searchProvider.isSearched
                            ? Center(
                                child: Text(
                                "Search for Products",
                                style: TextStyle(
                                    color: textColor, fontSize: 12.sp),
                              ))
                            : searchProvider.searchResults.length == 0
                                ? ErrorMessageWidget(
                                    animPath:
                                        'assets/animations/404-page-not-found.json',
                                    title: "No results found",
                                    description:
                                        "Sorry the products you are looking for doesn't exist or can't be found",
                                    actionTitle: "Search Again",
                                    onTapAction: () {},
                                    showActionButton: false,
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount:
                                          searchProvider.searchResults.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.01),
                                          child: ProductListCard(false,
                                              productId: searchProvider
                                                  .searchResults[index]["_id"],
                                              title: searchProvider.searchResults[index]
                                                  ["title"],
                                              weight: searchProvider.searchResults[index]
                                                  ["weight"],
                                              description: searchProvider.searchResults[index]
                                                  ["description"],
                                              price: searchProvider
                                                  .searchResults[index]["price"]
                                                  .toString(),
                                              images: searchProvider.searchResults[index]
                                                  ["images"],
                                              stock: searchProvider
                                                  .searchResults[index]["stock"]
                                                  .toString()),
                                        );
                                      },
                                    ),
                                  ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              Map newQuery = searchProvider.filterQuery;
              newQuery.remove("category.name");
              searchProvider.changeFilterQuery(newQuery);
            } else {
              Map newQuery = searchProvider.filterQuery;
              newQuery["category.name"] =
                  dataProvider.categories[i - 1]["name"];
              searchProvider.changeFilterQuery(newQuery);
            }
            searchProducts();
          },
        ),
      );
    }
    return widgets;
  }

  searchProducts() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<SearchProvider>(context, listen: false).searchProducts();
    setState(() {
      _loading = false;
    });
  }
}
