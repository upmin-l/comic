import 'package:comic/app_theme.dart';
import 'package:comic/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../index.dart';
import '../models.dart';

class Comic18Page extends GetView<HomePageController> {
  const Comic18Page({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomePageController(),
      id: 'comic18Page',
      builder: (_) {
        return Scaffold(
          body: Padding(
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
                    controller.getComic18Parameter.random = '';
                    controller.getComic18Parameter.page += 1;
                    controller.getComicList();
                  }
                }
                return true;
              },
              child: RefreshIndicator(
                color: AppColor.defaultColor,
                onRefresh: () async {
                  controller.comic18List.clear();
                  controller.getComic18Parameter.random = '1';
                  controller.getComicList();
                },
                child: CustomScrollView(
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
                        childCount: controller.comic18List.length,
                        (context, index) {
                          return GridViewList<Comic18Item>(
                            pathUrl: '/comicItem18Page',
                            item: controller.comic18List[index],
                            getName: (item) => item.name,
                            getTopicImg: (item) => item.pic,
                            getTypeNames: (item) => item.tags,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
