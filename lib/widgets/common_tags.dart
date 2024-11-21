import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CommonTags extends StatelessWidget {
  /// tags 标签组件
  final double fontSize;
  final bool isShowBg;
  final double withOpacity;
  final List<TagsItem> nameArr;

  const CommonTags({
    required this.nameArr,
    this.fontSize = 8,
    this.isShowBg = true,
    this.withOpacity =0.2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        nameArr.length,
        (index) {
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Container(
              decoration: BoxDecoration(
                color: isShowBg
                    ? Color(nameArr[index].color).withOpacity(withOpacity)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Padding(
                  padding: isShowBg
                      ? EdgeInsets.symmetric(vertical: 2.w, horizontal: 4.h)
                      : EdgeInsets.only(right: 4.w),
                  child: Text(
                    nameArr[index].title,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Color(nameArr[index].color),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
