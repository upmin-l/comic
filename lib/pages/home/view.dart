import 'package:comic/pages/home/widgets/index.dart';
import 'package:comic/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'index.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomePageController(),
      id: 'homePage',
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            toolbarHeight: 30.h,
            backgroundColor: Colors.white,
            titleSpacing: 3,
            title: BcTab(
              tabs: controller.homeTabs,
              controller: controller.homeTabController,
            ),
          ),
          body: TabBarView(
            controller: controller.homeTabController,
            children: const [Comic18Page(), Novel18Page()],
          ),
        );
      },
    );
  }
}
