import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Announce extends StatelessWidget {
  /// 公共提示组件
  final bool isLoading;
  final String content;
  final Color? color;
  const Announce({
    required this.content,
    required this.isLoading,
    this.color = AppColor.red,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            margin: EdgeInsets.only(bottom: 6.h),
            decoration: BoxDecoration(color: color?.withOpacity(0.2)),
            child: Text(
              content,
              style: TextStyle(fontSize: 11.sp, color: color),
            ),
          );
  }
}
