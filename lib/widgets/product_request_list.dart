import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProductRequestList extends StatelessWidget {
  final int number;
  final String title;
  final bool showTextField;
  final Function onChanged;
  final Function onDelete;

  ProductRequestList(
      {this.number = 0,
      this.title = "",
      this.showTextField = false,
      required this.onChanged,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: width * 0.065,
                height: width * 0.065,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(borderRadius / 2),
                ),
                child: Text(
                  "$number",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.03,
              ),
              showTextField
                  ? SizedBox.shrink()
                  : Text(
                      title,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    )
            ],
          ),
          showTextField
              ? Expanded(
                  child: TextField(
                    onChanged: (text) {
                      onChanged(text);
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                      fillColor: textColor.withOpacity(0.1),
                      filled: true,
                      hintText: "Enter item",
                      hintStyle: TextStyle(
                        color: textColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
          showTextField
              ? SizedBox.shrink()
              : IconButton(
                  onPressed: () {
                    onDelete();
                  },
                  icon: Icon(
                    FeatherIcons.xCircle,
                    color: Colors.red,
                  ),
                  tooltip: "Delete item",
                ),
        ],
      ),
    );
  }
}
