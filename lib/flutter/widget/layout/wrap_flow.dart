import 'package:flutter/material.dart';

class WrapAndFlowPage extends StatefulWidget {
  @override
  _WrapAndFlowPageState createState() => _WrapAndFlowPageState();
}

class _WrapAndFlowPageState extends State<WrapAndFlowPage> {
  @override
  Widget build(BuildContext context) {
//    我们把超出屏幕显示范围会自动折行的布局称为流式布局。Flutter中通过Wrap和Flow来支持流式布局
//    Flow主要用于一些需要自定义布局策略或性能要求较高(如动画中)的场景
    //  优缺点
//    性能好；Flow是一个对child尺寸以及位置调整非常高效的控件，Flow用转换矩阵（transformation matrices）在对child进行位置调整的时候进行了优化：在Flow定位过后，如果child的尺寸或者位置发生了变化，在FlowDelegate中的paintChildren()方法中调用context.paintChild 进行重绘，而context.paintChild在重绘时使用了转换矩阵（transformation matrices），并没有实际调整Widget位置。
//    灵活；由于我们需要自己实现FlowDelegate的paintChildren()方法，所以我们需要自己计算每一个widget的位置，因此，可以自定义布局策略
//    缺点：
//    使用复杂.
//    不能自适应子widget大小，必须通过指定父容器大小或实现TestFlowDelegate的getSize返回固定大小
    return Scaffold(
      appBar: AppBar(
        title: Text("wrap and flow"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              color: Colors.black26,
              child: Wrap(
                direction: Axis.vertical,
                //主轴方向类似flex
                spacing: 15,
                //主轴方向子widget的间距
                runSpacing: 30,
                //纵轴方向的间距
                runAlignment: WrapAlignment.center, //纵轴的对齐
                alignment: WrapAlignment.center, //主轴对齐
                children: <Widget>[Text("aaaaaaaaaaaaaa"), Text("bbbbbbbbbbbbbbbbbb"), Text("cccccccccccccccccccc")],
              )),
          Container(
            height: 10,
          ),
          Container(
              color: Colors.black26,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text("aaaaaaaaaaaaaa"),
                  Text("bbbbbbbbbbbbbbbbbb"),
                  Text("cccccccccccccccccccccccc")
                ],
              )),
          Flow(delegate: TestFlowDelegate(margin: EdgeInsets.all(10.0)), children: <Widget>[
            new Container(
              width: 80.0,
              height: 80.0,
              color: Colors.red,
            ),
            new Container(
              width: 80.0,
              height: 80.0,
              color: Colors.green,
            ),
            new Container(
              width: 80.0,
              height: 80.0,
              color: Colors.blue,
            ),
            new Container(
              width: 80.0,
              height: 80.0,
              color: Colors.yellow,
            ),
            new Container(
              width: 80.0,
              height: 80.0,
              color: Colors.brown,
            ),
            new Container(
              width: 80.0,
              height: 80.0,
              color: Colors.purple,
            ),
          ]),
        ],
      ),
    );
  }
}

class TestFlowDelegate extends FlowDelegate {
  EdgeInsets? margin = EdgeInsets.zero;
  TestFlowDelegate({this.margin});
  @override
  void paintChildren(FlowPaintingContext context) {
//    FlowPaintingContext  FlowDelegate绘制的context，提供了container的size，child的size，child的绘制机制
    var x = margin!.left;
    var y = margin!.top;
    //计算每一个子widget的位置
    for (int i = 0; i < context.childCount; i++) {
      //最后一个不绘制
      if (i == 5) return;

      var w = context.getChildSize(i)!.width + x + margin!.right;
      if (w < context.size.width) {
        // 一行之内
        context.paintChild(i, transform: new Matrix4.translationValues(x, y, 0.0));
        x = w + margin!.left;
      } else {
        //超过一行
        x = margin!.left;
        y += context.getChildSize(i)!.height + margin!.top + margin!.bottom;
        //绘制子widget(有优化)
        context.paintChild(i, transform: new Matrix4.translationValues(x, y, 0.0));
        x += context.getChildSize(i)!.width + margin!.left + margin!.right;
      }
    }
  }

  getSize(BoxConstraints constraints) {
    //指定Flow的大小
    return Size(double.infinity, 200.0);
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
