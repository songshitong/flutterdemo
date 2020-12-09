import 'package:flutter/material.dart';

///
/// Notification是Flutter中一个重要的机制，在Widget树中，每一个节点都可以分发通知，通知会沿着当前节点（context）向上传递，
/// 所有父节点都可以通过NotificationListener来监听通知，Flutter中称这种通知由子向父的传递为“通知冒泡”（Notification Bubbling），
/// 这个和用户触摸事件冒泡是相似的，但有一点不同：通知冒泡可以中止，但用户触摸事件不行
///
/// [NotificationListener]监听[Notification],使用notification 作为泛型
///
/// 常用通知ScrollNotification，SizeChangedLayoutNotification，SizeChangedLayoutNotification，LayoutChangedNotification
///
/// onNotification  true 取消冒泡通知，false，继续
///
///
///
/// 自定义通知
/// 1  定义一个通知类，要继承自Notification类
///    class MyNotification extends Notification {
///    MyNotification(this.msg);
///    final String msg;
///    }
///
/// 2分发通知
///   Notification有一个dispatch(context)方法，它是用于分发通知的，我们说过context实际上就是操作Element的一个接口，
///   它与Element树上的节点是对应的，通知会从context对应的Element节点向上冒泡。contenxt必须是事件发生节点的而不是根节点
class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String _msg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notification page"),
      ),
      body: NotificationListener(
        onNotification: (dynamic notification) {
          //print(notification);
          switch (notification.runtimeType) {
            case ScrollStartNotification:
              print("开始滚动");
              break;
            case ScrollUpdateNotification:
              print("正在滚动");
              break;
            case ScrollEndNotification:
              print("滚动停止");
              break;
            case OverscrollNotification:
              print("滚动到边界");
              break;
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("$index"),
                    );
                  }),
              NotificationListener<MyNotification>(
                onNotification: (notification) {
                  setState(() {
                    _msg += notification.msg + "  ";
                  });
                  return true;
                },
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //拿到当前节点的信息
                      Builder(
                        builder: (context) {
                          return RaisedButton(
                            //按钮点击时分发通知
                            onPressed: () => MyNotification("Hi").dispatch(context),
                            child: Text("Send Notification"),
                          );
                        },
                      ),
                      Text(_msg)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}
