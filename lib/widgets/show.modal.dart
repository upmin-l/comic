import 'package:comic/app_theme.dart';
import 'package:comic/public.models.dart';
import 'package:comic/widgets/common_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowModal extends StatefulWidget {
  final void Function(int idx) onEvent;
  final int index;
  final  List<ComicChapterListItem> comicChapters;
  final String comicInfoState;
  const ShowModal({
    required this.index,
    required this.onEvent,
    required this.comicChapters,
    this.comicInfoState ='未知',
    super.key,
  });
  @override
  State<ShowModal> createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  late int currIndex;

  @override
  void initState() {
    super.initState();
    currIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8.sp),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        // print('123');
                      },
                      child: Row(
                        children: [
                          Text(
                            widget.comicInfoState,
                            style: titleStyle.copyWith(fontSize: 14.sp),
                          ),
                          SizedBox(width: 12.w),
                          CommonTags(
                            withOpacity: 0.2,
                            nameArr: [
                              TagsItem(title: '永久免费无广告', color: 0xff02d402),
                            ],
                            fontSize: 10.sp,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('正在开发！'),
                                  duration: Duration(seconds: 2), // 显示时长
                                ),
                              ),
                          icon: Icon(
                            Icons.swap_vert,
                            color: AppColor.defaultColor,
                            size: 18.sp,
                          ),
                          label: Text(
                            '正序',
                            style: TextStyle(
                                color: AppColor.defaultColor, fontSize: 12.sp),
                          ),
                          style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory, // 取消水波纹效果
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.close),
                          iconSize: 24,
                          color: AppColor.defaultColor,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    )
                  ],
                ),
                subtitle: Text('阅读至22章 | 共${widget.comicChapters.length}章节'),
              ),
            ),
            const Divider(height: 3, color: AppColor.lightGray),
            Expanded(
              child: Scrollbar(
                child: GridView.builder(
                  padding: EdgeInsets.only(top: 0, bottom: 10.sp),
                  itemCount: widget.comicChapters.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4,
                  ),
                  itemBuilder: (BuildContext context, int idx) {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          currIndex = idx;
                        });
                        widget.onEvent(idx);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 4.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currIndex==idx? AppColor.red2.withOpacity(0.3):Colors.grey[200]),
                        child: Text(
                          widget.comicChapters[idx].text,
                          style: TextStyle(fontSize: 10.sp,color: currIndex==idx? AppColor.red:Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



