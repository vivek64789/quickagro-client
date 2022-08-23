import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/data_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Notices extends StatefulWidget {
  @override
  _NoticesState createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  @override
  void initState() {
    Provider.of<DataProvider>(context, listen: false).updateNoticeSeen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
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
                  ),
                  SizedBox(width: width * 0.02),
                  Text(
                    "Notices",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Provider.of<DataProvider>(context)
                            .notices["notices"]
                            ?.length ==
                        0
                    ? Center(child: Text("No notices"))
                    : RefreshIndicator(
                        onRefresh: () async {
                          await Provider.of<DataProvider>(context,
                                  listen: false)
                              .fetchNotices();
                        },
                        child: ListView.builder(
                          itemCount: dataProvider.notices["notices"].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(width * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dataProvider.notices["notices"][index]
                                          ["title"],
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      dataProvider.notices["notices"][index]
                                          ["body"],
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.02),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dataProvider.notices["notices"][index]
                                                      ["createdOn"]
                                                  .split("T")[1]
                                                  .split(".")[0]
                                                  .split(":")[0] +
                                              ":" +
                                              dataProvider.notices["notices"]
                                                      [index]["createdOn"]
                                                  .split(":")[1],
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          dataProvider.notices["notices"][index]
                                                  ["createdOn"]
                                              .split("T")[0],
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: height * 0.01),
                                    Divider(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
