import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TrackOrderRouteSpot extends StatelessWidget {
  final bool checked;
  final String title;
  final String subtitle;

  TrackOrderRouteSpot(this.checked, this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Row(
      children: [
        Icon(
          checked ? FeatherIcons.checkCircle : FeatherIcons.circle,
          color: checked ? Colors.green : Colors.grey,
          size: width * 0.05 * 2,
        ),
        SizedBox(
          width: width * 0.04,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 14.sp,
              ),
            ),
            subtitle == ""
                ? SizedBox.shrink()
                : Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: textColor.withOpacity(0.7),
                    ),
                  )
          ],
        ),
      ],
    );
  }
}
