import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductListCardMini extends StatelessWidget {
  final String title;
  final String weight;
  final String price;
  final List<dynamic> images;

  ProductListCardMini({
    required this.title,
    required this.weight,
    required this.price,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.015),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.015),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(borderRadius / 2)),
                width: width * 0.12,
                height: width * 0.12,
                child: CachedNetworkImage(
                  imageUrl: images[0],
                  filterQuality: FilterQuality.high,
                ),
              ),
              SizedBox(
                width: width * 0.022,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width * 0.5,
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    weight,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: textColor.withOpacity(0.7),
                    ),
                  )
                ],
              ),
            ],
          ),
          Text(
            currencySymbol + price,
            style: TextStyle(
              color: textColor,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
