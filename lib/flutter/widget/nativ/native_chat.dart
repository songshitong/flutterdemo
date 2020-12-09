import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO https://juejin.im/post/5b7ba79a6fb9a01a1826776b texture 原理

//todo EventChannel.StreamHandler  事件监听

//!!! android调用通道必须在主线程

//三种通道
//* BasicMessageChannel：用于传递字符串和半结构化的信息,这个用的比较少
//
//* MethodChannel：用于传递方法调用（method invocation）通常用来调用native中某个方法
//
//* EventChannel: 用于数据流（event streams）的通信。有监听功能，比如电量变化之后直接推送数据给flutter端。

/// MethodChannel与EventChannel 命名时注意带有view的ID，比如VideoPlayer注册了一个EventChannel，
/// flutter两个nativeview存在，创建了两个EventChannel，此时第二个会顶掉第一个
///
/// Future<void>的方法，原生最好也进行回调，防止dart await后不往下走
/// android result.success(null)   /   ios  result(nil);
/// 异常拦截同样返回result.err
/// if(a==null){
///  result.error("-1","","");
/// }
///
///

class MethodChannelPage extends StatefulWidget {
  @override
  _MethodChannelPageState createState() => _MethodChannelPageState();
}

class _MethodChannelPageState extends State<MethodChannelPage> {
  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';

//  构建通道。我们使用MethodChannel调用一个方法来返回电池电量
//  通道的客户端和宿主通过通道构造函数中传递的通道名称进行连接。
//  单个应用中使用的所有通道名称必须是唯一的; 我们建议在通道名称前加一个唯一的“域名前缀”
  static const platform = const MethodChannel('samples.flutter.io/battery');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MethodChannel"),
      ),
      body: Column(
        children: <Widget>[
          new RaisedButton(
            child: new Text('Get Battery Level'),
            onPressed: _getBatteryLevel,
          ),
          new Text(_batteryLevel),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(onPressed: () async {
              await setVoidLog();
              print("after setVoidLog ===");
            }),
          )
        ],
      ),
    );
  }

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int? result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  Future<void> setVoidLog() {
    return platform.invokeMethod("setVoidLog");
  }
}
