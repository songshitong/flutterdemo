import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

class CanvasPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Canvas"),
      ),
      body: CanvasWidget(),
    );
  }
}

///
/// save()
///save() 操作会保存此前的所有绘制内容和 Canvas 状态。
///在调用该函数之后的绘制操作和变换操作，会重新记录。
///当你调用 restore() 之后，会把 save() 到 restore() 之间所进行的操作与之前的内容进行合并
///
///save() 并不会创建新的图层，和 saveLayer() 是不同的
///
/// saveLayer()
/// saveLayer() 在大多数情况下看起来和 save() 的效果是差不多的。
/// 不同的是 saveLayer() 会创建一个新的图层。在 saveLayer() 到 restore() 之间的操作，是在新的图层上进行的，虽然最终它们还是会合成到一起
/// Paint，其 ColorFilters 和 BlendMode 配置会在图层合成的时候生效。其中，前面的图层为 dst，本图层为 src
/// 如果 Paint 没有设置混合参数，新图层就相当于仅仅是盖在了前面的图层之上
///
/// restore
/// 在调用 save() 或者 saveLayer() 必须调用 restore() 来合成，否则 Flutter 会抛出异常。
///值得注意的是，每一个 save() 或者 saveLayer() 都必须有一个对应的 restore()

class CanvasWidget extends StatefulWidget {
  @override
  _CanvasPageState createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasWidget> {
  ui.Image jinxImage;
  @override
  void initState() {
    super.initState();
    load(MyImgs.JINX).then((image) {
      setState(() {
        jinxImage = image;
      });
    });
  }

  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    print(
        "MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width} MediaQuery.of(context).size.height ${MediaQuery.of(context).size.height}");
    //一个提供canvas的widget
    return CustomPaint(
      //背景画笔，会显示在子节点后面
      painter: MyPainter(jinxImage),
      //前景画笔，会显示在子节点前
      foregroundPainter: null,
      //当child为null时，代表默认绘制区域大小，如果有child则忽略此参数，画布尺寸则为child尺寸。
      // 如果有child但是想指定画布为特定大小，可以使用SizeBox包裹CustomPaint实现
      size: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      //如果CustomPaint有子节点，为了避免子节点不必要的重绘，
      // 通常情况下都会将子节点包裹在RepaintBoundary Widget中来隔离子节点和CustomPaint本身的绘制边界
//      child: RepaintBoundary(),
      isComplex: true,
      //isComplex：是否复杂的绘制，如果是，Flutter会应用一些缓存策略来减少重复渲染的开销
      willChange: true, //willChange：和isComplex配合使用，当启用缓存时，该属性代表在下一帧中绘制是否会改变
    );
  }
}

///canvas 可以超出绘制，clip默认阻止child超出绘制
class MyPainter extends CustomPainter {
  ui.Image image;

  MyPainter(this.image);

  var myPaint = Paint()
    ..color = Colors.red
    ..isAntiAlias = true
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke;

