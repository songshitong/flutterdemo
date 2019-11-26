import 'package:flutter/material.dart';
import 'package:rammus/rammus.dart' as rammus;

//TODO 网络慢的情况的下，初始化是否会阻塞ui，放到isolate??
//如何模拟弱网环境
//https://www.zhihu.com/question/29128847
//https://blog.csdn.net/qq_28351609/article/details/84568422
//https://juejin.im/entry/5c467e1e518825551e28734e
//https://www.infoq.cn/article/pQmLUECekW*DsymqbGvy
//http://www.debugger.wiki/article/html/1555646400461622
/// 阿里推送
///
class PushPage extends StatefulWidget {
  @override
  _PushPageState createState() => _PushPageState();
}

class _PushPageState extends State<PushPage> {
  String deviceId = "";
  rammus.CloudPushMessage msg;
  @override
  void initState() {
    super.initState();
    rammus.deviceId.then((id) {
      print("_PushPageState receiveid ===============>");
      setState(() {
        deviceId = id;
      });
    });
    //android 8.0 适配
//    rammus.setupNotificationManager();
    rammus.onMessageArrived.listen((cMsg) {
      print("_PushPageState onMessageArrived ===============>");

      setState(() {
        msg = cMsg;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    StringBuffer sb = StringBuffer();
    sb.writeln("msg ");
    sb.writeln("appId ${msg?.appId}");
    sb.writeln("content ${msg?.content}");
    sb.writeln("messageId ${msg?.messageId}");
    sb.writeln("title ${msg?.title}");
    sb.writeln("traceInfo ${msg?.traceInfo} ");
    return Scaffold(
      appBar: AppBar(
        title: Text("阿里推送"),
      ),
      body: Column(
        children: <Widget>[Text("msg coming "), Text("deviceId $deviceId"), Text("${sb.toString()} ")],
      ),
    );
  }
}
