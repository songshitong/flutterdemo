import 'package:flutter/material.dart';

//圆形变形为方形 1 贝塞尔   2 card或container设置角度
class Circle2Rectangle extends StatefulWidget {
  @override
  _Circle2RectangleState createState() => _Circle2RectangleState();
}

class _Circle2RectangleState extends State<Circle2Rectangle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100))
      ..addListener(() {
        setState(() {
          print("_controller.value ${_controller.value}");
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Circle2Rectangle"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: (MediaQuery.of(context).size.width - 100)),
            child: CustomPaint(
              painter: Circle2RectPaint(progress: _controller.value),
            ),
          ),
          RaisedButton(
            onPressed: () {
              _controller.forward();
            },
            child: Text("start change"),
          ),
          RaisedButton(
            onPressed: () {
              _controller.reverse();
            },
            child: Text("reset change"),
          ),
          Card(
            color: Colors.purple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(25), bottomRight: Radius.circular(25))),
            child: SizedBox(
              width: 150,
              height: 50,
              child: Text("card"),
            ),
          )
        ],
      ),
    );
  }
}

class Circle2RectPaint extends CustomPainter {
//用四个贝塞尔拟合圆形，https://github.com/GcsSloop/AndroidNote/blob/master/CustomView/Advance/%5B06%5DPath_Bezier.md
  //每个线段一半是pointLength
  static const double pointLength = 0.551915024494;
  double? progress = 0.0;
  //半径
  double r = 50.0;
  double width = 100.0;
  double height = 100.0;
  late Offset center;
  //四个控制点
  late Offset controlTop;
  late Offset controlLeft;
  late Offset controlBottom;
  late Offset controlRightTop;

  //要变为方形右侧增加一个控制点
  late Offset controlRightBottom;

  //8个起始点
  late Offset topStart;
  late Offset topEnd;
  late Offset leftStart;
  late Offset leftEnd;
  late Offset bottomStart;
  late Offset bottomEnd;
  late Offset rightStart;
  late Offset rightEnd;
  Paint mPaint = Paint()..color = Colors.red;
  Path mPath = Path();
  @override
  void paint(Canvas canvas, Size size) {
    //变为方形时  controlRightBottom rightStart右下角   controlRightTop rightEnd右上角
    if (controlRightBottom.dy > -r + center.dy) {
      controlRightBottom = controlRightBottom.translate(0, -r * progress!);
    }
    if (controlRightTop.dy < r + center.dy) {
      controlRightTop = controlRightTop.translate(0, r * progress!);
    }
    if (rightStart.dy > -r + center.dy) {
      rightStart = rightStart.translate(0, (-r + r * pointLength) * progress!);
    }
    if (rightEnd.dy < r + center.dy) {
      rightEnd = rightEnd.translate(0, (r - r * pointLength) * progress!);
    }
    //开始画圆
    mPath.moveTo(controlTop.dx, controlTop.dy);
    mPath.cubicTo(topStart.dx, topStart.dy, leftStart.dx, leftStart.dy, controlLeft.dx, controlLeft.dy);
    mPath.cubicTo(leftEnd.dx, leftEnd.dy, bottomStart.dx, bottomStart.dy, controlBottom.dx, controlBottom.dy);
    mPath.cubicTo(
        bottomEnd.dx, bottomEnd.dy, rightStart.dx, rightStart.dy, controlRightBottom.dx, controlRightBottom.dy);
    mPath.lineTo(controlRightTop.dx, controlRightTop.dy);
    mPath.cubicTo(rightEnd.dx, rightEnd.dy, topEnd.dx, topEnd.dy, controlTop.dx, controlTop.dy);
    canvas.drawPath(mPath, mPaint);
    print(
        "controlRightTop $controlRightTop rightEnd $rightEnd controlRightBottom $controlRightBottom  rightStart $rightStart  progress $progress");
  }

  @override
  bool shouldRepaint(Circle2RectPaint oldDelegate) {
    return oldDelegate.progress != this.progress;
  }

  Circle2RectPaint({this.progress}) {
    center = Offset(width / 2, height / 2);
    controlTop = Offset(0, r) + center;
    controlLeft = Offset(-r, 0) + center;
    controlBottom = Offset(0, -r) + center;
    controlRightTop = Offset(r, 0) + center;
    controlRightBottom = Offset(r, 0) + center;
    topStart = Offset(-pointLength * r, r) + center;
    topEnd = Offset(pointLength * r, r) + center;
    leftStart = Offset(-r, pointLength * r) + center;
    leftEnd = Offset(-r, -pointLength * r) + center;
    bottomStart = Offset(-pointLength * r, -r) + center;
    bottomEnd = Offset(pointLength * r, -r) + center;
    rightStart = Offset(r, -pointLength * r) + center;
    rightEnd = Offset(r, pointLength * r) + center;
  }
}
