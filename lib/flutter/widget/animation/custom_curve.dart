import 'dart:ui';

import 'package:flutter/material.dart';

class CustomCurvePage extends StatefulWidget {
  @override
  _CustomCurvePageState createState() => _CustomCurvePageState();
}

class _CustomCurvePageState extends State<CustomCurvePage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  Animation<Color> _colorAnimation;
  Animation<TextStyle> _styleAnimation;
  Animation<double> tweenSequenceAnimations;
  @override
  void initState() {
    //1  构造controller 通过drive，将tween连接到controller
//    _controller = AnimationController(vsync: this)..drive(CurveTween(curve: CustomCurve()));

    //2
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 6));
    _animation = CurveTween(curve: CustomCurve()).animate(_controller)
      ..addListener(() {
//        print("value ${_animation.value}");
        setState(() {});
      });

    //chain 将多个tween作用于同一Animation
    //不加chain  颜色渐变
    //加chain  颜色以CustomCurve的曲线进行变化
    _colorAnimation =
        ColorTween(begin: Colors.green, end: Colors.red).chain(CurveTween(curve: CustomCurve())).animate(_controller);
    _styleAnimation = TextStyleTween(begin: TextStyle(fontSize: 10), end: TextStyle(fontSize: 30)).animate(_controller);

//    例如，定义使用缓动曲线的动画在前40％的时间内插值介于5.0和10.0之间动画，在接下来的20％中保持10.0，然后最后的40％返回10.0
    tweenSequenceAnimations = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 50.0, end: 100.0).chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(100.0),
          weight: 20.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween<double>(begin: 100.0, end: 50.0).chain(CurveTween(curve: Curves.ease)),
          weight: 40.0,
        ),
      ],
    ).animate(_controller);
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
      appBar: AppBar(
        title: Text("custom curve"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              _controller.forward();
            },
            child: Text("开始"),
          ),
          RaisedButton(
            onPressed: () {
              _controller.reset();
            },
            child: Text("reset"),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              height: 100 * _animation.value + 10,
              decoration: BoxDecoration(color: _colorAnimation.value),
              child: Text(
                "我是一",
                style: _styleAnimation.value,
              )),
          Padding(padding: EdgeInsets.only(top: 50)),
          Container(
              width: MediaQuery.of(context).size.width,
              height: tweenSequenceAnimations.value,
              decoration: BoxDecoration(color: Colors.purple),
              child: Text(
                "test TweenSequence",
                style: TextStyle(fontSize: 30),
              )),

          ///AnimatedBuilder 提高重用，减少setState范围及次数，限定了rebuild的范围
          ///child 给builer中使用
          /// 在builder中给child增加container控制大小，transform,transition各种动画，实现动画和组件的分离，而不是将动画和组件糅合在一起
          ///
          AnimatedBuilder(
            animation: null,
            builder: (BuildContext context, Widget child) {},
            child: Text(""),
          )
        ],
      ),
    );
  }
}

//缓和曲线，即单位间隔到单位间隔的映射
//缓动曲线用于调整动画的时间变化率，允许他们加速和减速，而不是以恒定速率移动
//曲线必须映射t = 0.0到0.0和t = 1.0到1.0
class CustomCurve extends Curve {
  //返回在t时间点的值
  @override
  double transformInternal(double t) {
    if (t <= 0.3) {
      return 0.3;
    } else if (t <= 0.6) {
      return 0.6;
    } else if (t <= 1) {
      return 1.0;
    }
  }
}
