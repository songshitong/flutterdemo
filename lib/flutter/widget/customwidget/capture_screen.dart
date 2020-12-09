import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///截图 功能
///涂鸦功能
class CaptureScreenPage extends StatefulWidget {
  @override
  _CaptureScreenPageState createState() => _CaptureScreenPageState();
}

class _CaptureScreenPageState extends State<CaptureScreenPage> {
  GlobalKey captureKey = GlobalKey();
  GlobalKey captureAfterPaintKey = GlobalKey();

  Uint8List? pngBytes;
  Uint8List? pngAfterPaintBytes;
  Path mPath = new Path();
  late double startX;
  late double startY;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CaptureScreenPage"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              RepaintBoundary(
                key: captureKey,
                child: Card(
                  elevation: 5,
                  color: Colors.yellow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: EdgeInsets.all(80),
                    child: Text("我是内容 "),
                  ),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  pngBytes = await _capturePng(captureKey);
                  setState(() {});
                },
                child: Text("截取上面内容"),
              ),
              pngBytes == null
                  ? Container()
                  : RepaintBoundary(
                      key: captureAfterPaintKey,
                      child: GestureDetector(
                        onPanStart: (dragStartDetails) {
                          mPath.reset();
                          startX = dragStartDetails.localPosition.dx;
                          startY = dragStartDetails.localPosition.dy;
                          print("start startX $startX startY $startY");
                          mPath.moveTo(startX, startY);
                        },
                        onPanUpdate: (dragUpdateDetails) {
                          setState(() {
                            var currentX = dragUpdateDetails.localPosition.dx;
                            var currentY = dragUpdateDetails.localPosition.dy;
                            print(
                                "update  (currentX + startX) / 2  ${(currentX + startX) / 2}  (currentY + startY) / 2  ${(currentY + startY) / 2} currentX $currentX currentY $currentY  ");
                            //使用quadraticBezierTo 比lineto相对平滑
                            mPath.quadraticBezierTo((currentX + startX) / 2,
                                (currentY + startY) / 2, currentX, currentY);
                            startX = currentX;
                            startY = currentY;
//                            mPath.lineTo(currentX, currentY);
                          });
                        },
                        child: ClipRect(
                          child: CustomPaint(
                            foregroundPainter: GesturePainter(mPath),
                            child: Image.memory(
                              pngBytes!,
                              scale: ui.window.devicePixelRatio,
                              gaplessPlayback: true,
                            ),
                          ),
                        ),
                      )),
              RaisedButton(
                onPressed: () async {
                  pngAfterPaintBytes = await _capturePng(captureAfterPaintKey);
                  setState(() {});
                },
                child: Text("截取涂鸦后的内容"),
              ),
              pngAfterPaintBytes == null
                  ? Container()
                  : Image.memory(
                      pngAfterPaintBytes!,
                      scale: ui.window.devicePixelRatio,
                      gaplessPlayback: true,
                    )
            ],
          ),
        ),
      ),
    );
  }

  ///参考[repaint_boundary_analysis.dart]
  ///toImage [pixelRatio] 逻辑像素与输出图片大小的比  设置为[window.devicePixelRatio]可以显示清楚，但图片变大
  ///同时显示图片的sale设置为[window.devicePixelRatio]，可以显示为截取大小
  ///调用[OffsetLayer.toImage]，然后调用[ui.Scene.toImage]
  ///TODO compositing层  [ui.Scene.toImage] 生成光栅image
  Future<Uint8List?> _capturePng(GlobalKey currentKey) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    print("startTime $startTime");
    RenderRepaintBoundary boundary =
        currentKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    ByteData? bytesData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    var bytes = bytesData?.buffer.asUint8List();
    int stopTime = DateTime.now().millisecondsSinceEpoch;
    print("stopTime $stopTime   duration ${stopTime - startTime}");
    return bytes;
  }
}

class GesturePainter extends CustomPainter {
  Paint mPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  Path mPath;

  GesturePainter(this.mPath);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(mPath, mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
