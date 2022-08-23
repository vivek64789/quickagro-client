import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/masked_text_input.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/credit_card.dart';
import 'package:provider/provider.dart';

int _currentCarouselIndex = 0;

class MyCards extends StatefulWidget {
  @override
  _MyCardsState createState() => _MyCardsState();
}

class _MyCardsState extends State<MyCards> {
  @override
  void initState() {
    _currentCarouselIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  SizedBox(width: width * 0.02),
                  Text(
                    "My Cards",
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Container(
                      height: height * 0.25,
                      child: CarouselSlider(
                        items: getCreditCardWidgets(),
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
                              _currentCarouselIndex = index;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [1, 2, 3].asMap().entries.map((entry) {
                        return Container(
                          width: 12.0,
                          height: 12.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCarouselIndex == entry.key
                                  ? primaryColor
                                  : Colors.grey),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add New Card",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Text(
                            "Cardholder Name",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              fillColor: textColor.withOpacity(0.1),
                              filled: true,
                            ),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(
                            "Card Number",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextField(
                            style: TextStyle(
                              color: textColor,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              fillColor: textColor.withOpacity(0.1),
                              filled: true,
                            ),
                            inputFormatters: [
                              MaskedTextInputFormatter(
                                mask: 'xxxx-xxxx-xxxx-xxxx',
                                separator: '-',
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "MM-YY",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    TextField(
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14.sp,
                                      ),
                                      decoration: InputDecoration(
                                        fillColor: textColor.withOpacity(0.1),
                                        filled: true,
                                      ),
                                      inputFormatters: [
                                        MaskedTextInputFormatter(
                                          mask: 'xx-xx',
                                          separator: '-',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: width * 0.04,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "CVV",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    TextField(
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14.sp,
                                      ),
                                      decoration: InputDecoration(
                                        fillColor: textColor.withOpacity(0.1),
                                        filled: true,
                                      ),
                                      inputFormatters: [
                                        MaskedTextInputFormatter(
                                          mask: 'xxx',
                                          separator: '-',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (x) {},
                              ),
                              Text(
                                "Set as default payment card",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {},
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
                              child: Text(
                                "Save Card",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 14.sp,
                                ),
                              ),
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
      ),
    );
  }

  List<Widget> getCreditCardWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < 3; i++) {
      List<String> _cardNumbers = [
        "**** **** **** 2359",
        "**** **** **** 2358",
        "**** **** **** 3244",
      ];
      List<String> _cardHolderNames = [
        "Bibekanand Kushwaha",
        "Vivek Singh",
        "Bibek Kushwaha"
      ];
      List<Color> _colors = [primaryColor, Colors.blue, Colors.orange];

      widgets.add(
        CreditCard(
          cardNumber: _cardNumbers[i],
          cardHolderName: _cardHolderNames[i],
          validTill: "07/25",
          color: _colors[i],
        ),
      );
    }
    return widgets;
  }
}
