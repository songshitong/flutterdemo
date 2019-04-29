import 'package:flutter/material.dart';

//使用safeArea 实现固定效果  固定图层和非固定分开即可
//SafeArea  安全区域，可以避开刘海屏等   例如，top:false 上部不移除危险边界但可以设置自己的最小值，默认是移除的
// 定义： 一个widget，通过足够的填充来保护其子级，以避免操作系统入侵
//    例如，这将使子项缩进足够的距离避免屏幕顶部状态栏，它还会使孩子缩进，以避免使用iPhone X的Notch，或显示器的其他类似创意物理功能

//    指定[最minimum]填充时，最小填或将应用安全区域填充充越大
// 原理实现  MediaQuery.of(context).padding 和Padding 和MediaQuery.removePadding
class SafeAreaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SafeAreaPage"),
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            top: false,
            child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black26),
                    child: Text("item index $index"),
                  );
                }),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.purple),
              width: 100,
              height: 50,
              child: Row(
                children: <Widget>[BackButtonIcon(), const SizedBox(width: 12), Text("back")],
              ),
            ),
          )
        ],
      ),
    );
  }
}
