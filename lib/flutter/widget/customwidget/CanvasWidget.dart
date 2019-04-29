import 'package:flutter/material.dart';
import 'dart:math';

class CanvasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Canvas"),
      ),
      body: CanvasWidget(),
    );
  }
}

class CanvasWidget extends StatefulWidget {
  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasWidget> {
  @override
  Widget build(BuildContext context) {
    //一个提供canvas的widget
    return CustomPaint(
      //背景画笔，会显示在子节点后面
      painter: MyPainter(),
      //前景画笔，会显示在子节点前
      foregroundPainter: null,
      //当child为null时，代表默认绘制区域大小，如果有child则忽略此参数，画布尺寸则为child尺寸。
      // 如果有child但是想指定画布为特定大小，可以使用SizeBox包裹CustomPaint实现
      size: Size(100, 100),
      //如果CustomPaint有子节点，为了避免子节点不必要的重绘，
      // 通常情况下都会将子节点包裹在RepaintBoundary Widget中来隔离子节点和CustomPaint本身的绘制边界
//      child: RepaintBoundary(),
      isComplex: true,
      //isComplex：是否复杂的绘制，如果是，Flutter会应用一些缓存策略来减少重复渲染的开销
      willChange: true, //willChange：和isComplex配合使用，当启用缓存时，该属性代表在下一帧中绘制是否会改变
    );
  }
}

class MyPainter extends CustomPainter {
  var myPaint = Paint()
    ..color = Colors.red
    ..isAntiAlias = true
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;
  @override
  void paint(Canvas canvas, Size size) {
//    size当前绘制区域大小。
    canvas.drawCircle(Offset(50, 50), 50, myPaint);
    canvas.drawColor(Colors.black26, BlendMode.colorBurn);
    canvas.drawArc(Rect.fromLTRB(0, 0, 50, 50), 0, 2 * pi * 15 / 18, false, myPaint); //使用 2pi角度

    //正方向是顺时针，     90度会出现精度问题，绘制出现错乱，使用pi

    //写字
//    canvas.drawParagraph(paragraph, offset)

//    textPainter = TextPainter()..textAlign=TextAlign.center..text = TextSpan(text: "50", style: TextStyle(color: Colors.black));
//textPainter.layout();
//    textPainter.paint(
//      canvas,Offset(10, 10);
//    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
//    尽可能的利用好shouldRepaint返回值；
// 在UI树重新build时，控件在绘制前都会先调用该方法以确定是否有必要重绘；
// 假如我们绘制的UI不依赖外部状态，那么就应该始终返回false，因为外部状态改变导致重新build时不会影响我们的UI外观；
// 如果绘制依赖外部状态，那么我们就应该在shouldRepaint中判断依赖的状态是否改变，如果已改变则应返回true来重绘，反之则应返回false不需要重绘
    return false;
  }
}
