import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/app_theme.dart';
import 'package:comic/widgets/show.modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'controller.dart';

class ComicReaderPage extends GetView<ComicReaderPageController> {
  const ComicReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ComicReaderPageController(),
      id: 'comicReaderPage',
      builder: (_) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark),
          child:  Scaffold(
            body: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.handleShowMenu();
                  },
                  child: Scrollbar(
                    controller: controller.scrollController,
                    child: ListView.builder(
                      controller: controller.scrollController,
                      itemCount: controller.comicListImg.length,
                      itemBuilder: (context, index) {
                        return CachedNetworkImage(
                          imageUrl: controller.comicListImg[index],
                          fit: BoxFit.fitWidth,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          placeholder: (context, index) {
                            return SizedBox(
                              height: 200,
                              child: Center(
                                child: LoadingAnimationWidget
                                    .horizontalRotatingDots(
                                  color: const Color(0xFF1A1A3F),
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                    position: controller.menuBottomAnimationProgress,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          comicMenuBottomItem(
                              controller.comicReaders.prve, Icons.arrow_back,
                              onTap: () {
                            controller.onPreviousPage();
                          }),
                          comicMenuBottomItem('目录', Icons.list, onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.w),
                                  topRight: Radius.circular(20.w),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return ShowModal(
                                  index: controller.index,
                                  comicChapters:controller.comicChapters,
                                  comicInfoState: controller.comicInfoState,
                                  onEvent: (idx) {
                                    controller.onEvent(idx);
                                  },
                                );
                              },
                            );
                          }),
                          comicMenuBottomItem('日间', Icons.light_mode,
                              onTap: () {
                            // SmartDialog.showToast('正在开发。。。',
                            //     alignment: Alignment.topCenter);
                          }),
                          comicMenuBottomItem('收藏', Icons.light_mode,
                              onTap: () {
                            // SmartDialog.showToast('正在开发。。。',
                            //     alignment: Alignment.topCenter);
                          }),
                          comicMenuBottomItem(
                            controller.comicReaders.msg,
                            Icons.arrow_forward,
                            onTap: () {
                              controller.onNextPage();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  // child: comicMenuBottom(
                  //     menuBottomOnTap: menuBottomOnTap, context: context)),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SlideTransition(
                      position: controller.menuTopAnimationProgress,
                      child: comicMenuTop(context,
                          controller.comicChapters[controller.index].text)),
                ),
                if (controller.isLoading)
                  Container(
                    color: Colors.white.withOpacity(0.8),
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: LoadingAnimationWidget.hexagonDots(
                        color: AppColor.defaultColor,
                        size: 40,
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget comicMenuBottomItem(String title, IconData icon,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Icon(icon),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(fontSize: 12.sp),
            )
          ],
        ),
      ),
    );
  }

  Widget comicMenuTop(BuildContext context, String chapterName) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 20,
            ),
            color: AppColor.defaultColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Text(
              chapterName,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
