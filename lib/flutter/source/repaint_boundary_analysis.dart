import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class RepaintBoundaryAnalysis extends StatelessWidget {
  GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      //为他的child创建一个分离的展示列表，如果子树和包围他的部分在不同的时间重绘，则可以提高性能
      //原理RenderObject中isRepaintBoundary默认为false，RepaintBoundary的renderObject--RenderRepaintBoundary
      // 将isRepaintBoundary置为true
      //renderobject 会在paintChild进行isRepaintBoundary的判断，true调用_compositeChild，如果子节点需要绘制(_needsPaint为true)
      // 则给子节点创建一个layer ，然后再上面绘制子节点，不需要绘制则无操作由此可见独立绘制是通过在不同的layer（层）上绘制的
      //_needsPaint在markNeedsPaint中标记为true，isRepaintBoundary为 true，将renderObject本身加入owner的_nodesNeedingPaint
      //isRepaintBoundary为false，父节点是RenderObject则标记绘制markNeedsPaint，否则自己是根节点通过owner.requestVisualUpdate
      //直接重绘自己

      //使用1 构造器
      //2 类方法 RepaintBoundary.wrap
      //3 类方法 RepaintBoundary.wrapAll 包裹一个widget列表
      child: RepaintBoundary(
        key: globalKey,
      ),
    );
  }

//  将滚动列表的widget显示，有可能只显示一半的情况
//  Scrollable.ensureVisible(context);  原理寻找viewPort

  //TODO 加入isolate 是否会卡主，是否卡loading？
  //使用repaintBoundary转为png图片
  //1 使用RepaintBoundary包裹要截图的图片,设置key为globalKey
  //2 RenderRepaintBoundary.toImage()
  Future<void> _capturePng() async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
//    png是压缩后格式，如果需要图片的原始像素数据，请使用rawRgba
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    Image.memory(pngBytes);
//    File file;
//    file.writeAsBytes(pngBytes);
  }
}
