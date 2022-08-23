import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchProvider extends ChangeNotifier {
  bool loading = false;
  bool isSearched = false;
  List<dynamic> searchResults = [];
  List<String> searchHistory = [];

  String searchKeyword = "";

  int selectedCategoryIndex = 0;
  Map filterQuery = {};

  int priceFrom = -1;
  int priceTo = -1;

  String sortBy = "popularity";

  setLoading(bool state) {
    loading = state;
    notifyListeners();
  }

  setSortBy(String newSortBy) {
    sortBy = newSortBy;
    notifyListeners();
  }

  resetAll() {
    searchKeyword = "";
    isSearched = false;
    filterQuery = {};
    selectedCategoryIndex = 0;
    priceFrom = -1;
    priceTo = -1;
    sortBy = "";
  }

  resetFilters() {
    filterQuery = {};
    selectedCategoryIndex = 0;
    priceFrom = -1;
    priceTo = -1;
    sortBy = "";
    notifyListeners();
  }

  changePriceFrom(int price) {
    priceFrom = price;
    notifyListeners();
  }

  changePriceTo(int price) {
    priceTo = price;
    notifyListeners();
  }

  changeSearchKeyword(String newKeyword) {
    searchKeyword = newKeyword;
  }

  changeFilterQuery(Map newQuery) {
    filterQuery = newQuery;
  }

  changeCategoryIndex(int newIndex) {
    selectedCategoryIndex = newIndex;
    notifyListeners();
  }

  getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    searchHistory = prefs.getStringList("searchHistory") == null
        ? []
        : prefs.getStringList("searchHistory")!;
    notifyListeners();
  }

  setSearchHistory() async {
    if (!searchHistory.contains(searchKeyword) && searchKeyword != "") {
      searchHistory = searchHistory.reversed.toList();
      searchHistory.add(searchKeyword);
      searchHistory = searchHistory.reversed.toList();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("searchHistory", searchHistory.toList());
  }

  deleteFromHistory(String keyword) async {
    searchHistory.remove(keyword);
    await setSearchHistory();
    await getSearchHistory();
    Fluttertoast.showToast(
      msg: "Search history deleted",
      backgroundColor: primaryColor,
    );
  }

  searchProducts() async {
    isSearched = true;
    if (searchKeyword == "") {
      resetAll();
      return;
    }
    if (priceFrom != -1 && priceTo != -1) {
      filterQuery["price"] = {"\$lt": priceTo + 1, "\$gt": priceFrom - 1};
    }
    await setSearchHistory();
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;
    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-Type": "application/json"
    };
    Map<String, dynamic> body = {
      "keyword": searchKeyword,
      "query": filterQuery,
      "sortBy": sortBy
    };
    var response = await http.post(
      Uri.parse("$serverUrl/products/search"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      searchResults = jsonDecode(response.body);
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong", backgroundColor: primaryColor);
    }
    getSearchHistory();
    notifyListeners();
  }
}
