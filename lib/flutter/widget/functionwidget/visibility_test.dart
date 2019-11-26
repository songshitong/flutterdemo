import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/widget/CheckBox.dart';

///Visibility 默认使用SizedBox.shrink()在不显示情况下替代child, 只有一个child，此时树的的深度不变，
///
/// 需要保持size(maintainSize)，内部使用Opacity,透明只使用0(不绘制)，1(正常绘制)，performLayout走父类的正常流程
/// 需要保持state(maintainState),内部使用Offstage，offstage在child不可见时，不布局(performLayout)，不绘制(paint)，child的状态信息仍然存在
///    offstage的RenderOffstage重写了performResize至最小
///
/// visibility比offstage更高效
class VisibilityTestPage extends StatefulWidget {
  @override
  _VisibilityTestPageState createState() => _VisibilityTestPageState();
}

class _VisibilityTestPageState extends State<VisibilityTestPage> {
  var isVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VisibilityTestPage"),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            child: Text("改变visible"),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Visibility(
              visible: isVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(color: Colors.deepPurple),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("only a text"),
          ),
          Visibility(
            child: Text("isVisible $isVisible"),
            visible: isVisible,
          ),
          Visibility(
            visible: isVisible,
            child: AliveCheckbox(
              onChange: (value) {
                print("value $value");
              },
            ),
            maintainState: true,
            maintainAnimation: false,
          ),
        ],
      ),
    );
  }
}
