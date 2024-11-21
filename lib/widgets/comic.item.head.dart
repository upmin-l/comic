import 'package:cached_network_image/cached_network_image.dart';
import 'package:comic/app_theme.dart';
import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'index.dart';

class ComicItemHead<T> extends StatelessWidget {
  /// 漫画详情页头部 可作为 短剧的详情页
  final T comicItem;
  final String comicInfoState;
  final String? updateTimeLabel;
  final String Function(T) getTopicImg;
  final String Function(T) getName;
  final List Function(T) getTage;

  const ComicItemHead({
    required this.getTopicImg,
    required this.getName,
    required this.comicItem,
    required this.getTage,
    this.comicInfoState = '未知',
    this.updateTimeLabel ='',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: BezierClipper2(),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColor.red,
                  offset: Offset(10.0, 10.0),
                  // 阴影模糊半径
                  blurRadius: 20.0,
                  // 阴影扩散半径
                  spreadRadius: 10.0,
                )
              ],
            ),
            height: 265.h,
          ),
        ),
        ClipPath(
          clipper: BezierClipper(),
          child: Container(
              color: Colors.white,
              height: 260.h,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: getTopicImg(comicItem),
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
              )),
        ),
        ClipPath(
          clipper: BezierClipper(),
          child: Container(
            height: 260.h,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter, // 渐变开始于容器的顶部中心
                end: Alignment.topCenter, // 渐变结束于容器的底部中心
                colors: [
                  const Color(0xff2d3f51),
                  const Color(0xffbcc2c6).withOpacity(0.3)
                ],
                stops: const [0.0, 0.9], // 定义渐变颜色的停止点
              ),
            ),
          ),
        ),
        Positioned(
          top: 30.h,
          left: 0,
          right: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, // 设置形状为圆形
                      color: Colors.white),
                  width: 30.sp,
                  height: 30.sp,
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.zero, // 移除内边距
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, // 设置形状为圆形
                      color: Colors.white),
                  width: 30.sp,
                  height: 30.sp,
                  child: IconButton(
                    padding: EdgeInsets.zero, // 移除内边距
                    iconSize: 16.sp,
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10.h,
          child: SizedBox(
            height: 120.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                        color: Colors.white,
                        width: 100.w,
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: getTopicImg(comicItem),
                            fit: BoxFit.cover,
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
                          ),
                        )),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 6.h),
                      width: 200.w,
                      child: Text(
                        getName(comicItem),
                        style: TextStyle(fontSize: 18.sp, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    CommonTags(
                      //  0xff5bc2a7
                      withOpacity: 0.2,
                      nameArr: [
                        TagsItem(title: '永久免费', color: 0xfffddd20),
                        TagsItem(title: '永久无广告', color: 0xfffddd20)
                      ],
                      fontSize: 10.sp,
                    ),
                    SizedBox(height: 3.h),
                    // Text(
                    //   '漫画状态：$comicInfoState',
                    //   style: TextStyle(
                    //     fontSize: 12.sp,
                    //     color: AppColor.lightGray,
                    //   ),
                    // ),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: '漫画状态：$comicInfoState ',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.lightGray,
                          ),
                        ),
                        TextSpan(
                          text: updateTimeLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColor.yel,
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: List.generate(
                          getTage(comicItem).length,
                          (index) => Center(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: Text(
                                    getTage(comicItem)[index],
                                    style: titleStyle.copyWith(
                                        color: AppColor.search,
                                        fontSize: 12.sp),
                                  ),
                                ),
                              )),
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class BezierClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 路径
    var path = Path();
    // 设置路径的开始点
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 50); // 第二个点

    // 设置第一个曲线的样式
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPont = Offset(size.width / 2, size.height - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPont.dx, firstEndPont.dy);

    var secondConttrolPoint = Offset(size.width / 4 * 3, size.height - 70);
    var secondEndpoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(secondConttrolPoint.dx, secondConttrolPoint.dy,
        secondEndpoint.dx, secondEndpoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    path.close();
    // 返回路径
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class BezierClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 路径
    var path = Path();
    // 设置路径的开始点
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 50); // 第二个点

    // 设置第一个曲线的样式
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPont = Offset(size.width / 2, size.height - 40);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPont.dx, firstEndPont.dy);

    var secondConttrolPoint = Offset(size.width / 4 * 3, size.height - 70);
    var secondEndpoint = Offset(size.width, size.height - 40);

    path.quadraticBezierTo(secondConttrolPoint.dx, secondConttrolPoint.dy,
        secondEndpoint.dx, secondEndpoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    path.close();
    // 返回路径
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
