import 'package:comic/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  @override
  void initState() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // 启用 JavaScript
      ..loadRequest(Uri.parse('https://baidu.com')); // 加载网页
    super.initState();
  }

  @override
  void dispose() {
    _controller.runJavaScript('window.stop();'); // 停止加载内容
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffafafa),
        titleSpacing: 0,
        elevation: 0,
        toolbarHeight: 30.h,
        leading: IconButton(
          icon: const Icon(Icons.clear, color: AppColor.videoPrimary),
          // 设置返回键的颜色
          onPressed: () {
            // 返回键点击事件
            Navigator.pop(context);
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
