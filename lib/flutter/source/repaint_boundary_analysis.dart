import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class RepaintBoundaryAnalysis extends StatelessWidget {
  GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: null));
    return Container(
      //为他的child创建一个分离的展示列表，如果子树和包围他的部分在不同的时间重绘，则可以提高性能
      //使用1 构造器
      //2 类方法 RepaintBoundary.wrap
      //3 类方法 RepaintBoundary.wrapAll 包裹一个widget列表
      child: RepaintBoundary(
        key: globalKey,
      ),
    );
  }

  //使用repaintBoundary转为png图片
  //1 使用RepaintBoundary包裹要截图的图片
  //2 RenderRepaintBoundary.toImage()
  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
  }
}
