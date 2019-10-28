import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutterdemo/flutter/common/MyImgs.dart';

class PathPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("path page"),
        ),
        body: CustomPaint(
          size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - 80),
          painter: _MyPainter(),
        ));
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, painter);
    //获得path片段  画了两条线，有两个独立的片段
    PathMetrics pms = path.computeMetrics();
    PathMetric pm = pms.first;
    print("pms length ${pms.length}");
    Tangent tangent = pm.getTangentForOffset(10.0);
    //60,50
    print("tangent position ${tangent.position}");
    //这个点在线上的矢量 比如代表方向
    print("tangent vector ${tangent.vector}");
    //0 沿x轴方向  >0 y轴反向  顺时针方向 实现是-math.atan2(vector.dy, vector.dx);
    print("tangent angle ${tangent.angle}");

    //
    painter.color = Colors.purple;
    print("width ${size.width / 2}  ");
    painter.style = PaintingStyle.fill;
//    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height), painter);
    canvas.save();
    path.reset();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, 0);
    // y=sin(x);    y对应x轴坐标，x对应y轴坐标
    for (int i = 0; i < size.height; i++) {
      path.lineTo(-math.sin(i / (math.pi * 6)) * 25 + size.width / 2, i.toDouble() * math.pi);
    }
    path.lineTo(0, size.height);
    path.close();
    //canvas 区域与path的交集  path是闭合路径可以剪切出一个完整的形状
    canvas.clipPath(path, doAntiAlias: true);
    canvas.drawColor(Colors.purple, BlendMode.srcIn);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Paint painter = new Paint();
  Path path = new Path();
  _MyPainter() {
    path.moveTo(50, 50);
    path.lineTo(150, 50);
    path.moveTo(50, 100);
    path.lineTo(150, 100);
    //添加子path
//    path.addPolygon(points, close)
    painter
      ..color = Colors.red
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
  }
}
