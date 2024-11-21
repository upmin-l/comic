import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';
import 'mine.fun.list.dart';

Widget mineList(
    BuildContext context, MinePageController controller, MineList list) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: InkWell(
      onTap: () {
        if (list.key == 1 && UserData.getInstance.userData == null) {
          BrnToast.show("你还没登录！", context);
          return;
        }
        controller.handleFun(list.key).then((value) {
          Get.to(
            () => MineFunList(
                list: value,
                listKey: list.key,
                title:list.name,
                onTap: (id) {
                  controller.handleFunListClick(context, id);
                }),
            transition: Transition.rightToLeftWithFade,
          );
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(list.icon, size: 20),
              const SizedBox(width: 8),
              Text(list.name)
            ],
          ),
          if (list.jumpTo != false)
            const Icon(Icons.chevron_right, color: AppColor.gray),
        ],
      ),
    ),
  );
}
