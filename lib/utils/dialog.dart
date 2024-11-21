import 'package:bruno/bruno.dart';
import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BrunoDialog {
  static Future showConfirmDialog(
    BuildContext context, {
    required String title,
    required String msg,
    required String tip,
    required String confirm,
    required VoidCallback onCancel, // 传递取消时的回调
    required VoidCallback onConfirm, // 传递确认时的回调}
  }) async {
    BrnDialogManager.showConfirmDialog(
      context,
      cancel: "取消",
      confirm: confirm,
      title: title,
      warningWidget: tip != ''
          ? Padding(
              padding: const EdgeInsets.only(top: 6, left: 24, right: 24),
              child: Text(
                tip,
                style: const TextStyle(color: AppColor.red2),
              ),
            )
          : null,
      messageWidget: Padding(
        padding: const EdgeInsets.only(top: 6, left: 24, right: 24),
        child: BrnCSS2Text.toTextView(msg),
      ),
      barrierDismissible: false,
      onCancel: onCancel,
      onConfirm: onConfirm,
    );
  }

  static showSingleButtonDialog(context) {
    BrnDialogManager.showSingleButtonDialog(context,
        showIcon: true, title: "标题内容标题内容", label: "确定", onTap: () {});
  }
}

class Loading {
  static show() {
    Get.dialog(
      Container(
        color: Colors.white,
        child: Center(
          child: LoadingAnimationWidget.hexagonDots(
            color: AppColor.defaultColor,
            size: 40,
          ),
        ),
      ),
    );
  }

  static hide() {
    Get.back();
  }
}
