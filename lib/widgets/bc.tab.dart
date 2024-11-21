import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BcTab extends StatelessWidget {
  final void Function(int index)? onTap;
  final List<Widget> tabs;
  TabController? controller;
  final double fontSize;
  final double boxHeight;
  final double labelPadding;
  final Color labelColor;

    BcTab({
    super.key,
    required this.tabs,
    this.controller,
    this.fontSize = 14,
    this.boxHeight = 30,
    this.labelPadding = 10,
    this.labelColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: boxHeight.h,
      child: TabBar(
        tabs: tabs,
        controller: controller,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        labelColor: labelColor,
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsets.symmetric(horizontal: labelPadding.w),
        labelStyle:
            TextStyle(fontSize: fontSize.sp, fontWeight: FontWeight.bold),
        unselectedLabelColor: Colors.grey.shade400,
        unselectedLabelStyle: TextStyle(fontSize: fontSize.sp),
        onTap: (index) {
          if (onTap != null) onTap!(index);
        },
      ),
    );
  }
}


Tab customTab(String text,String key) {
  return Tab(
    key: ValueKey(key), // 使用字符串作为 Key
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: AppColor.search,
        borderRadius: BorderRadius.circular(8), // 如果需要圆角
      ),
      child: Text(text),
    ),
  );
}