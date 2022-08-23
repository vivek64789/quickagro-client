import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/product_details.dart';
import 'package:quickagro/utils/size.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallProductCard extends StatelessWidget {
  final Map productDetails;
  SmallProductCard(this.productDetails);

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return InkWell(
      onTap: () {
        Get.back();
        Get.to(() => ProductDetails(
            productId: productDetails["_id"],
            title: productDetails["title"],
            weight: productDetails["weight"],
            price: productDetails["price"].toString(),
            description: productDetails["description"],
            images: productDetails["images"],
            stock: productDetails["stock"].toString(),
            isBundle: false));
      },
      child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(width * 0.01),
              width: width * 0.1,
              height: width * 0.1,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: CachedNetworkImage(
                imageUrl: productDetails["images"][0],
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(
              width: width * 0.15,
              child: Text(
                productDetails["title"],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
