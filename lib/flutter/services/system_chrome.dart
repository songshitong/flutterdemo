import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as Math;

///[SystemChrome] 控制操作系统图形界面的特定方面，它如何与应用程序交互
///
/// 横竖屏 切换后页面布局错乱，widgetsbing.instance.addpostFramecall(setState); 页面更新后重新刷新。
/// SystemChrome.setPreferredOrientations(
///        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
class SystemChromePage extends StatefulWidget {
  @override
  _SystemChromePageState createState() => _SystemChromePageState();
}

class _SystemChromePageState extends State<SystemChromePage> {
  List<SystemUiOverlay> overlays = [];
  SystemUiOverlayStyle style = SystemUiOverlayStyle.light;
  SystemUiOverlayStyle regionStyle = SystemUiOverlayStyle.light;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: regionStyle,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                if (overlays.length == 0) {
                  //显示状态栏 其他可选SystemUiOverlay.top 状态栏 SystemUiOverlay.bottom底部导航
                  overlays = SystemUiOverlay.values;
                } else {
                  //隐藏状态栏
                  overlays = [];
                  //restoreSystemUIOverlays() 回复至上一次调用setEnabledSystemUIOverlays的状态
                }
                //指定在应用程序运行时可见的系统叠加集
                SystemChrome.setEnabledSystemUIOverlays(overlays);
              },
              child: Text("setEnabledSystemUIOverlays"),
            ),
            RaisedButton(
              onPressed: () {
                if (style == SystemUiOverlayStyle.light) {
                  style = SystemUiOverlayStyle.dark;
                } else {
                  style = SystemUiOverlayStyle.light;
                }
                style = SystemUiOverlayStyle(
                    statusBarColor: Colors.blue,
                    statusBarIconBrightness: Brightness.dark, // not working
                    systemNavigationBarColor: Colors.blue,
                    // works
                    systemNavigationBarIconBrightness: Brightness.dark);
                //指定用于可见的系统叠加的样式（如果可以）
                //此方法将调度嵌入器更新以在微任务中运行.在当前事件循环期间对此方法的任何后续调用都将覆盖挂起值，以便只有最后指定的值生效
                //    (实际测试中，调用setEnabledSystemUIOverlays后，setSystemUIOverlayStyle设置的值不再生效)
                //在生命周期与所需系统UI样式匹配的代码中调用此API。例如，要在新页面上更改系统UI样式，请考虑在推送/弹出新的[PageRoute]时调用
//              但是，[AppBar]小部件根据其[AppBar.brightness]自动设置系统覆盖样式, 所以配置，而不是直接调用此方法.
//                 （实际测试，存在APPbar时，调用setSystemUIOverlayStyle不生效）
//                  同样，通过[CupertinoNavigationBar.backgroundColor]为[CupertinoNavigationBar]做同样的事情.
                //如果平台不支持特定样式，则选择它将无效 如SystemUiOverlayStyle.dark

//              要更复杂地控制系统覆盖样式，请考虑使用[AnnotatedRegion]小部件而不是直接调用[setSystemUiOverlayStyle].
                // 可以在APPbar未使用时，使用AnnotatedRegion来控制状态栏，APPbar内部也是包含AnnotatedRegion
                SystemChrome.setSystemUIOverlayStyle(style);
              },
              child: Text("setSystemUIOverlayStyle"),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  final color = Color.fromRGBO(
                    Math.Random.secure().nextInt(255),
                    Math.Random.secure().nextInt(255),
                    Math.Random.secure().nextInt(255),
                    1.0,
                  );
                  setState(() {
                    regionStyle = SystemUiOverlayStyle.dark.copyWith(
                      statusBarColor: color,
                    );
                  });
                });
              },
              child: Text("改变AnnotatedRegion"),
            )
          ],
        ),
      ),
    );
  }
}
