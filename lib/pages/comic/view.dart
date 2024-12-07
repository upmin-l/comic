import 'package:comic/app_theme.dart';
import 'package:comic/routers/index.dart';
import 'package:comic/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'index.dart';
import 'widgets/modal.list.dart';

class ComicPage extends GetView<ComicPageController> {
  const ComicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ComicPageController(),
      id: 'comicPage',
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 54.h,
            titleSpacing: 3,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 3, left: 8),
                      // 后续添加线路
                      child: InkWell(
                        onTap: () {
                          // controller.addFromJs();
                        },
                        child: Text(
                          '线路',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SearchTop(
                        isType: 'comic',
                        onTap: () {
                          Get.toNamed(RouteNames.searchPage);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 25.h,
                        width: MediaQuery.of(context).size.width * 0.9,
                        color: Colors.white,
                        child: BcTab(
                          tabs: [
                            customTab('全部'),
                            customTab('玄幻'),
                            customTab('恋爱'),
                            customTab('后宫'),
                            customTab('古风'),
                            customTab('大女主'),
                            customTab('穿越'),
                          ],
                          labelColor: controller.currentLabelColor,
                          controller: controller.topTabController,
                          labelPadding: 5,
                          fontSize: 12.sp,
                          onTap: (index) {
                            controller.handleGetData(index);
                          },
                        )),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.w),
                                  topRight: Radius.circular(20.w)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return ModalList(
                                comicShowModeList: controller.comicShowModeList,
                                comicParameter: controller.getComicParameter,
                                onTap: (region, type) {
                                  controller.handleFilter(region, type);
                                },
                              );
                            },
                          );
                          // showModal(context,modalList(controller.comicShowModeList));
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.expand_more,
                              color: AppColor.defaultColor),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: controller.comicPageLoading
              ? Container(
                  color: Colors.white.withOpacity(0.2),
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: LoadingAnimationWidget.hexagonDots(
                      color: AppColor.defaultColor,
                      size: 40,
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 5.h),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollStartNotification ||
                          scrollNotification is ScrollUpdateNotification) {
                        // 用户正在滚动，可以在这里处理逻辑
                      } else if (scrollNotification is ScrollEndNotification) {
                        // 用户滚动结束，可以在这里处理逻辑
                        if (scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                          // 滚动到底部，加载更多数据
                          controller.getComicParameter.page++;
                          controller.getComicList();
                        }
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      color: AppColor.defaultColor,
                      onRefresh: () async {
                        // controller.comicList =
                        //     pickRandomComicItems(controller.comicList, 36).toList();
                        // await Future.delayed(const Duration(seconds: 2));
                        // controller.initData();
                      },
                      child: CustomScrollView(
                        controller: controller.comicScrollController,
                        slivers: [
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.6,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 3.0,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              childCount: controller.comicList.length,
                              (context, index) {
                                return GridViewList<ComicItem>(
                                  pathUrl: '/comicItemPage',
                                  item: controller.comicList[index],
                                  getName: (item) => item.name,
                                  getTopicImg: (item) => item.topic_img,
                                  getTypeNames: (item) => item.type_names,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            // splashColor: Colors.cyanAccent,
            backgroundColor: Colors.white,
            // elevation: 0,
            onPressed: () {
              controller.comicScrollController.jumpTo(0);
            },
            child: Align(
              child: Icon(
                Icons.rocket,
                color: AppColor.defaultColor,
                size: 30.sp,
              ),
            ),
          ),
        );
      },
    );
  }

  Tab customTab(String text) {
    return Tab(
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
}
