import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/utils/get_responsive.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/cart.dart';
import 'package:quickagro/screens/product_image_view.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/currency_country.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/small_product_card.dart';
import 'package:quickagro/widgets/small_square_button.dart';
import 'package:provider/provider.dart';

bool _loadingRelatedProducts = false;
int _currentImageIndex = 0;
int _quantity = 0;

class ProductDetails extends StatefulWidget {
  final String productId;
  final String title;
  final String weight;
  final String price;
  final String description;
  final List<dynamic> images;
  final String stock;
  final bool isBundle;

  ProductDetails(
      {required this.productId,
      required this.title,
      required this.weight,
      required this.price,
      required this.description,
      required this.images,
      required this.stock,
      required this.isBundle});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    _currentImageIndex = 0;
    getRelatedProducts();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _quantity = Provider.of<CartProvider>(context, listen: false)
          .getQuantity(widget.productId);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.to(() => Cart());
                          },
                          icon: Icon(
                            FeatherIcons.shoppingBag,
                            color: primaryColor,
                          ),
                          tooltip: "Cart",
                        ),
                        cartProvider.cartItems["items"].length == 0
                            ? SizedBox.shrink()
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      isTablet ? width * 0.145 : width * 0.045,
                                  height:
                                      isTablet ? width * 0.45 : width * 0.045,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    cartProvider.cartItems["items"].length
                                        .toString(),
                                    style: TextStyle(
                                        color: white, fontSize: 10.sp),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => ProductImageView(widget.images));
                },
                child: Container(
                  height: height * 0.4,
                  child: CarouselSlider(
                      items: widget.images
                          .map((e) => CachedNetworkImage(
                                imageUrl: e,
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: 400,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        scrollDirection: Axis.horizontal,
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.images.asMap().entries.map((entry) {
                  return Container(
                    width: 12.0,
                    height: 12.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == entry.key
                            ? primaryColor
                            : Colors.grey),
                  );
                }).toList(),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: scaffoldColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(borderRadius * 2),
                      topRight: Radius.circular(borderRadius * 2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          physics: BouncingScrollPhysics(),
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.6,
                                      child: Text(
                                        widget.title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    widget.weight == ""
                                        ? SizedBox.shrink()
                                        : Row(
                                            children: [
                                              Text(
                                                "Qty: ",
                                                style: TextStyle(
                                                  color: textColor
                                                      .withOpacity(0.7),
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                              Text(
                                                widget.weight,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  color: textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      currencySymbol + widget.price,
                                      style: TextStyle(
                                        fontSize: 19.sp,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
                                    ),
                                    int.parse(widget.stock.toString()) <= 0
                                        ? SizedBox.shrink()
                                        : Row(
                                            children: [
                                              SmallSquareButton(
                                                  FeatherIcons.minus, () {
                                                cartProvider.subtractFromCart(
                                                    widget.productId);
                                                setState(() {
                                                  if (_quantity > 0) {
                                                    _quantity--;
                                                  }
                                                });
                                              }),
                                              SizedBox(width: width * 0.015),
                                              Text(
                                                _quantity.toString(),
                                                style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: width * 0.015),
                                              SmallSquareButton(
                                                  FeatherIcons.plus, () {
                                                cartProvider.addToCart(
                                                    widget.productId,
                                                    widget.title,
                                                    widget.weight,
                                                    widget.price,
                                                    widget.stock,
                                                    widget.images,
                                                    widget.isBundle);
                                                setState(() {
                                                  _quantity++;
                                                });
                                              }),
                                            ],
                                          ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: textColor),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            Text(
                              widget.description,
                              style: TextStyle(
                                height: 1.5,
                                fontSize: 12.sp,
                                color: textColor.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            widget.isBundle
                                ? SizedBox.shrink()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Related Products",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Container(
                                        height: height * 0.15,
                                        child: _loadingRelatedProducts
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : ListView(
                                                physics:
                                                    BouncingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                children:
                                                    getRelatedProductsWidgets(),
                                              ),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                      int.parse(widget.stock.toString()) <= 0
                          ? Text(
                              "Out of Stock",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12.sp,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(width * 0.02),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () {
                                    cartProvider.addToCart(
                                        widget.productId,
                                        widget.title,
                                        widget.weight,
                                        widget.price,
                                        widget.stock,
                                        widget.images,
                                        widget.isBundle);
                                    setState(() {
                                      _quantity++;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    primary: Colors.red[900],
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.symmetric(
                                      vertical: height * 0.015,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(borderRadius),
                                    ),
                                  ),
                                  child: _quantity != 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SmallSquareButton(
                                              FeatherIcons.minus,
                                              () {
                                                cartProvider.subtractFromCart(
                                                    widget.productId);
                                                setState(() {
                                                  if (_quantity > 0) {
                                                    _quantity--;
                                                  }
                                                });
                                              },
                                              color: white,
                                            ),
                                            SizedBox(width: width * 0.015),
                                            Text(
                                              _quantity.toString(),
                                              style: TextStyle(
                                                color: white,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: width * 0.015),
                                            SmallSquareButton(
                                              FeatherIcons.plus,
                                              () {
                                                cartProvider.addToCart(
                                                    widget.productId,
                                                    widget.title,
                                                    widget.weight,
                                                    widget.price,
                                                    widget.stock,
                                                    widget.images,
                                                    widget.isBundle);
                                                setState(() {
                                                  _quantity++;
                                                });
                                              },
                                              color: white,
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "Add to Cart",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getRelatedProductsWidgets() {
    List<Widget> widgets = [];
    var dataProvider = Provider.of<DataProvider>(context, listen: false);
    for (var product in dataProvider.relatedProducts) {
      widgets.add(SmallProductCard(product));
    }
    return widgets;
  }

  getRelatedProducts() async {
    if (widget.isBundle) return;
    setState(() {
      _loadingRelatedProducts = true;
    });

    await Provider.of<DataProvider>(context, listen: false)
        .fetchRelatedProducts(widget.productId);

    setState(() {
      _loadingRelatedProducts = false;
    });
  }
}
