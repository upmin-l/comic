import 'dart:io';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';

import 'initPage.controller.dart';

class InitPage extends GetView<InitPageController> {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InitPageController>(
      init: InitPageController(),
      id: "InitPage",
      builder: (_) {
        // Color backgroundColor = controller.currentIndex == 0 ? Colors.black:Colors.white;
        // Color colorSelected =  controller.currentIndex == 0 ? Colors.white:const Color(0xff272636);
        return Scaffold(
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 300), // 动画持续时间为300毫秒
            child: BottomBarDefault(
              color: const Color(0xff8b8c91),
              backgroundColor: Colors.white,
              indexSelected: controller.currentIndex,
              colorSelected: Colors.black,
              iconSize: 16,
              animated: true,
              titleStyle: titleStyle,
              items: [
                // bottomNavigationBarItem('首页', Icons.home),
                bottomNavigationBarItem('首页', Icons.home),
                bottomNavigationBarItem('18禁', Icons.smart_display),
                bottomNavigationBarItem('书架', Icons.attractions),
                bottomNavigationBarItem('我的', Icons.person),
              ],
              onTap: (index) {
                controller.updateCurrentIndex(index);
              },
            ),
          ),
          body: controller.isAppUpdate
              ? Container(
                  padding: EdgeInsets.only(top: 50.h),
                  child: Column(
                    children: [
                      const Image(
                        image: AssetImage('assets/images/log.png'),
                        fit: BoxFit.cover,
                      ),
                      Text(controller.appMsg.description),
                      SizedBox(height: 30.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              if(Platform.isAndroid){
                                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                              }else if (Platform.isIOS){
                                exit(0);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColor.defaultColor,
                              side: const BorderSide(
                                  color: AppColor.defaultColor),
                            ),
                            child: const Text('取消',
                                style: TextStyle(color: AppColor.defaultColor)),
                          ),
                          ElevatedButton(
                            onPressed: () =>controller.onOpenUrl(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColor.defaultColor, // 设置背景颜色为蓝色
                            ),
                            child: const Text('现在更新'),
                          )
                        ],
                      )
                    ],
                  ),
                )
              : LazyLoadIndexedStack(
                  index: controller.currentIndex,
                  children: controller.pages,
                ),
          // body: PageTransitionSwitcher(
          //   child: controller.pages[controller.currentIndex],
          //   transitionBuilder: (child, animation, secondaryAnimation) {
          //     return FadeThroughTransition(
          //       animation: animation,
          //       secondaryAnimation: secondaryAnimation,
          //       fillColor: Colors.transparent,
          //       child: child,
          //     );
          //   },
          // ),
        );
      },
    );
  }

  TabItem bottomNavigationBarItem(String title, IconData iconName) {
    return TabItem(
      icon: iconName,
      title: title,
    );
  }
}
