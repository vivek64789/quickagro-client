import 'package:flutter/material.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/size.dart';

class ChatImage extends StatelessWidget {
  final bool isSender;
  final String imageURL;

  ChatImage({
    this.isSender = true,
    this.imageURL = "",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: height * 0.01),
          width: width * 0.25,
          decoration: BoxDecoration(
            color: isSender
                ? primaryColor.withOpacity(0.4)
                : Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image.network(
              imageURL,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
