import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

import 'package:flutterdemo/flutter/common/MyImgs.dart';
import 'package:flutterdemo/flutter/common/transform.dart';
import 'package:flutterdemo/flutter/widget/animation/physics_animation.dart';

//todo 矩阵变换https://zh.wikipedia.org/wiki/%E5%8F%98%E6%8D%A2%E7%9F%A9%E9%98%B5
//https://en.wikipedia.org/wiki/Transformation_matrix

//齐次坐标
//https://zh.wikipedia.org/wiki/%E9%BD%90%E6%AC%A1%E5%9D%90%E6%A0%87
//https://en.wikipedia.org/wiki/Homogeneous_coordinates

//todo 透视效果  opengl层 提供makePerspectiveMatrix，但很复杂，可以直接设置matrix.Matrix4.identity()
//                        ..setEntry(3, 2, 0.001)
//                        ..rotateX(angle)

class FoldCellPage extends StatelessWidget {
  GlobalKey<FoldCellState> _key = GlobalKey<FoldCellState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("fold cell"),
        ),
        body: Column(children: <Widget>[
          RaisedButton(
            onPressed: () {
              _key.currentState?.open();
            },
            child: Text("start"),
          ),
          RaisedButton(
            onPressed: () {
              _key.currentState?.close();
            },
            child: Text("reset"),
          ),
          FoldCell(
            key: _key,
            front: const CellContent(MyImgs.TEST, "i am front"),
            backagoundTop: const CellContent(MyImgs.JINX, "i am background top"),
            backagoundBottom: const CellContent(MyImgs.IMG1, "i am background bottom"),
          ),
        ]));
  }
}

class FoldCell extends StatefulWidget {
  final Widget front;
  final Widget backagoundTop;
  final Widget backagoundBottom;

  FoldCell({this.front, this.backagoundTop, this.backagoundBottom, Key key}) : super(key: key);

  @override
  FoldCellState createState() => FoldCellState();
}

class FoldCellState extends State<FoldCell> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  CellState state = CellState.close;
  Simulation simulation;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    simulation = SpringSimulation(
      SpringDescription.withDampingRatio(mass: 1, stiffness: Stiffness.STIFFNESS_MEDIUM_LOW, ratio: 0.25),
      50,
      150,
      _animationController.velocity,
    );
    _animationController.addStatusListener((status) {
      print("111 AnimationStatus  status $status");

      if (status == AnimationStatus.dismissed) {
        print("status AnimationStatus.dismissed  state $state");

        //关闭动画完成后，视为close
        if (state == CellState.open) {
          setState(() {
            state = CellState.close;
          });
        }
      } else if (status == AnimationStatus.forward) {
        print("status AnimationStatus.forward  state $state");

        //展开动画开始，视为打开
        if (state == CellState.close) {
          setState(() {
            state = CellState.open;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void open() {
    _animationController.forward();
  }

  void close() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Stack(
        children: <Widget>[
          //后面上半部分
          Visibility(visible: state == CellState.open, child: widget.backagoundTop),
          //后面下半部分
          Visibility(
            visible: state == CellState.open,
            child: AnimatedBuilder(
              animation: _animationController,
              child: widget.backagoundBottom,
              builder: (context, child) {
                double angle = _animationController.value * math.pi;
                //翻转后background是倒的，在转动前预先绕z轴翻转180度一次，
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationZ(math.pi),
                  child: Transform(
                      alignment: Alignment.topCenter,
                      transform: TransformUtil.perspectiveRotateX(-angle),
                      child: child),
                );
              },
            ),
          ),
          //前面部分
          AnimatedBuilder(
              animation: _animationController,
              child: widget.front,
              builder: (context, child) {
                double angle = _animationController.value * math.pi;
                return Visibility(
                  visible: angle <= math.pi / 2,
                  child: Transform(
                      alignment: Alignment.bottomCenter, //透视使得更远的对象看起来更小
                      //透视效果将矩阵的第3行第2列设置为0.001，根据它们的距离缩小
                      //这个数字越大，透视越明显，这使得它看起来更接近被观察物体
                      transform: TransformUtil.perspectiveRotateX(angle),
                      child: child),
                );
              }),
        ],
      ),
    );
  }
}

enum CellState { close, open }

class CellContent extends StatelessWidget {
  final String title;
  final String img;
  const CellContent(this.img, this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.amber),
      width: 300,
      height: 236,
      child: Column(
        children: <Widget>[
          Image.asset(
            img,
            fit: BoxFit.fill,
          ),
          Text("$title"),
        ],
      ),
    );
  }
}
