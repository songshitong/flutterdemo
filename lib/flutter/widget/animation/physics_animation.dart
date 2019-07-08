import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class Physics_Animation extends StatefulWidget {
  @override
  _Physics_AnimationState createState() => _Physics_AnimationState();
}

class _Physics_AnimationState extends State<Physics_Animation> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Simulation simulation;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, lowerBound: 50, upperBound: 150)
      ..addListener(() {
        setState(() {});
      });

    print("_controller velocity ${_controller.velocity}");
    _controller.addStatusListener((status) {
      print("status $status");
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Simulation 物理模拟的基类
  //   SpringSimulation 弹簧模拟--胡克定律  起始距离参数start和结束距离end参数的单位是任意的，但必须与系统中其他长度使用的单位一致
//            速度velocity的单位是L / T，其中L是上述任意长度单位，T是用于驱动 [SpringSimulation]的时间单位，正数是弹簧收缩的方向，负数则相反
//              SpringDescription描述弹簧常数的结构 mass 质量  stiffness刚性  damping ratio 阻尼比
//                SpringDescription.withDampingRatio 比率为1.0会产生一个临界阻尼弹簧，> 1.0 会产生一个过阻尼弹簧而<1.0一个欠阻尼弹簧
  //  ClampingScrollSimulation   与Android匹配的滚动物理实现
  //  BouncingScrollSimulation   与iOS匹配的滚动物理实现
  //  GravitySimulation   应用恒定加速力的模拟  例如模拟遵循牛顿第二运动定律的粒子

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("physics animation"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              _controller.fling();
            },
            child: Text("start fling"),
          ),
          RaisedButton(
            onPressed: () {
              simulation = SpringSimulation(
                SpringDescription.withDampingRatio(
                    mass: 1, stiffness: Stiffness.STIFFNESS_MEDIUM_LOW, ratio: DampingRatio.DAMPING_RATIO_HIGH_BOUNCY),
                50,
                150,
                _controller.velocity,
              );
              _controller.animateWith(simulation);
            },
            child: Text("start spring"),
          ),
          RaisedButton(
            onPressed: () {
              simulation = GravitySimulation(980, 50, 150, 0);
              _controller.animateWith(simulation);
            },
            child: Text("start Gravity Simulation"),
          ),
          RaisedButton(
            onPressed: () {
              _controller.reset();
            },
            child: Text("reset"),
          ),
          Transform.translate(
            offset: Offset(200, _controller.value),
            child: Container(
              decoration: BoxDecoration(color: Colors.amber),
              child: Text("i am container"),
            ),
          ),
        ],
      ),
    );
  }
}

//todo 计算公式证明  https://www.jianshu.com/p/c2962a8135f5
//https://zh.wikipedia.org/wiki/%E9%98%BB%E5%B0%BC%E6%AF%94
//https://courses.lumenlearning.com/boundless-physics/chapter/hookes-law/

//ζ = 0的时候就是无限来回运动，0< ζ <1的时候会出现来回减弱的振荡最后停止，ζ >= 1的时候会在靠近原位置的时候提前减速后停止
class DampingRatio {
//  一个非常有弹性的弹簧的阻尼比。对于欠阻尼弹簧*（即阻尼比<1）的注意事项，阻尼比越低，弹簧的弹性越大
  static const double DAMPING_RATIO_HIGH_BOUNCY = 0.2;

//   中等弹性弹簧的阻尼比对于欠阻尼弹簧（即阻尼比<1）的注意事项，阻尼比越低，弹簧的弹性越大
  static const double DAMPING_RATIO_MEDIUM_BOUNCY = 0.5;

//   具有低弹性的弹簧的阻尼比。对于欠阻尼弹簧（即阻尼比<1）的注意事项，阻尼比越低，弹跳越高
  static const double DAMPING_RATIO_LOW_BOUNCY = 0.75;

//   弹簧的阻尼比没有弹性。这种阻尼比将产生一个临界*阻尼弹簧，在最短的时间内恢复平衡而不会发生振荡
  static const double DAMPING_RATIO_NO_BOUNCY = 1;
}

//刚度(劲度/弹性)，刚度越大，形变产生的力也就越大，体现在效果上就是运动越快
class Stiffness {
//  极其坚硬的弹簧的刚度常数
  static const double STIFFNESS_HIGH = 10000;

//  中等刚度弹簧的刚度常数
  static const double STIFFNESS_MEDIUM = 1500;

//  刚度低的弹簧的刚度常数
  static const double STIFFNESS_LOW = 200;

  static const double STIFFNESS_MEDIUM_LOW = 100;

//  刚度非常低的弹簧的刚度常数
  static const double STIFFNESS_VERY_LOW = 50;
}
