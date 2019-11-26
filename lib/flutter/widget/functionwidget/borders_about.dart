import 'package:flutter/material.dart';

///Decoration的子类
/// BoxDecoration(描述怎么绘制一个盒子)
/// ShapeDecoration(如何绘制任意形状)
/// UnderlineTabIndicator 选中tab下方的横线
///
///
/// 自定义BoxBorder
/// 自定义decoration
class DecorationAndBorders extends StatefulWidget {
  @override
  _DecorationAndBordersState createState() => _DecorationAndBordersState();
}

class _DecorationAndBordersState extends State<DecorationAndBorders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BordersPage"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 3, style: BorderStyle.solid)),
              child: Text("BoxDecoration decoration"),
            ),
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: BoxDecoration(
                border: CustomBoxBorder.all(color: Colors.red, width: 3, style: BorderStyle.solid),
              ),
              child: Text("BoxDecoration decoration"),
            ),
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: ShapeDecoration(
                shape: CircleBorder(side: BorderSide(color: Colors.purpleAccent, width: 3, style: BorderStyle.solid)),
              ),
              child: Text("ShapeDecoration decoration"),
            ),
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.purpleAccent, width: 3, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              child: Text("ShapeDecoration decoration  RoundedRectangleBorder"),
            ),
//    适用于应用程序的小部件矩形内体育场形状边框（两端有半圆的框）的边框。通常与[ShapeDecoration]一起用于绘制体育场边界如果矩形的高度大于宽度，
//        则半圆将位于顶部和底部，否则将位于左侧和右侧。
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: ShapeDecoration(
                shape: StadiumBorder(
                  side: BorderSide(color: Colors.purpleAccent, width: 3, style: BorderStyle.solid),
                ),
              ),
              child: Text("ShapeDecoration decoration  StadiumBorder"),
            ),

            //有平角或“斜角”的矩形边框。
            //连接矩形四边的线段将
            //起始点和位置偏移相应的边界半径，但不超过边的中心如果所有的边界半径超过了边的一半宽度/高度，则生成的形状是通过连接边的中心而成的菱形。
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: ShapeDecoration(
                shape: BeveledRectangleBorder(
                    side: BorderSide(color: Colors.purpleAccent, width: 3, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              child: Text("ShapeDecoration decoration  BeveledRectangleBorder"),
            ),
            //在直边和圆角之间具有平滑连续过渡的矩形边界。跟RoundedRectangleBorder是不太一样，在圆与边界的连接处
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: ShapeDecoration(
                shape: ContinuousRectangleBorder(
                    side: BorderSide(color: Colors.purpleAccent, width: 3, style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              child: Text("ShapeDecoration decoration  ContinuousRectangleBorder"),
            ),
            Container(
              margin: EdgeInsets.all(8),
              height: 50,
              decoration: UnderlineTabIndicator(borderSide: BorderSide(color: Colors.deepPurple)),
              child: Text("UnderlineTabIndicator decoration"),
            ),
            Container(
              margin: EdgeInsets.all(18),
              height: 50,
              decoration: CustomDecoration(),
              child: Text("custom decoration"),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDecoration extends Decoration {
  @override
  BoxPainter createBoxPainter([onChanged]) {
    return CustomBoxPainter();
  }
}

class CustomBoxPainter extends BoxPainter {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.drawRect(
        Rect.fromCircle(center: offset, radius: 20),
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
  }
}

//怎么绘制边    现在中心画个圆
class CustomBoxBorder extends BoxBorder {
  CustomBoxBorder({
    this.top = BorderSide.none,
    this.right = BorderSide.none,
    this.bottom = BorderSide.none,
    this.left = BorderSide.none,
  })  : assert(top != null),
        assert(right != null),
        assert(bottom != null),
        assert(left != null);

  factory CustomBoxBorder.all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
    BorderStyle style = BorderStyle.solid,
  }) {
    final BorderSide side = BorderSide(color: color, width: width, style: style);
    return CustomBoxBorder.fromBorderSide(side);
  }

  CustomBoxBorder.fromBorderSide(BorderSide side)
      : assert(side != null),
        top = side,
        right = side,
        bottom = side,
        left = side;
  //边的样式
  @override
  BorderSide top;
  @override
  BorderSide bottom;
  BorderSide right;
  BorderSide left;
  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.fromLTRB(left.width, top.width, right.width, bottom.width);
  }

//  边框的所有四个边是否都相同。统一边界是通常更有效地绘画
  @override
  bool get isUniform {
    final Color topColor = top.color;
    if (right.color != topColor || bottom.color != topColor || left.color != topColor) return false;

    final double topWidth = top.width;
    if (right.width != topWidth || bottom.width != topWidth || left.width != topWidth) return false;

    final BorderStyle topStyle = top.style;
    if (right.style != topStyle || bottom.style != topStyle || left.style != topStyle) return false;

    return true;
  }

  @override
  void paint(Canvas canvas, Rect rect,
      {TextDirection textDirection, BoxShape shape = BoxShape.rectangle, BorderRadius borderRadius}) {
    if (isUniform) {
      switch (top.style) {
        case BorderStyle.none:
          return;
        case BorderStyle.solid:
          switch (shape) {
            case BoxShape.circle:
              assert(borderRadius == null, 'A borderRadius can only be given for rectangular boxes.');
              paintBorderAndOther(canvas, rect);
              break;
            case BoxShape.rectangle:
              if (borderRadius != null) {
                paintBorderAndOther(canvas, rect);
                return;
              }
              paintBorderAndOther(canvas, rect);
              break;
          }
          return;
      }
    }

    assert(borderRadius == null, 'A borderRadius can only be given for uniform borders.');
    assert(shape == BoxShape.rectangle, 'A border can only be drawn as a circle if it is uniform.');
    paintBorderAndOther(canvas, rect);
  }

  void paintBorderAndOther(Canvas canvas, Rect rect) {
    paintOthor(canvas, rect);
    paintBorder(canvas, rect, top: top, right: right, bottom: bottom, left: left);
  }

  void paintOthor(Canvas canvas, Rect rect) {
    canvas.drawCircle(
        rect.center,
        20,
        Paint()
          ..color = Colors.red
          ..style = PaintingStyle.fill
          ..strokeWidth = 5);
  }

  @override
  ShapeBorder scale(double t) {
    return Border(
      top: top.scale(t),
      right: right.scale(t),
      bottom: bottom.scale(t),
      left: left.scale(t),
    );
  }
}
