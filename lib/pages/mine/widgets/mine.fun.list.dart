import 'package:comic/app_theme.dart';
import 'package:comic/global.dart';
import 'package:comic/public.models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MineFunList extends StatelessWidget {
  final List<ListData> list;
  final String title;
  final int listKey;
  final void Function(int id) onTap;

  const MineFunList({
    super.key,
    required this.list,
    required this.listKey,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        titleSpacing: 0,
        toolbarHeight: 30.h,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.videoPrimary),
          // 设置返回键的颜色
          onPressed: () {
            // 返回键点击事件
            Navigator.pop(context);
          },
        ),
        title: Text(title,
            style: TextStyle(color: AppColor.videoPrimary, fontSize: 16.sp)),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              color: Colors.white,
              child: Column(
                  children: List.generate(
                      list.length, (index) => _buildList(list[index]))),
            ),
          ),
          listKey == 1
              ? SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () {
                      onTap(1);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                        color: AppColor.red,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: const Text(
                        '退出登录',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                )
              : const SliverToBoxAdapter()
        ],
      ),
    );
  }

  Widget _buildList(ListData list) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          onTap(list.id);
        },
        child: Row(
          children: [
            list.icon != null ? Icon(list.icon, size: 20) : Container(),
            const SizedBox(width: 8),
            Text(list.name),
            const Spacer(),
            list.msg != null
                ? Text(
                    list.msg as String,
                    style: const TextStyle(color: AppColor.gray),
                  )
                : Container(),
            list.shouEndIcon != null
                ? const Icon(Icons.chevron_right, color: AppColor.gray)
                : Container()
          ],
        ),
      ),
    );
  }
}
