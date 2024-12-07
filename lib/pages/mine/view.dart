import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/user.Info.dart';
import 'widgets/user.classification.dart';
import 'widgets/user.mine.list.dart';

class MinePage extends GetView<MinePageController> {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MinePageController(),
        id: 'minePage',
        builder: (_) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  centerTitle: false,
                  floating: true,
                  pinned: true,
                  toolbarHeight: 30.h,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  actions: [
                    // IconButton(
                    //   icon: const Icon(Icons.light_mode),
                    //   iconSize: 24,
                    //   color: AppColor.defaultColor,
                    //   onPressed: () {
                    //     // Get.changeThemeMode(themeMode);
                    //   },
                    // ),
                    IconButton(
                      icon: const Icon(Icons.notifications_none),
                      iconSize: 24,
                      color: AppColor.defaultColor,
                      onPressed: () {
                        BrnToast.show("暂无消息！", context);
                      },
                    ),
                  ],
                ),
                // 用户信息
                SliverToBoxAdapter(
                  child: userInfo(
                      context, controller.userData, controller.isLogin, () {
                    controller.refreshUser();
                  }, controller),
                ),
                SliverToBoxAdapter(
                  child: controller.bannerRes.show_url != ''
                      ? Container(
                          height: 80.h,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          color: Colors.white,
                          child: Image.network(controller.bannerRes.show_url),
                        )
                      : Container(),
                ),
                SliverToBoxAdapter(child: userClassification(controller)),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Column(
                      children: List.generate(
                        controller.mineList.length,
                        (index) => mineList(
                            context, controller, controller.mineList[index]),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.only(top: 12.sp),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    color: Colors.white,
                    child: Column(
                      children: [
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.support_agent, size: 20),
                                const SizedBox(width: 8),
                                const Text('客服QQ'),
                                const Spacer(),
                                Text(
                                  controller.customer.qq,
                                  style: const TextStyle(color: AppColor.gray),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            controller.onOpenUrl('https://qm.qq.com/cgi-bin/qm/qr?k=${controller.customer.tap_url}');
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.support_agent, size: 20),
                              const SizedBox(width: 8),
                              const Text('微信客服'),
                              const Spacer(),
                              Text(
                                controller.customer.wx,
                                style: const TextStyle(color: AppColor.gray),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              height: 40.h,
              child: Text(
                '由ChatGPT提供支持，nodeJS爬虫，所有数据来源于网络，请不要相信数据上任何加V扫码等，预防上当诈骗',
                style: TextStyle(fontSize: 12.sp, color: AppColor.red),
              ),
            ),
          );
        });
  }
}
