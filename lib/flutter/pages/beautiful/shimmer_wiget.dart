import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

///微光闪烁效果   [https://juejin.im/post/5b552d516fb9a04fc9374978]
///
/// [Text]直接设置style中的foreground就可以了，前景和背景是一个paint
class ShimmerWidget extends StatefulWidget {
  @override
  _ShimmerWidgetState createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  double percent = 0.0;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.addListener(() {
      setState(() {
        percent = _animationController.value;
//        print("percent $percent");
      });
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shimmer Widget"),
      ),
      body: Shimmer(
        percent: _animationController.value,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            colors: [Colors.grey, Colors.yellow, Colors.red, Colors.white, Colors.purple],
            stops: [0.0, 0.35, 0.5, 0.65, 1.0]),
        child: Text("开始闪光吧！！！"),
      ),
    );
  }
}

class Shimmer extends SingleChildRenderObjectWidget {
  Gradient gradient;
  double percent;
  Shimmer({@required this.gradient, this.percent = 0.0, Widget child}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ShimmerFilter(gradient, percent);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter _shimmerFilter) {
    ///设置改变的属性
    _shimmerFilter..percent = percent;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  Gradient gradient;
  double _percent;
  Paint mPaint;
  Paint _clearPaint = Paint();
  _ShimmerFilter(this.gradient, this._percent) : mPaint = Paint()..blendMode = BlendMode.srcIn;

  set percent(double value) {
    _percent = value;
//    print("set percent ======");
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (child != null) {
//      print("paint start ======");
      final width = child.size.width;
      final height = child.size.height;
      Rect rect;
      double dx, dy;
      dx = _offset(-width, width, _percent);
      dy = 0.0;
      rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);
      mPaint.shader = gradient.createShader(rect);
      //offset & child.size 是 child.size位移offset
      //注掉saveLayer查看渐变的变化
      context.canvas.saveLayer(offset & child.size, _clearPaint);

      ///SingleChildRenderObjectWidget 比CustomPainter的优点是可以控制child的绘制时期
      context.paintChild(child, offset);
      context.canvas.translate(dx, dy);
      context.canvas.drawRect(rect, mPaint);
      context.canvas.restore();
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
