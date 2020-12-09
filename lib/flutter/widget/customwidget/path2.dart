import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

class Path2Page extends StatefulWidget {
  @override
  _Path2PageState createState() => _Path2PageState();
}

class _Path2PageState extends State<Path2Page> {
  ui.Image? image;
  @override
  void initState() {
    super.initState();
    load(MyImgs.water_container).then((result) {
      image = result;
      setState(() {});
    });
  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 40, targetHeight: 35);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("path2 page"),
        ),
        body: CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height - 80),
          painter: _MyPainter(image),
        ));
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, painter);

    painter.color = Colors.purple;
    print("width ${size.width / 2}  ");
    painter.style = PaintingStyle.stroke;
    path.moveTo(size.width / 2, 0);
    // y=sin(x);    y对应x轴坐标，x对应y轴坐标
    for (int i = 0; i < size.height; i++) {
      var x = -math.sin(i / (math.pi * 6)) * 25 + size.width / 2;
      var y = i.toDouble() * math.pi;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, painter);

    for (int i = 0; i < size.height; i += 15) {
      var x = -math.sin(i / (math.pi * 6)) * 25 + size.width / 2;
      var y = i.toDouble() * math.pi;
      ui.PathMetrics pms = path.computeMetrics();
      ui.PathMetric pm = pms.elementAt(0);
      var angle = pm.getTangentForOffset(i.toDouble())!.angle;
      canvas.save();

      ///移动到x,y，然后旋转
      canvas.translate(x, y);
      canvas.rotate(angle);
//      canvas.drawLine(
//          Offset(x - 50, y), Offset(x + 50, y), painter..color = Colors.black);
      if (null != image) {
        canvas.drawImage(image!, Offset(0, 0), painter);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Paint painter = new Paint();
  Path path = new Path();
  _MyPainter(this.image);
  ui.Image? image;
}
