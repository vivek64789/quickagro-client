import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/cart.dart';
import 'package:quickagro/screens/product_details.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:quickagro/widgets/small_square_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BundleCard extends StatelessWidget {
  final String bundleId;
  final String title;
  final String subtitle;
  final String description;
  final String price;
  final String image;
  final String stock;

  BundleCard({
    required this.bundleId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.image,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;
    var cartProvider = Provider.of<CartProvider>(context);

    return GestureDetector(
      onTap: () {
        Get.to(() => ProductDetails(
              productId: bundleId,
              title: title,
              description: description,
              weight: "",
              price: price,
              images: [image],
              stock: this.stock,
              isBundle: true,
            ));
      },
      child: Container(
        margin: EdgeInsets.only(
          right: width * 0.025,
          left: width * 0.015,
          bottom: width * 0.04,
          top: width * 0.02,
        ),
        decoration: BoxDecoration(
          color: scaffoldColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 12,
                offset: Offset(0, 4)),
          ],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        width: width * 0.47,
        child: Padding(
          padding: EdgeInsets.all(width * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(width * 0.01),
                    width: double.infinity,
                    height: height * 0.12,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(borderRadius / 2),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: image,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.007,
                  ),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencySymbol + price,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SmallSquareButton(FeatherIcons.plus, () async {
                    await cartProvider.addToCart(
                      bundleId,
                      title,
                      "",
                      price,
                      stock,
                      [image],
                      true,
                    );
                    Get.snackbar("Bundle added to Cart!",
                        "+1 '$title' added to cart!\n\nTotal Items: ${cartProvider.cartItems["items"].length}\nTotal Price: $currencySymbol${cartProvider.cartItems["totalPrice"]}",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: primaryColor,

                        // dismissDirection: SnackDismissDirection.HORIZONTAL,
                        colorText: white, onTap: (x) {
                      Get.to(() => Cart());
                    });
                  }),
                ],
              ),
              SizedBox(
                height: height * 0.0005,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
