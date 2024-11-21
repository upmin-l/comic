import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTop extends StatelessWidget {
  final void Function() onTap;
  final String isType;
  final Color boxDecorationColor;

  const SearchTop({
    this.boxDecorationColor = AppColor.search,
    super.key,
    this.isType = 'comic',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: _search(),
        ),
      ],
    );
  }

  Widget _search() {
    return Container(
      height: 25.h,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: boxDecorationColor,
        borderRadius: BorderRadius.circular(22.0),
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        borderRadius: BorderRadius.circular(22.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 2.0),
              child: Icon(
                Icons.search_sharp,
                size: 18.w,
                color: AppColor.gray,
              ),
            ),
            Text(
              '搜索关键词',
              style: TextStyle(fontSize: 14.sp, color: AppColor.gray),
            )
          ],
        ),
      ),
    );
  }
}
