import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProxyRenderPage extends StatelessWidget {
  GlobalKey _globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ProxyRenderObj(
      flexKey: _globalKey,
      child: Column(
        key: _globalKey,
        children: <Widget>[
          Text("data 123413471023471"),
          Text("data 123413471023471"),
          Text("data 123413471023471"),
          Text("data 123413471023471"),
          Text("data 123413471023471"),
          Text("data 123413471023471"),
        ],
      ),
    );
  }
}

class ProxyRenderObj extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRB(flexKey: this.flexKey);
  }

  ProxyRenderObj({this.child, this.flexKey}) : super(child: child);
  Widget child;
  GlobalKey flexKey;
  @override
  void updateRenderObject(BuildContext context, CustomRB renderObject) {
    /// 设置 setSate 生效的
    super.updateRenderObject(context, renderObject);
    renderObject..flexKey = flexKey;
  }
}

class CustomRB extends RenderProxyBox {
  GlobalKey flexKey;
  Paint bgPaint = Paint()
    ..color = Colors.amber
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  Paint textPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 5
    ..style = PaintingStyle.fill;

  CustomRB({RenderBox child, this.flexKey}) : super(child);

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    context.canvas.drawColor(Colors.blue, BlendMode.color);
    var rb = flexKey.currentContext.findRenderObject();
    int i = 0;
    double countHeight = 0.0;
    if (rb is RenderFlex) {
      RenderBox child = rb.firstChild;
      while (child != null) {
        final FlexParentData childParentData = child.parentData;
        final childWidth = child.size.width;
        final childHeight = child.size.height;
//        final globalChildLeft = rb.globalToLocal(
//          Offset(rb.paintBounds.width, rb.paintBounds.height),
//        );
        print("offset $offset");
//        LogUtil.debug("globalChildLeft $globalChildLeft");
        final childLeft = offset.dx;

        if (countHeight == 0) {
          countHeight = offset.dy;
        }
        var rect =
            Rect.fromLTWH(childLeft, countHeight, childWidth, childHeight);
        print("rect $rect");
        context.canvas.drawRect(rect, bgPaint);
        ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
            textAlign: TextAlign.center, textDirection: TextDirection.ltr))
          ..addText("$i")
          ..pushStyle(
              ui.TextStyle(color: Colors.black)) //将给定样式应用于添加的文本，直到调用[pop]
          ..pop(); //结束最近调用[pushStyle]的效果
        ui.Paragraph paragraph = builder.build()
          ..layout(ui.ParagraphConstraints(width: 100));
        context.canvas.drawParagraph(paragraph, Offset(childLeft, countHeight));
        child = childParentData.nextSibling;
        i++;
        countHeight += childHeight;
      }
    }
  }
}
