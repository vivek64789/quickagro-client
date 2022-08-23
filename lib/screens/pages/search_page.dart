import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/search_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/search_results.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

TextEditingController _textController = TextEditingController();

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    Provider.of<SearchProvider>(context, listen: false).getSearchHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var searchProvider = Provider.of<SearchProvider>(context);

    return Container(
      padding: EdgeInsets.all(width * 0.02),
      height: height,
      width: width,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _textController,
                    onFieldSubmitted: (text) {
                      if (searchProvider.searchKeyword != "")
                        Get.to(() => SearchResults());
                    },
                    onChanged: (text) {
                      searchProvider.searchKeyword = text;
                    },
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: textColor,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(borderRadius)),
                      hintText: "Search products...",
                      hintStyle: TextStyle(
                        color: textColor.withOpacity(0.5),
                      ),
                      fillColor: textColor.withOpacity(0.1),
                      filled: true,
                      prefixIcon: Icon(
                        FeatherIcons.search,
                        color: textColor.withOpacity(0.5),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          _textController.clear();
                        },
                        icon: Icon(
                          FeatherIcons.xCircle,
                          color: primaryColor,
                        ),
                        tooltip: "Clear",
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  // SizedBox(height: height * 0.025),
                  // Text(
                  //   "Trending",
                  //   style: TextStyle(
                  //     color: textColor,
                  //     fontSize: 15.sp,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: height * 0.02),
                  // Wrap(
                  //   runSpacing: height * 0.01,
                  //   children: [
                  //     FilterChipButton(
                  //       title: SampleData().filters[0],
                  //       enabled: false,
                  //       onTap: () {},
                  //     ),
                  //     FilterChipButton(
                  //       title: SampleData().filters[1],
                  //       enabled: false,
                  //       onTap: () {},
                  //     ),
                  //     FilterChipButton(
                  //       title: SampleData().filters[2],
                  //       enabled: false,
                  //       onTap: () {},
                  //     ),
                  //     FilterChipButton(
                  //       title: SampleData().filters[3],
                  //       enabled: false,
                  //       onTap: () {},
                  //     ),
                  //     FilterChipButton(
                  //       title: SampleData().filters[4],
                  //       enabled: false,
                  //       onTap: () {},
                  //     ),
                  //     FilterChipButton(
                  //       title: SampleData().filters[4],
                  //       enabled: false,
                  //       onTap: () {},
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: height * 0.02),
                  searchProvider.searchHistory.length == 0
                      ? SizedBox.shrink()
                      : Text(
                          "Recent searches",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  SizedBox(height: height * 0.02),
                  Column(
                    children:
                        getRecentSearchTiles(searchProvider.searchHistory),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getRecentSearchTiles(List<String> searchHistory) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    List<Widget> widgets = [];
    for (int i = 0; i < searchHistory.length; i++) {
      widgets.add(
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: height * 0.005),
          onLongPress: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Delete Search History?"),
                    content: Text(
                        "Are you sure, want to delete '${searchHistory[i]}' from search history?"),
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
                          Provider.of<SearchProvider>(context, listen: false)
                              .deleteFromHistory(searchHistory[i]);
                          Get.back();
                        },
                        child: Text("DELETE"),
                      ),
                    ],
                  );
                });
          },
          onTap: () {
            Provider.of<SearchProvider>(context, listen: false)
                .changeSearchKeyword(searchHistory[i]);
            Get.to(() => SearchResults());
          },
          leading: Icon(
            Icons.history,
            color: textColor.withOpacity(0.7),
          ),
          title: Text(
            searchHistory[i],
            style: TextStyle(fontSize: 14.sp, color: textColor),
          ),
          trailing: IconButton(
            onPressed: () {
              _textController.text = searchHistory[i];
            },
            icon: Icon(
              FeatherIcons.arrowUpLeft,
              color: textColor.withOpacity(0.7),
            ),
          ),
        ),
      );
    }
    return widgets;
  }
}
