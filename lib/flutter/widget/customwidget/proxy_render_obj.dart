import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///多文本复制粘贴
class ProxyRenderPage extends StatefulWidget {
  @override
  _ProxyRenderPageState createState() => _ProxyRenderPageState();
}

class _ProxyRenderPageState extends State<ProxyRenderPage> {
  GlobalKey _globalKey = GlobalKey();

  Offset? firstTap;

  @override
  Widget build(BuildContext context) {
    SelectableText selectableText;
    return SingleChildScrollView(
      child: GestureDetector(
        onLongPressStart: (longPressStartDetail) {
          print("longPressStartDetail ${longPressStartDetail.globalPosition}");
          firstTap = longPressStartDetail.localPosition;
          setState(() {});
        },
        child: ProxyRenderObj(
          flexKey: _globalKey,
          firstTap: firstTap,
          child: Column(
            ///todo 增加其他对齐方式
            crossAxisAlignment: CrossAxisAlignment.start,
            key: _globalKey,
            children: <Widget>[
              buildText("123"),
              buildText("456"),
              buildText("78910"),
              buildText("abcdefghi"),
              buildText("jklmnopq"),
              buildText("rstuvwxyz"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildText(i) => Text(
        "data $i",
        style: TextStyle(fontSize: 50),
      );
}

class ProxyRenderObj extends SingleChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRB(flexKey: this.flexKey, ft: this.firstTap);
  }

  ProxyRenderObj({required this.child, this.flexKey, this.firstTap})
      : super(child: child);
  Widget child;
  GlobalKey? flexKey;
  Offset? firstTap;
  @override
  void updateRenderObject(BuildContext context, CustomRB renderObject) {
    /// 设置 setSate 生效的
    super.updateRenderObject(context, renderObject);
    renderObject..flexKey = flexKey;
    renderObject..firstTap = firstTap;
  }
}

class CustomRB extends RenderProxyBox {
  GlobalKey? flexKey;
  Offset? _firstTap;

  Paint bgPaint = Paint()
    ..color = Colors.amber
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  Paint textPaint = Paint()
    ..color = Colors.red
    ..strokeWidth = 5
    ..style = PaintingStyle.fill;

  set firstTap(Offset? value) {
    _firstTap = value;
    markNeedsPaint();
  }

  CustomRB({RenderBox? child, this.flexKey, Offset? ft}) : super(child) {
    firstTap = ft;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (null != _firstTap) {
      print("_firstTap $_firstTap");

      //根据位置获取renderobj
      final HitTestResult result = new HitTestResult();
      WidgetsBinding.instance?.hitTest(result, _firstTap!);
      // Look for the RenderBoxes that corresponds to the hit target (the hit target
      // widgets build RenderMetaData boxes for us for this purpose).
      for (HitTestEntry entry in result.path) {
        if (entry.target is RenderParagraph) {
          final renderParagraph = entry.target as RenderParagraph;
          var textPosition = renderParagraph.getPositionForOffset(_firstTap!);
          print("hit position $textPosition");
          //获取文字边界
          var textRange = renderParagraph.getWordBoundary(textPosition);
          var hitText = (renderParagraph.text as TextSpan).text!;
          print("renderMetaData $hitText");
          print("renderMetaData textRange $textRange ");
          print("start 内容 ${hitText[textRange.start]}");
          if (textRange.end <= hitText.length) {
            print("  end ${hitText[textRange.end - 1]}");
          }
          List<TextBox> textBoxes = renderParagraph
              .getBoxesForSelection(TextSelection.fromPosition(textPosition));
          textBoxes.forEach((element) {
            print("textbox $element");
          });

          // context.canvas.drawRect(
          //     Rect.fromLTWH(_firstTap.dx, _firstTap.dy, textPaint., 50), textPaint);
        }
      }
    }
    super.paint(context, offset);
    var rb = flexKey!.currentContext?.findRenderObject();
    int i = 0;
    double countHeight = 0.0;
    BoxHitTestResult boxHitTestResult = BoxHitTestResult();
    if (rb is RenderFlex) {
      RenderBox? child = rb.firstChild;
      while (child != null) {
        if (null != _firstTap) {
          bool hit = child.hitTest(boxHitTestResult, position: _firstTap!);
          print("hit $hit index $i");
        }

        final FlexParentData childParentData =
            child.parentData as FlexParentData;
        final childWidth = child.size.width;
        final childHeight = child.size.height;

//        print("offset $offset");
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
              ui.TextStyle(color: Colors.yellow)) //将给定样式应用于添加的文本，直到调用[pop]
          ..pop(); //结束最近调用[pushStyle]的效果
        ui.Paragraph paragraph = builder.build()
          ..layout(ui.ParagraphConstraints(width: 100));
        context.canvas.drawParagraph(paragraph, Offset(childLeft, countHeight));
        child = childParentData.nextSibling;
        i++;
        countHeight += childHeight;
      }
    }
    // context.pushLayer(childLayer, super.paint, Offset.zero);
  }
}
