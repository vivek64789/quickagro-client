import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/category_products.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryCard extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final String image;

  CategoryCard(this.categoryId, this.categoryName, this.image, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Provider.of<ThemeProvider>(context).isDarkTheme;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;

    return Padding(
      padding: EdgeInsets.all(width * 0.015),
      child: InkWell(
        onTap: () {
          Get.to(() => CategoryProducts(categoryId, categoryName));
        },
        highlightColor: primaryColor,
        splashColor: primaryColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width * 0.2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: scaffoldColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(borderRadius)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: width * 0.1,
                height: width * 0.1,
                child: CachedNetworkImage(
                  filterQuality: FilterQuality.high,
                  imageUrl: image,
                ),
              ),
              SizedBox(
                height: height * 0.005,
              ),
              SizedBox(
                height: height * 0.04,
                child: Text(
                  categoryName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color:
                          isDarkTheme ? white.withOpacity(0.9) : primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
