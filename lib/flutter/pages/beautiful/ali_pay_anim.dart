import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

///浇水动画
///水滴存在初始速度，下落过程是加速度
/// 动画时长设定后，每次的速度计算应该与动画时间脱离关系，总动画时长>水滴落下的时间
///  每次绘制 速度=v+加速度   移动距离=移动距离+v
///
/// 下雨动画    人们看到的雨一般是匀速运动，下落重力与空气摩擦抵消
///           倾斜角度=x速度/y速度
///
///
/// 对象回收使用 建立一屏幕水滴数量，超出范围回收，回收时状态重置
class ApiPayAnim extends StatefulWidget {
  @override
  _ApiPayAnimState createState() => _ApiPayAnimState();
}

class _ApiPayAnimState extends State<ApiPayAnim>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late TreeScaleTween treeScaleTween;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    treeScaleTween = TreeScaleTween(1.0, 1.1);
    treeScaleTween.animate(_controller);
    _controller.addListener(() {
      setState(() {});
      print("_controller ${_controller.value}");
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("ApiPayAnim"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            child: GestureDetector(
                onTap: () {
                  _controller.forward();
                },
                child: SizedBox(
                  width: 160,
                  height: 195 * treeScaleTween.evaluate(_controller) as double,
                  child: Image.asset(
                    MyImgs.green_home_sapling_little,
                    fit: BoxFit.fill,
                  ),
                )),
          ),
          Positioned(bottom: 50, child: WaterDropWidget())
        ],
      ),
    );
  }
}

///动画数值
class TreeScaleTween extends Tween {
  ///弹簧系数

  double factor = 0.4;

  @override
  lerp(double input) {
    double trans = -(math.pow(2, -10 * input) *
        math.sin((input - factor / 4) * (2 * math.pi) / factor));
    print("TreeScaleTween lerp trans $trans");
    return super.lerp(trans);
  }

  TreeScaleTween(double begin, double end) : super(begin: begin, end: end);
}

class WaterDropWidget extends StatefulWidget {
  @override
  _WaterDropWidgetState createState() => _WaterDropWidgetState();
}

class WaterDrop {
  late double xInitSpeed;
  double yInitSpeed = 0;
  double ySpeed = 0;
  double xOffset = 100;
  double yOffset = 0;
  final double dropAccelerationSpeed = 0.8;

  void reset() {
    this.yOffset = 0;
    this.ySpeed = this.yInitSpeed;
    this.xOffset = 100;
  }

  @override
  String toString() {
    return 'WaterDrop{xInitSpeed: $xInitSpeed, yInitSpeed: $yInitSpeed, ySpeed: $ySpeed, xOffset: $xOffset, yOffset: $yOffset, dropAccelerationSpeed: $dropAccelerationSpeed}';
  }
}

class _WaterDropWidgetState extends State<WaterDropWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<WaterDrop> waters;
  ui.Image? waterImage;
  List<Offset>? offsets;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    waters = List<WaterDrop>.generate(10, (index) {
      ///0-1
      var yInitSpeed = math.Random.secure().nextDouble() / 20;
      return WaterDrop()
        ..xInitSpeed = -math.Random.secure().nextDouble() * 3
        ..yInitSpeed = yInitSpeed
        ..ySpeed = yInitSpeed;
    });
    _controller.addListener(() {
      setState(() {});
      offsets = [];
      waters.forEach((waterDrop) {
        waterDrop.xOffset += waterDrop.xInitSpeed;
        waterDrop.ySpeed += waterDrop.dropAccelerationSpeed;
        waterDrop.yOffset += waterDrop.ySpeed;

        ///超出屏幕，从头开始
        if (waterDrop.yOffset > 100) {
          waterDrop.reset();
        }

        ///对dx做限制
        if (waterDrop.xOffset > 50) {
          offsets!.add(Offset(
              waterDrop.xOffset.toDouble(), waterDrop.yOffset.toDouble()));
        } else {
          waterDrop.reset();
        }
      });
      print("waters $waters");
    });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
    load(MyImgs.water).then((image) {
      waterImage = image;
      _controller.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          left: 100,
          top: -69,
          child: Image.asset(
            MyImgs.water_container,
            width: 82,
            height: 69,
          ),
        ),
        CustomPaint(
          painter: WaterDropPaint(offsets, waterImage),
          size: Size(100, 100),
        ),
      ],
    );
  }

  ///
  Future<ui.Image> load(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: 7, targetHeight: 9);
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }
}

class WaterDropPaint extends CustomPainter {
  late Paint mPaint;
  List<Offset>? waters;
  ui.Image? waterImage;
  WaterDropPaint(this.waters, this.waterImage) {
    mPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (null != waters) {
      waters!.forEach((offset) {
//        print("offset $offset");
        canvas.drawImage(waterImage!, offset, mPaint);
      });
    }
  }

  @override
  bool shouldRepaint(WaterDropPaint oldDelegate) {
    return oldDelegate.waters != waters || oldDelegate.waterImage != waterImage;
  }
}
