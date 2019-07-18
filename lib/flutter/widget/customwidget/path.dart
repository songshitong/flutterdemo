import 'dart:ui';

import 'package:flutter/material.dart';

class PathPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("path page"),
      ),
      body: Column(
        children: <Widget>[
          CustomPaint(
            painter: _MyPainter(),
          )
        ],
      ),
    );
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
    painter
      ..color = Colors.red
      ..isAntiAlias = true
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
  }
}
