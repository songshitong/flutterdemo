import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/transform.dart';

//将widget裁剪，将widget分成几份   自定义canvas超出绘制可以使使用clip进行限制
//ClipRect        使用矩形剪辑其子项的widget .默认情况下，[ClipRect]会阻止其子项在其外部绘制
//   bounds，但是可以使用custom [clipper]自定义剪辑rect的大小和位置,如果[clipper]为null，则剪辑将匹配子项的布局大小和位置
//ClipRRect       使用圆角矩形剪裁其子项的widget
//ClipOval        用于椭圆形裁剪,圆是特殊的椭圆
//ClipPath        对于任意形状的剪辑
//CustomClipper   有关创建自定义剪辑的信息
class ClipWidget extends StatefulWidget {
  @override
  _ClipWidgetState createState() => _ClipWidgetState();
}

class _ClipWidgetState extends State<ClipWidget> {
  var index = 0;
  var datas = [];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      datas.add("$i");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("clip widget"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: TextContent("ClipRRect"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipOval(
              //宽高相等，圆
              child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(color: Colors.amber),
                  child: TextContent("ClipOval")),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipPath(
              clipper: ShapeBorderClipper(shape: CircleBorder()),
              child: Container(
                  width: 100, height: 100, child: TextContent("ClipPath")),
            ),
          ),
          Center(
            child: Flip3DWidget(
              widgetBuilder: (context, index) {
                print("Flip3DWidget index $index");
                return TextContent(
                  datas[index],
                  width: 100,
                  height: 100,
                );
              },
              childHeight: 50,
              childWidth: 100,
              count: datas.length,
            ),
          ),
        ],
      ),
    );
  }
}

class TextContent extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  TextContent(this.title, {this.width = 200, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey),
      child: Text(
        title,
        style: TextStyle(fontSize: 45),
      ),
    );
  }
}

//1 将child分为两部分   ClipRect
//2 ClipRect 后布局大小固定，需要4层展示
class Flip3DWidget extends StatefulWidget {
  final IndexedWidgetBuilder widgetBuilder;
  double childHeight;
  double childWidth;
  int count;
  Flip3DWidget(
      {required this.widgetBuilder,
      required this.childHeight,
      required this.childWidth,
      required this.count});

  @override
  _Flip3DWidgetState createState() => _Flip3DWidgetState();
}

//up 向上滑，down 向下滑
enum FlipDirection { up, down }
//none,无动画
//forward   reverse
enum ControllerState { none, forward, reverse }

class _Flip3DWidgetState extends State<Flip3DWidget>
    with TickerProviderStateMixin {
  int index = 0;
  late AnimationController _controller;
  FlipDirection? _direction;
  bool _isReverse = false;
  final _perspective = 0.004;
  ControllerState _controllerState = ControllerState.none;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        _controllerState = ControllerState.forward;
      } else if (status == AnimationStatus.completed) {
        setState(() {
          _isReverse = true;
          _controller.reverse();
          _controllerState = ControllerState.reverse;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _controllerState = ControllerState.none;
          _isReverse = false;
          if (_direction == FlipDirection.up) {
            index++;
          } else if (_direction == FlipDirection.down) {
            index--;
          }
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Widget currentWidget;
    Widget? nextWidget;
    Widget? preWidget;

    if (index >= 0 && index <= widget.count - 1) {
      currentWidget = widget.widgetBuilder(context, index);
      if (index < widget.count - 1) {
        nextWidget = widget.widgetBuilder(context, index + 1);
      }
      if (index >= 1) {
        preWidget = widget.widgetBuilder(context, index - 1);
      }
    }

    return GestureDetector(
      onVerticalDragEnd: (detail) {
        if (_controller.isAnimating) {
          //动画进行中不响应，避免动画过程中乱按，动画异常
          return;
        }
        double dy = detail.velocity.pixelsPerSecond.dy;
        print("detail ${dy} detail.velocity ${detail.velocity}");
        //上滑速度为负数
        if (dy < 0) {
          if (index >= widget.count - 1) {
            return;
          }
          _direction = FlipDirection.up;
          setState(() {
            _controller.forward();
          });
        }
        //下滑速度为正书
        if (dy > 0) {
          _direction = FlipDirection.down;
          if (index <= 0) {
            return;
          }
          setState(() {
            _controller.forward();
          });
        }
      },
      child: buildColumn(currentWidget, nextWidget, preWidget, context),
    );
  }

  Widget buildColumn(Widget currentWidget, Widget? nextWidget,
      Widget? preWidget, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            //当前上部分
            clipTop(currentWidget),
            //下一个上部分
            buildNextPreTop(nextWidget, preWidget)
          ],
        ),
        //中线
        buildLine(context),
        Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            //下一个的下半部
            Visibility(
                visible: _controllerState != ControllerState.none,
                child: clipBottom(
                    _direction == FlipDirection.up ? nextWidget! : preWidget!)),
            //当前下部分
            buildCurrentBottom(currentWidget)
          ],
        )
      ],
    );
  }

