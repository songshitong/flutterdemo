import 'package:flutter/material.dart';

class SelectableTest extends StatefulWidget {
  @override
  _SelectableTestState createState() => _SelectableTestState();
}

class _SelectableTestState extends State<SelectableTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SelectableTest"),
      ),
      body: Column(
        children: [
          Text("platform android"),
          Container(
            height: 100,
            //测试滚动时，复制粘贴弹窗是否遮挡APPbar
            child: Theme(
              data:
                  Theme.of(context).copyWith(platform: TargetPlatform.android),
              child: SelectableText('''
              据英国一家运营商透露，苹果将于10月13日举行iphone 12发射，并于10月16日开始接受预订。
还有人说，英国最大的电信运营商EE举行了一次内部演示，Eddy Cue(埃迪·库)是苹果网络软件和服务的高级副总裁，他在公司内部展示视频。连接视频时，有人问他iphone 12什么时候发布，尽管他没有透露具体的发布日期，但他说，“快了”。
就在苹果下一次大上市的几天前，5giphone，"他告诉员工。消费者部门的团队已经为推出做了整年的准备，并已成为苹果在欧洲的首选合作伙伴。
众所周知的举报人乔恩 普罗瑟(Jonprosser)的消息与运营商的消息基本相同。苹果iphone 12将在10月13日的苹果活动上发布，预购将于10月16日开始，iphone12mini/max将于10月23日公开。
iPhone 12有两千二百万像素相机，而PRO有三个摄像头，这也被认为有用于深度测绘的激光雷达传感器，以支持增强的Ar和摄影
目前情况是，iPhone 12系列是在10月发布的，可以确认。如果这个消息属实，根据最近几年新推出的iPhone首次发售，中国一般是第一批首次销售。因此，国内预订也可能在10月16日同时开放
              '''),
            ),
          ),
          Text("platform ios"),
          Container(
            height: 100,
            child: Theme(
              data: Theme.of(context).copyWith(platform: TargetPlatform.iOS),
              child: SelectableText('''
              据英国一家运营商透露，苹果将于10月13日举行iphone 12发射，并于10月16日开始接受预订。
还有人说，英国最大的电信运营商EE举行了一次内部演示，Eddy Cue(埃迪·库)是苹果网络软件和服务的高级副总裁，他在公司内部展示视频。连接视频时，有人问他iphone 12什么时候发布，尽管他没有透露具体的发布日期，但他说，“快了”。
就在苹果下一次大上市的几天前，5giphone，"他告诉员工。消费者部门的团队已经为推出做了整年的准备，并已成为苹果在欧洲的首选合作伙伴。
众所周知的举报人乔恩 普罗瑟(Jonprosser)的消息与运营商的消息基本相同。苹果iphone 12将在10月13日的苹果活动上发布，预购将于10月16日开始，iphone12mini/max将于10月23日公开。
iPhone 12有两千二百万像素相机，而PRO有三个摄像头，这也被认为有用于深度测绘的激光雷达传感器，以支持增强的Ar和摄影
目前情况是，iPhone 12系列是在10月发布的，可以确认。如果这个消息属实，根据最近几年新推出的iPhone首次发售，中国一般是第一批首次销售。因此，国内预订也可能在10月16日同时开放
              '''),
            ),
          ),
        ],
      ),
    );
  }
}
