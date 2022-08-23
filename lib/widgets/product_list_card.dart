import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/utils/get_responsive.dart';
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

class ProductListCard extends StatelessWidget {
  final String productId;
  final String title;
  final String description;
  final String price;
  final String weight;
  final List<dynamic> images;
  final String stock;
  final bool greyCard;

  ProductListCard(
    this.greyCard, {
    required this.productId,
    required this.title,
    required this.description,
    required this.price,
    required this.weight,
    required this.images,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var cartProvider = Provider.of<CartProvider>(context);

    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.015, right: width * 0.04),
      child: InkWell(
        onTap: () {
          Get.to(() => ProductDetails(
                productId: productId,
                title: title,
                description: description,
                weight: weight,
                price: price,
                images: images,
                stock: stock,
                isBundle: false,
              ));
        },
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: EdgeInsets.all(width * 0.025),
          decoration: BoxDecoration(
            color: greyCard ? Colors.grey.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(width * 0.02),
                    decoration: BoxDecoration(
                        color: greyCard ? white : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(borderRadius / 2)),
                    width: width * 0.2,
                    height: width * 0.2,
                    child: CachedNetworkImage(
                      imageUrl: images[0],
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.45,
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.005),
                      Text(
                        weight,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: isTablet ? height * 0.2 : height * 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currencySymbol + price,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SmallSquareButton(FeatherIcons.plus, () async {
                      await cartProvider.addToCart(
                        productId,
                        title,
                        weight,
                        price,
                        stock,
                        images,
                        false,
                      );
                      Get.snackbar("Product added to Cart!",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
