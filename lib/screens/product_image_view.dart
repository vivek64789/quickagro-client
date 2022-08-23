import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

int _currentImageIndex = 0;

class ProductImageView extends StatefulWidget {
  final List<dynamic> images;

  ProductImageView(this.images);

  @override
  _ProductImageViewState createState() => _ProductImageViewState();
}

class _ProductImageViewState extends State<ProductImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: width,
      height: height,
      color: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      FeatherIcons.chevronLeft,
                      color: white,
                    ),
                    tooltip: "Back",
                  ),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Text(
                    "Product Image",
                    style: TextStyle(
                      color: white,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  InteractiveViewer(
                    child: Container(
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: widget.images[_currentImageIndex],
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_currentImageIndex != 0) {
                              setState(() {
                                _currentImageIndex--;
                              });
                            }
                          },
                          icon: Icon(
                            FeatherIcons.chevronLeft,
                            color: white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_currentImageIndex !=
                                widget.images.length - 1) {
                              setState(() {
                                _currentImageIndex++;
                              });
                            }
                          },
                          icon: Icon(
                            FeatherIcons.chevronRight,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                    height: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${_currentImageIndex + 1} / ${widget.images.length}",
                          style: TextStyle(
                            color: white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
