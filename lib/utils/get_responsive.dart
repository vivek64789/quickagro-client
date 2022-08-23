import 'package:quickagro/utils/size.dart';

bool isMobile = width.toInt() < height.toInt() ? true : false;
bool isWatch = width.toInt() == height.toInt() ? true : false;
// bool isTablet = width.toInt() > 600 && width.toInt() < 1000 ? true : false;
bool isTablet = width.toInt() > height.toInt() ? true : false;
bool isDesktop = width.toInt() > 1000 ? true : false;
