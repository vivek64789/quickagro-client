import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final bool isSender;
  final String message;

  ChatBubble({
    this.isSender = true,
    this.message = "",
  });

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    return Padding(
      padding: EdgeInsets.only(bottom: height * 0.01),
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Bubble(
            padding: BubbleEdges.all(width * 0.02),
            margin: BubbleEdges.only(top: 10),
            alignment: isSender ? Alignment.topRight : Alignment.topLeft,
            nip: isSender ? BubbleNip.rightTop : BubbleNip.leftTop,
            elevation: 0,
            color: isSender
                ? primaryColor.withOpacity(0.4)
                : Colors.grey.withOpacity(0.2),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 9.sp,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
