import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ThemeData themeData = ThemeData(
  useMaterial3: false,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
  highlightColor: const Color.fromRGBO(1, 0, 0, 0.0),
  //去掉tabBar默认选中效果
  splashColor: const Color.fromRGBO(1, 0, 0, 0.0),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'FZDaLTJ',
      fontWeight: FontWeight.bold,
      fontSize: 12.sp,
    ),
  ),
  //tabBar 样式
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black,
    indicator: null,
    unselectedLabelStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'FZDaLTJ',
    ),
    labelStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'FZDaLTJ',
    ),
  ),
);

final TextStyle titleStyle = TextStyle(
  fontSize: 10.sp,
  fontFamily: 'FZDaLTJ',
  fontWeight: FontWeight.bold,
);

class AppColor {
  static const Color defaultColor = Color(0xFF3e4784);

  static const Color bul = Color(0xff6b52e8);
//#fe6756
  static const Color red = Color(0xFFec5766);

  static const Color red2 = Color(0xfffe6756);

  static const Color gray = Color(0xFF888888);

  static const Color videoPrimary = Color(0xff161616);

  static const Color search = Color(0xfff7f7f7); //搜索框颜色

  static const Color yel = Color(0xfffddd20);

  static const Color lightGray = Color(0xfff5f6f8);

  static const pink = Color(0xffee9da8);

  static const green =Color(0xff02d402);
}
