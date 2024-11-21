import 'package:comic/app_theme.dart';
import 'package:comic/routers/index.dart';
import 'package:comic/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../index.dart';

class ComicItemPage extends GetView<ComicItemPageController> {
  const ComicItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ComicItemPageController(),
      id: "comicItemPage",
      builder: (_) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ComicItemHead<ComicItem>(
                    getName: (item) => item.name,
                    comicItem: controller.comicItem,
                    getTopicImg: (item) => item.topic_img,
                    getTage: (item) => item.type_names,
                    comicInfoState: controller.comicInfoState,
                    updateTimeLabel: controller.comicUpdateTimeLabel,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    height: 80.h,
                    child: Text(
                      controller.comicInfoName,
                      style: TextStyle(color: AppColor.gray, fontSize: 12.sp),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '全部章节',
                              style: TextStyle(
                                color: AppColor.red,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        controller.isLoading
                            ? Container()
                            : BcTab(
                                tabs: controller.tabs,
                                labelColor: AppColor.red,
                                controller: controller.chapterTabController,
                                labelPadding: 5,
                                fontSize: 12.sp,
                                onTap: (index) {
                                  // controller.handleGetData(index);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Announce(
                    content: '注意：章节数量包含番外、公告等，不存在数据错乱问题，请放心观看！',
                    isLoading: controller.isLoading,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ComicItemChapterBox(
                    tabContents: controller.tabContents,
                    onTap: (idx) {
                      Get.toNamed(
                        RouteNames.comicReaderPage,
                        arguments: {
                          'comicChapters':controller.comicChapters,
                          'type':false,
                          'index':(controller.chapterTabController!.index)*20+idx,
                          'comic_id':controller.comicItem.comic_id,
                          'comicInfoState':controller.comicInfoState
                        },
                      );
                    },
                  ),
                )
              ],
            ),
            bottomNavigationBar: Container(
              height: 40.h,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.red.withOpacity(0.5),
                    offset: const Offset(0.0, 8.0),
                    // 阴影模糊半径
                    blurRadius: 30.0,
                    // 阴影扩散半径
                    spreadRadius: 5.0,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add,
                      size: 20.sp,
                    ),
                    label: Text(
                      '收藏',
                      style: titleStyle.copyWith(
                          fontSize: 14.sp, color: AppColor.defaultColor),
                    ),
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory, // 取消水波纹效果
                      alignment: Alignment.center, // 让 icon 和 label 居中对齐
                    ),
                  )
                ],
              ),
            ),
            // body: ClipPath(
            //   clipper: BezierClipper(),
            //   child: Container(
            //     color: Colors.deepOrange,
            //     height: 300,
            //   ),
            // ),
          ),
        );
      },
    );
  }
}