  TextPainter textPainter;
  @override
  void paint(Canvas canvas, Size size) {
//    size当前绘制区域大小。
    canvas.drawCircle(Offset(50, 50), 50, myPaint);
    canvas.drawColor(Colors.black26, BlendMode.colorBurn);
    canvas.drawArc(Rect.fromLTRB(0, 0, 50, 50), 0, 2 * math.pi * 15 / 18, false,
        myPaint); //使用 2pi角度
    canvas.drawRect(Rect.fromLTRB(0, 100, 100, 200), myPaint);
    canvas.save();
    //rotate的中心默认在左上角，给一个view旋转时会绕左上角旋转
    // 1 外部嵌套一个Align alignment设为Alignment.center 此时画布的中心为中心，但是坐标系原点也是中心了
    // 2 计算偏移
    //将要旋转的角度
    var angle = math.pi / 4;
    double rectW = 100;
    double rectH = 100;
    print("size $size");
    //画布中心到左上角距离 直角三角形
    var r = math.sqrt(size.width * size.width + size.height * size.height) / 2;
    print("r $r");
    //画布中心的起始角度 画布不是正方形,一般不是45  也可以是长宽除以半径
    var startAngle = math.atan(size.height / size.width);
    print("startAngle $startAngle");
    var startX = r * math.cos(startAngle);
    var startY = r * math.sin(startAngle);
    //startX  startY 就是size.width/2，size.height/2
    print(
        "startX $startX  startY $startY  size.width/2 ${size.width / 2} size.height/2 ${size.height / 2}");
    //旋转后的角度
    var endAngle = startAngle + angle;
    print("endAngle $endAngle");

    //旋转后画布的中心坐标
    var endY = r * math.sin(endAngle);
    var endX = r * math.cos(endAngle);
    print("endx $endX endy $endY");
    //平移画布中心的距离
    canvas.translate(startX - endX, startY - endY);
    //正方向是顺时针，     90度会出现精度问题，绘制出现错乱，使用pi
    canvas.rotate(angle);
    //绘制后是rect围绕画布中心angle的角度
    canvas.drawRect(Rect.fromLTWH(0, 100, rectW, rectH), myPaint);

    canvas.restore();

    canvas.saveLayer(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2), radius: 60),
        Paint()
          ..color = Colors.red
          ..blendMode = BlendMode.exclusion);
    canvas.drawPaint(Paint()..color = Colors.amber);

    canvas.restore();
    myPaint.strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height / 2),
        Offset(size.width, size.height / 2), myPaint);
    //写字
    //1 Paragraph
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr))
      ..addText("text from  paragraph")
      ..pushStyle(ui.TextStyle(color: Colors.purple)) //将给定样式应用于添加的文本，直到调用[pop]
      ..pop() //结束最近调用[pushStyle]的效果
      ..pushStyle(ui.TextStyle(color: Colors.black));
    ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: 100));
    canvas.drawParagraph(paragraph,
        Offset(size.width / 2, size.height / 2 - paragraph.height / 2));
    //2 TextPainter       textAlign和textDirection必须非空
    textPainter = TextPainter()
      ..textAlign = TextAlign.center
      ..textDirection = TextDirection.ltr
      ..ellipsis = "..." //超出显示
      ..maxLines = 1
      ..strutStyle = StrutStyle.fromTextStyle(
          TextStyle()) //构建一个提供的[textStyle]包含等效属性值的StrutStyle
      //设置多个text把前面的覆盖了
      ..text = TextSpan(
          text: "text from textPainter",
          style: TextStyle(color: Colors.black),
          children: <InlineSpan>[
            //recognizer 没有实际分发，不会生效，一般是RichText的RenderParagraph的handleEvent方法
            TextSpan(
                text: "inline text",
                recognizer: TapGestureRecognizer()
                  ..onTap = () => print('inline text onTap'))
          ]);

    //计算用于绘制文本的字形的可视位置 minWidth/maxWidth 长度限制
    textPainter.layout(minWidth: 0, maxWidth: 300);
    //返回从文本顶部到///给定类型的第一个基线的距离
    double baseDis =
        textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    textPainter.paint(canvas,
        Offset(10, size.height / 2 - textPainter.size.height / 2 + 100));
    myPaint.style = PaintingStyle.fill;
    //textPainter.size 是textPainter.width和height的集合
    canvas.drawRect(
        Rect.fromLTWH(0, size.height / 2 - textPainter.height / 2, 20,
            textPainter.size.height),
        myPaint);
    print(
        "baseDis $baseDis size ${textPainter.size}   baseline到底部textPainter.height-baseDis ${textPainter.height - baseDis}");

    //设置maxLines后，超过maxLines返回true
    textPainter.didExceedMaxLines;

    canvas.drawImage(image, Offset(0, 0), myPaint);
    //将图片的哪一部分绘制到哪
    canvas.drawImageRect(
        image,
        ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromCenter(
            center: Offset(100, 100),
            width: image.width.toDouble(),
            height: image.height.toDouble()),
        myPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
//    尽可能的利用好shouldRepaint返回值；
// 在UI树重新build时，控件在绘制前都会先调用该方法以确定是否有必要重绘；
// 假如我们绘制的UI不依赖外部状态，那么就应该始终返回false，因为外部状态改变导致重新build时不会影响我们的UI外观；
// 如果绘制依赖外部状态，那么我们就应该在shouldRepaint中判断依赖的状态是否改变，如果已改变则应返回true来重绘，反之则应返回false不需要重绘
    return false;
  }

  //todo Paint.filterQuality   image fliterquality
}
