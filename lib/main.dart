import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdemo/flutter/pages/page_home.dart';

//TODO 网络慢的情况的下，初始化是否会阻塞ui，放到isolate??
//如何模拟弱网环境
//https://www.zhihu.com/question/29128847
//https://blog.csdn.net/qq_28351609/article/details/84568422
//https://juejin.im/entry/5c467e1e518825551e28734e
//https://www.infoq.cn/article/pQmLUECekW*DsymqbGvy
//http://www.debugger.wiki/article/html/1555646400461622
void main() {
  ///在runapp前调用插件，确保执行binary messenger
  WidgetsFlutterBinding.ensureInitialized();

  ///异常处理
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (kDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  // This creates a [Zone] that contains the Flutter application and stablishes
  // an error handler that captures errors and reports them.
  //
  // Using a zone makes sure that as many errors as possible are captured,
  // including those thrown from [Timer]s, microtasks, I/O, and those forwarded
  // from the `FlutterError` handler.
  //
  // More about zones:
  //
  // - https://api.dartlang.org/stable/1.24.2/dart-async/Zone-class.html
  // - https://www.dartlang.org/articles/libraries/zones
  runZonedGuarded<Future<Null>>(() async {
    runApp(/*IosPage()*/ HomePage());
  }, (error, stackTrace) async {
    print("$error \n $stackTrace");
  });
}

class IosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: IosFulePage());
  }
}

class IosFulePage extends StatefulWidget {
  @override
  _IosFulePageState createState() => _IosFulePageState();
}

class _IosFulePageState extends State<IosFulePage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: _index);
    return CupertinoPageScaffold(
      child: CupertinoButton(
          child: Text("aa"),
          onPressed: () {
            showCupertinoModalPopup(
                context: context,
                builder: (buildContext) {
                  return _buildBottomPicker(CupertinoPicker(
                      scrollController: scrollController,
                      itemExtent: 40,
                      onSelectedItemChanged: (int index) {
                        setState(() => _index = index);
                      },
                      children: [
                        Text("aaa"),
                        Text("aaa"),
                        Text("aaa"),
                        Text("aaa"),
                      ]));
                });
          }),
    );
  }
}

Widget _buildBottomPicker(Widget picker) {
  /// 放在container里面有滚动的弯曲效果，不然全屏竖直滚动
  return Container(
    height: 216,
    padding: const EdgeInsets.only(top: 6.0),
    color: CupertinoColors.white,
    child: picker,
  );
}
