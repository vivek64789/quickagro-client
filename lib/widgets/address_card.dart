import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/providers/user_profile_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddressCard extends StatelessWidget {
  final String id;
  final String title;
  final String address;
  final bool showRadio;
  final bool showDelete;
  final bool isSelected;
  final Function onTap;

  AddressCard(
      {this.id = "",
      this.title = "",
      this.address = "",
      this.showRadio = false,
      this.showDelete = true,
      this.isSelected = false,
      this.onTap = x});

  static x() {}

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var scaffoldColor = Provider.of<ThemeProvider>(context).scaffoldColor;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: width * 0.03,
          horizontal: width * 0.02,
        ),
        margin: EdgeInsets.only(bottom: height * 0.015),
        decoration: BoxDecoration(
          color: scaffoldColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 12,
            ),
          ],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showRadio
                    ? Radio(
                        value: isSelected ? 1 : 0,
                        groupValue: 1,
                        onChanged: (x) {
                          onTap();
                        },
                      )
                    : SizedBox(
                        width: width * 0.02,
                      ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    SizedBox(
                      width: width * 0.6,
                      child: Text(
                        address,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            showDelete
                ? Material(
                    color: scaffoldColor,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Delete Address"),
                                content: Text(
                                    "Are you sure, want to delete '$title' address?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      "CANCEL",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Provider.of<UserProfileProvider>(
                                              context,
                                              listen: false)
                                          .removeAddress(id);
                                      Get.back();
                                    },
                                    child: Text(
                                      "DELETE",
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        FeatherIcons.trash,
                        color: Colors.red,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
