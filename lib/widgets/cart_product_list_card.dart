import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CartProductListCard extends StatefulWidget {
  final String productId;
  final String title;
  final String weight;
  final String price;
  final int quantity;
  final String image;
  final Function(DismissDirection) onDismissed;

  CartProductListCard({
    required this.productId,
    required this.onDismissed,
    required this.title,
    required this.weight,
    required this.price,
    required this.quantity,
    required this.image,
  });

  @override
  _CartProductListCardState createState() => _CartProductListCardState();
}

class _CartProductListCardState extends State<CartProductListCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;

    return Dismissible(
      key: Key(widget.productId),
      onDismissed: widget.onDismissed,
      background: Container(
        padding: EdgeInsets.only(right: width * 0.05),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Icon(
          Icons.delete,
          color: white,
        ),
      ),
      direction: DismissDirection.endToStart,
      child: Container(
        margin: EdgeInsets.only(bottom: height * 0.015, right: width * 0.04),
        padding: EdgeInsets.all(width * 0.025),
        decoration: BoxDecoration(
          color: scaffoldColor,
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
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(borderRadius / 2)),
                  width: width * 0.2,
                  height: width * 0.2,
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
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
                      width: width * 0.4,
                      child: Text(
                        widget.title,
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
                    Row(
                      children: [
                        Text(
                          widget.weight,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          " x ${widget.quantity}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
            Text(
              currencySymbol +
                  (int.parse(widget.price) * widget.quantity).toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
