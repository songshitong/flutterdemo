import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO https://juejin.im/post/5b7ba79a6fb9a01a1826776b texture 原理
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
        ],
      ),
    );
  }

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }
}
