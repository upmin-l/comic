import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


/// 漫画章节 组件
class ComicItemChapterBox extends StatelessWidget {
  final List<ComicChapterListItem> tabContents;
  final Function(int index) onTap; // 添加回调参数
  const ComicItemChapterBox({
    required this.tabContents,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.cyanAccent,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      height: 140.h,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 5,
          mainAxisSpacing: 12,
          childAspectRatio: 4,
        ),
        itemCount: tabContents.length,
        itemBuilder: (context, idx) {
          return InkWell(
            onTap: ()=>onTap(idx),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[200]),
              child: Text(
                tabContents[idx].text,
                style: TextStyle(fontSize: 10.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
