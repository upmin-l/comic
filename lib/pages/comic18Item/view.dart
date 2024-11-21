import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:comic/routers/index.dart';
import 'package:comic/utils/index.dart';
import 'package:comic/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../index.dart';

class Comic18ItemPage extends GetView<Comic18ItemPageController> {
  const Comic18ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      id: 'comic18ItemPage',
      init: Comic18ItemPageController(),
      builder: (_) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ComicItemHead<Comic18Item>(
                    getName: (item) => item.name,
                    comicItem: controller.comic18Item,
                    getTopicImg: (item) => item.pic,
                    getTage: (item) => item.tags,
                    comicInfoState: controller.comicInfoState,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    height: 80.h,
                    child: Text(
                      controller.comic18Item.content,
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
                                tabs: controller.tabs18,
                                labelColor: AppColor.red,
                                controller: controller.chapterTab18Controller,
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
                    tabContents: controller.tab18Contents,
                    onTap: (idx) {
                      // print(controller.chapterTab18Controller?.index);
                      // print((controller.chapterTab18Controller!.index)*20+idx);
                      if (controller.initPageController.isFirstTime) {
                        controller.goToComicReaderPage(idx);
                      } else {
                        BrunoDialog.showConfirmDialog(
                          context,
                          title: '提示',
                          msg: '为了您更好的体验，请进行登录再使用！',
                          confirm: '去登录',
                          tip: '温馨提示：登录后可以存储喜欢、阅读记录等功能',
                          onCancel: () => Navigator.pop(context),
                          onConfirm: () {
                            Navigator.pop(context);
                          },
                        );
                      }
                      // Get.toNamed(
                      //   RouteNames.comicReaderPage,
                      //   arguments: {
                      //     'comicChapters': controller.comic18Chapters,
                      //     'index':
                      //         (controller.chapterTab18Controller!.index) * 20 +
                      //             idx,
                      //     'type': true,
                      //     'comicInfoState': controller.comicInfoState,
                      //     'comic_id':controller.comic18Item.id,
                      //   },
                      // );
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              height: 60.h,
              // color: Colors.cyanAccent,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border,
                        size: 20, color: AppColor.defaultColor),
                    label: Text(
                      '收藏',
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColor.defaultColor),
                    ),
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory, // 取消水波纹效果
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print(controller.btnObj.value.href);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: AppColor.red2,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 30,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.sp),
                        child: Obx(
                          () => Text(
                            controller.btnObj.value.text,
                            style: titleStyle.copyWith(
                                fontSize: 16.sp, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
