import 'package:flutter/material.dart';

class ScrollNotificationPage extends StatefulWidget {
  @override
  _ScrollNotificationPageState createState() => _ScrollNotificationPageState();
}

class _ScrollNotificationPageState extends State<ScrollNotificationPage> {
  String _progress = "0%"; //保存进度百分比
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      debugPrint(
          "_controller offset ${_controller.offset}  position ${_controller.position}");
    });
  }

  @override
  Widget build(BuildContext context) {
//    Flutter Widget树中子Widget可以通过发送通知（Notification）与父(包括祖先)Widget通信。父Widget可以通过NotificationListener Widget来监听自己关注的通知，
// 这种通信方式类似于Web开发中浏览器的事件冒泡，我们在Flutter中沿用“冒泡”这个术语。Scrollable Widget在滚动时会发送ScrollNotification类型的通知，ScrollBar正是通过监听滚动通知来实现的。
// 通过NotificationListener监听滚动事件和通过ScrollController有两个主要的不同：
//    通过NotificationListener可以在从Scrollable Widget到Widget树根之间任意位置都能监听。而ScrollController只能和具体的Scrollable Widget关联后才可以。
//    收到滚动事件后获得的信息不同；NotificationListener在收到滚动事件时，通知中会携带当前滚动位置和ViewPort的一些信息，而ScrollController只能获取当前滚动位置
    return Scaffold(
      appBar: AppBar(
        title: Text("ScrollNotification"),
      ),
      body: Scrollbar(
        //进度条
        // 监听滚动通知
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
//            ScrollMetrics，该属性包含当前ViewPort及滚动位置等信息：
//            pixels：当前滚动位置
//           maxScrollExtent：最大可滚动长度。
//            extentBefore：滑出ViewPort顶部的长度；此示例中相当于顶部滑出屏幕上方的列表长度
//            extentInside：ViewPort内部长度；此示例中屏幕显示的列表部分的长度
//            extentAfter：列表中未滑入ViewPort部分的长度；此示例中列表底部未显示到屏幕范围部分的长度
//            atEdge：是否滑到了Scrollable Widget的边界（此示例中相当于列表顶或底部）
            double progress = notification.metrics.pixels /
                notification.metrics.maxScrollExtent;
            //重新构建
            setState(() {
              _progress = "${(progress * 100).toInt()}%";
            });
            print("BottomEdge: ${notification.metrics.extentAfter == 0}");
            //return true; //放开此行注释后，进度条将失效
            // return true 事件拦截，false向上传递
            ///滚动方向
            ///up: _scrollController.position.userScrollDirection == ScrollDirection.forward
            //down: _scrollController.position.userScrollDirection == ScrollDirection.reverse
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ListView.builder(
                  controller: _controller,
                  itemCount: 100,
                  itemExtent: 50.0,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text("$index"));
                  }),
              CircleAvatar(
                //显示进度百分比
                radius: 30.0,
                child: Text(_progress),
                backgroundColor: Colors.black54,
              ),
              Positioned(
                bottom: 20,
                child: RaisedButton(
                  onPressed: () {
//                    _controller.jumpTo(0);
                    _controller.animateTo(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease);
                  },
                  child: Text("返回顶部"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
