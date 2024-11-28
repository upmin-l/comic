import 'package:comic/app_theme.dart';
import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models.dart';

class ModalList extends StatefulWidget {
  final void Function(String currRegion, String currType) onTap; // 国家 分类
  final ComicShowMode comicShowModeList;
  final GetComicParameter comicParameter;
  const ModalList({
    super.key,
    required this.comicShowModeList,
    required this.comicParameter,
    required this.onTap,
  });

  @override
  State<ModalList> createState() => _ModalListState();
}

class _ModalListState extends State<ModalList> {
  String currRegion = '';
  String currType = '';

  @override
  void initState() {
    super.initState();
    currRegion = widget.comicParameter.region;
    currType = widget.comicParameter.type;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 30.h,
        backgroundColor: Colors.white,
        centerTitle: true,
        title:
            Text('筛选', style: TextStyle(fontSize: 14.sp, color: Colors.black)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.expand_more,
            color: AppColor.defaultColor,
            size: 30.sp,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 8.sp),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text('国家', style: titleStyle.copyWith(fontSize: 14.sp)),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  childCount: widget.comicShowModeList.countryList.length,
                  (context, index) {
                return InkWell(
                  onTap: () {
                    // widget.onCountryTap(
                    //     // widget.comicShowModeList.countryList[index]),
                    setState(() {
                      currRegion =
                          widget.comicShowModeList.countryList[index].region;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          widget.comicShowModeList.countryList[index].region ==
                                  currRegion
                              ? AppColor.red2.withOpacity(0.3)
                              : AppColor.lightGray,
                      borderRadius: BorderRadius.circular(8), // 如果需要圆角
                    ),
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
                    child: Text(
                      widget.comicShowModeList.countryList[index].name,
                      style: TextStyle(
                        color: widget.comicShowModeList.countryList[index]
                                    .region ==
                                currRegion
                            ? AppColor.red2
                            : AppColor.defaultColor,
                      ),
                    ),
                  ),
                );
              }),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text('分类', style: titleStyle.copyWith(fontSize: 14.sp)),
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                childCount: widget.comicShowModeList.classifyList.length,
                (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        currType =
                            widget.comicShowModeList.classifyList[index].region;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.comicShowModeList.classifyList[index]
                                    .region ==
                                currType
                            ? AppColor.red2.withOpacity(0.3)
                            : AppColor.lightGray,
                        borderRadius: BorderRadius.circular(8), // 如果需要圆角
                      ),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.sp, vertical: 4.sp),
                      child: Text(
                        widget.comicShowModeList.classifyList[index].name,
                        style: TextStyle(
                          color: widget.comicShowModeList.classifyList[index]
                                      .region ==
                                  currType
                              ? AppColor.red2
                              : AppColor.defaultColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xffeaeaea), // 边框颜色
              width: 0.5, // 边框宽度
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.lightGray,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Text(
                    '取消',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: AppColor.gray),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  widget.onTap(currRegion, currType);
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColor.defaultColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Text(
                    '确定',
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
