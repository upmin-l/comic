import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/app_theme.dart';
import 'package:comic/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:get/get.dart';

import 'common_tags.dart';

class GridViewList<T> extends StatelessWidget {
  final isComic = false;
  final String pathUrl;
  final T item;
  final String Function(T) getTopicImg;
  final String Function(T) getName;
  final String Function(T)? getUpChapter;
  final String Function(T)? getUpdate;
  final List Function(T) getTypeNames;
  final int Function(T) getEpisodesCount;
  final int imgHeight;
  final bool isRecent;

  static int _defaultGetEpisodesCount(dynamic item) => 0;

  const GridViewList({
    super.key,
    required this.item,
    required this.getTopicImg,
    required this.getName,
    required this.getTypeNames,
    required this.pathUrl,
    this.getUpChapter,
    this.getUpdate,
    this.imgHeight = 130,
    this.getEpisodesCount = _defaultGetEpisodesCount,
    this.isRecent = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(pathUrl, arguments: item);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Color(0xfff2f2f4), blurRadius: 8)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: isRecent ?
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: getTopicImg(item),
                        height: imgHeight.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        placeholder: (context, index) {
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: LoadingAnimationWidget.horizontalRotatingDots(
                                color: const Color(0xFF1A1A3F),
                                size: 50,
                              ),
                            ),
                          );
                        },
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 60,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: AppColor.yel,
                            borderRadius:BorderRadius.only(
                              bottomLeft: Radius.circular(12)
                            )
                          ),
                          child: Text(getUpdate!=null?getUpdate!(item):'未知',style: TextStyle(
                            fontSize: 10.sp,
                          ),),
                        ),
                      )
                    ],
                  )
              :CachedNetworkImage(
                imageUrl: getTopicImg(item),
                height: imgHeight.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                placeholder: (context, index) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        color: const Color(0xFF1A1A3F),
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getName(item),
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  getTypeNames(item).isNotEmpty?
                  CommonTags(
                    nameArr: handleTagsItem(getTypeNames(item)),
                  ):Text(getUpChapter!=null?' 更新至:${getUpChapter!(item)}':'未知', overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10.sp),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