//  Stack buildDefaultStack(Widget currentWidget, Widget nextWidget, Widget preWidget, BuildContext context) {
//    return Stack(
//      alignment: Alignment.topCenter,
//      children: <Widget>[
//        buildCurrentTop(currentWidget),
//        buildNextPreTop(nextWidget, preWidget),
//        Positioned(
//          top: widget.childHeight,
//          child: buildLine(context),
//        ), //下一个的下半部
//        Positioned(
//          top: widget.childHeight + 1,
//          child: clipBottom(_direction == FlipDirection.up ? nextWidget : preWidget),
//        ), //当前的下半部
//        Positioned(
//          top: widget.childHeight + 1,
//          child: buildCurrentBottom(currentWidget),
//        ),
//      ],
//    );
//  }

  //当前下部分
  Widget buildCurrentBottom(Widget currentWidget) {
    return Visibility(
      visible: _controllerState != ControllerState.reverse,
      child: AnimatedBuilder(
        animation: _controller,
        child: currentWidget,
        builder: (context, widget) {
          double angle =
              !_isReverse ? math.pi / 2 * _controller.value : math.pi / 2;
          return Transform(
              alignment: Alignment.topCenter,
              transform: TransformUtil.perspectiveRotateX(-angle,
                  perspective: _perspective),
              child: clipBottom(widget));
        },
      ),
    );
  }

  //下一个/上一个的上半部分
  Widget buildNextPreTop(Widget? nextWidget, Widget? preWidget) {
    return Visibility(
      visible: _controllerState == ControllerState.reverse,
      child: AnimatedBuilder(
          animation: _controller,
          child: _direction == FlipDirection.up ? nextWidget! : preWidget!,
          builder: (context, child) {
            double angle = math.pi / 2 * _controller.value;
            double rotateX = _isReverse && angle > 0 ? angle : math.pi / 2;
//                print("rotateX $rotateX");
            return Transform(
              alignment: Alignment.bottomCenter,
              transform: TransformUtil.perspectiveRotateX(rotateX,
                  perspective: _perspective),
              child: clipTop(child),
            );
          }),
    );
  }

  //当前上半部分
  Container buildCurrentTop(Widget currentWidget) => Container(
      width: widget.childWidth,
      height: widget.childHeight * 2 + 1,
      child: clipTop(currentWidget));

  //中间线
  Container buildLine(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      color: Colors.white,
    );
  }

  Widget clipTop(Widget? child) {
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: 0.5,
        child: child,
      ),
    );
  }

  Widget clipBottom(Widget? child) {
    return ClipRect(
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.5,
        child: child,
      ),
    );
  }
}

// 优化不显示的部分进行隐藏，
// 问题    上下两个方向分别处理，

//问题，两个controller分别控制两个阶段
// 同一个实例_controller，只能进行一次forward,此时controller的value达到最大值，再次调用forward不会产生作用
// 目标：使用一个controller控制上下，减少实例的创建
// 解决一个_controller控制两部分  例如forward控制下，reverse控制上     下一次滑动controller的value归零，可以继续forward了
