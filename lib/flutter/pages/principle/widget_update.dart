import 'dart:math';

import 'package:flutter/material.dart';

///验证widget更新机制  https://juejin.im/post/5ca2152f6fb9a05e1a7a9a26#heading-12
///
///
/// widget canUpdate   runtimeType和key同时相同，通过新widget更新element
/// static bool canUpdate(Widget oldWidget, Widget newWidget) {
///    return oldWidget.runtimeType == newWidget.runtimeType
///        && oldWidget.key == newWidget.key;
///  }
///
///   [flutter/source/widget_update_process.md]

class WidgetUpdate extends StatefulWidget {
  @override
  _WidgetUpdateState createState() => _WidgetUpdateState();
}

class _WidgetUpdateState extends State<WidgetUpdate> {
  List<Widget> widgets = [
    StatelessContainer(),
    StatelessContainer(),
  ];
  List<Widget> statefulWidgets = [
    StatefulContainer(
      key: UniqueKey(),
    ),
    StatefulContainer(key: UniqueKey()),
  ];
  List<Widget> statefulLevelWidgets = [
    Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8.0),
      child: StatefulContainer(
        key: UniqueKey(),
      ),
    ),
    Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8.0),
      child: StatefulContainer(key: UniqueKey()),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("更新机制验证"),
      ),
      body: Column(
        children: <Widget>[
          ///两个StatelessContainer 可以正常更新
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgets,
          ),
          RaisedButton(
            onPressed: () {
              switchWidget();
            },
            child: Text("交换上面两个StatelessContainer的顺序"),
          ),

          ///两个StatefulContainer不能更新，加入key: UniqueKey()后可以正常更新
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: statefulWidgets,
          ),
          RaisedButton(
            onPressed: () {
              switchStatefulWidget();
            },
            child: Text("交换上面两个StatefulContainer的顺序"),
          ),

          ///在UniqueKey基础上增加padding，两个StatefulContainer重建了，而不是交换顺序  解决给padding加key--Uniquekey
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: statefulLevelWidgets,
          ),
          RaisedButton(
            onPressed: () {
              switchStatefulLevelWidget();
            },
            child: Text("交换上面两个statefulLevelWidgets的顺序"),
          )
        ],
      ),
    );
  }

  switchWidget() {
    widgets.insert(0, widgets.removeAt(1));
    setState(() {});
  }

  switchStatefulWidget() {
    statefulWidgets.insert(0, statefulWidgets.removeAt(1));
    setState(() {});
  }

  switchStatefulLevelWidget() {
    statefulLevelWidgets.insert(0, statefulLevelWidgets.removeAt(1));
    setState(() {});
  }
}

class StatelessContainer extends StatelessWidget {
  final Color color =
      Color.fromRGBO(Random.secure().nextInt(255), Random.secure().nextInt(255), Random.secure().nextInt(255), 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color,
    );
  }
}

class StatefulContainer extends StatefulWidget {
  @override
  _StatefulContainerState createState() => _StatefulContainerState();
  StatefulContainer({Key key}) : super(key: key);
}

class _StatefulContainerState extends State<StatefulContainer> {
  final Color color =
      Color.fromRGBO(Random.secure().nextInt(255), Random.secure().nextInt(255), Random.secure().nextInt(255), 1);
  @override
  void initState() {
    super.initState();
    print("_StatefulContainerState initState =======");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: color,
    );
  }
}
