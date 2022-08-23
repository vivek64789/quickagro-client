import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/screens/cart.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartItemsFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      onPressed: () {
        Get.to(() => Cart());
      },
      label: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Row(
          children: [
            Icon(
              FeatherIcons.shoppingBag,
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Text(
              "${Provider.of<CartProvider>(context).cartItems['items'].length} items in cart",
              style: TextStyle(fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }
}
