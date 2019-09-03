import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//AndroidView
// 将原生view转为widget

//添加原生组件的流程基本是这样的：
//1.实现原生组件PlatformView提供原生view
//2.创建PlatformViewFactory用于生成PlatformView
//3.创建FlutterPlugin用于注册原生组件
//4.原生View的调用，使用Android平台的view只需要创建AndroidView组件并告诉它组件的注册名称viewType即可
//creationParams传入了一个map参数，并由原生组件接收,  creationParamsCodec传入的是一个编码对象这是固定写法
//5.与原生组件通信 -- 原生view实现MethodChannel.MethodCallHandler

//在开发原生组件时，Flutter的热加载是无效的，因为每次都需要编译原生工程才能使之生效

class NativeWidgetPage extends StatefulWidget {
  static const String AndroidNativeWidgetName = "example/android/NativeName";
  static const String CHANNEL = "example/android/method_channel/android_native_view";

  static const String PARAM_KEY_CONTENT = "context";
  static const String METHOD_KEY_CHANGE_TEXT = "changeText";

  @override
  NativeWidgetPageState createState() {
    return NativeWidgetPageState();
  }
}

class NativeWidgetPageState extends State<NativeWidgetPage> {
  MethodChannel _channel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NativeWidget"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
              width: 200,
              height: 200,
              child: AndroidView(
                viewType: NativeWidgetPage.AndroidNativeWidgetName,
                creationParams: {"context": "android 原生view"},
                creationParamsCodec: StandardMessageCodec(),
                onPlatformViewCreated: (int id) {
                  //id 是view独有的
                  _channel = new MethodChannel('${NativeWidgetPage.CHANNEL}$id');
                },
              )),
          FlatButton(
              onPressed: () {
                _channel.invokeMethod(NativeWidgetPage.METHOD_KEY_CHANGE_TEXT, "我变了");
              },
              child: Text("改变btn的值，与原生通信"))
        ],
      ),
    );
  }
}
