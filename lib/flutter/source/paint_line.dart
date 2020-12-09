import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///测试 [paint_context.md]的绘制流程
void main() {
  // testSimple();
  testPaintingContext();
}

///todo 弄清此段代码的效果
///[PaintingContext.repaintCompositedChild]的流程
void testPaintingContext() {
  ContainerLayer containerLayer = ContainerLayer();
  PaintingContext paintingContext = PaintingContext(containerLayer, Rect.zero);

  Paint circle1Paint = Paint();
  circle1Paint.color = Colors.blue;

  // 注释1
  // paintingContext.canvas.save();

  // 对画布进行裁剪  矩形
  //
  paintingContext.canvas.clipRect(
      Rect.fromCenter(center: Offset(400, 400), width: 280, height: 600));

  // 在裁剪后的画布上画一个⭕️ 蓝色
  //
  paintingContext.canvas.drawCircle(Offset(400, 400), 300, circle1Paint);

  // 注释2
  // paintingContext.canvas.restore();

  //画个红色的圆
  void _painter(PaintingContext context, Offset offset) {
    Paint circle2Paint = Paint();
    circle2Paint.color = Colors.red;
    context.canvas.drawCircle(Offset(400, 400), 250, circle2Paint);
  }

  // 通过 pushClipRect 方法再次执行裁剪
  // 注意此处 needsCompositing 参数为 true
  //
  paintingContext.pushClipRect(
    true,
    Offset.zero,
    Rect.fromCenter(center: Offset(500, 400), width: 200, height: 200),
    _painter,
  );

  Paint circle3Paint = Paint();
  circle3Paint.color = Colors.yellow;

  // 再次画一个⭕️ 黄色
  //
  paintingContext.canvas.drawCircle(Offset(400, 800), 300, circle3Paint);
  paintingContext.stopRecordingIfNeeded();

  SceneBuilder sceneBuilder = SceneBuilder();

  //从layer生成scene
  //源码注释
  /// Consider this layer as the root and build a scene (a tree of layers)
  /// in the engine.
  // The reason this method is in the `ContainerLayer` class rather than
  // `PipelineOwner` or other singleton level is because this method can be used
  // both to render the whole layer tree (e.g. a normal application frame) and
  // to render a subtree (e.g. `OffsetLayer.toImage`).
  Scene scene = containerLayer.buildScene(sceneBuilder);
  window.onDrawFrame = (() {
    window.render(scene);
  });
  window.scheduleFrame();
}

void testSimple() {
  PictureRecorder recorder = PictureRecorder();

  ///创建canvas
  Canvas canvas = Canvas(recorder);
  canvas.drawCircle(Offset(50, 50), 50, Paint()..color = Colors.red);
  Picture picture = recorder.endRecording();

  ///生成scene
  SceneBuilder sceneBuilder = SceneBuilder();
  sceneBuilder.addPicture(Offset.zero, picture);
  Scene scene = sceneBuilder.build();
  window.onDrawFrame = (() {
    window.render(scene);
  });
  window.scheduleFrame();
}
