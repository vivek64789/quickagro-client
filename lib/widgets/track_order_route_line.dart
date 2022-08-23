import 'package:flutter/material.dart';
import 'package:quickagro/utils/size.dart';

class TrackOrderRouteLine extends StatelessWidget {
  final bool enabled;

  TrackOrderRouteLine(this.enabled);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width * 0.05 * 2,
          alignment: Alignment.center,
          child: Container(
            height: height * 0.04,
            width: width * 0.01,
            decoration: BoxDecoration(
                color: enabled ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(borderRadius)),
          ),
        ),
      ],
    );
  }
}
