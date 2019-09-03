import 'package:flutter/material.dart';
import 'dart:math' as math;

class TransformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Transform可以在其子Widget绘制时对其应用一个矩阵变换（transformation），Matrix4是一个4D矩阵，通过它我们可以实现各种矩阵操作

//    Transform的变换是应用在绘制阶段，而并不是应用在布局(layout)阶段，
//        所以无论对子widget应用何种变化，其占用空间的大小和在屏幕上的位置都是固定不变的，因为这些是在布局阶段就确定的
    //  多个widget,一个变化会覆盖，而不会重新布局

//    由于矩阵变化只会作用在绘制阶段，所以在某些场景下，在UI需要变化时，可以直接通过矩阵变化来达到视觉上的UI改变，
//    而不需要去重新触发build流程，这样会节省layout的开销，所以性能会比较好。但是大小和位置不变
//    如之前介绍的Flow flutter.widget，它内部就是用矩阵变换来更新UI，除此之外，Flutter的动画widget中也大量使用了Transform以提高性能。
    return Scaffold(
      appBar: AppBar(
        title: Text("TransformationPage"),
      ),
      body: Column(
        children: <Widget>[
          //倾斜
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.black,
              child: new Transform(
                alignment: Alignment.topRight, //相对于坐标系原点的对齐方式
                transform: new Matrix4.skewY(0.3), //沿Y轴倾斜0.3弧度
                child: new Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.deepOrange,
                  child: const Text('Apartment for rent!'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.black,
              child: new Transform(
                alignment: Alignment.topLeft, //相对于坐标系原点的对齐方式
                transform: new Matrix4.skewY(0.3), //沿Y轴倾斜0.3弧度
                child: new Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.deepOrange,
                  child: const Text('Apartment for rent!'),
                ),
              ),
            ),
          ),
          //平移
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              //默认原点为左上角，左移20像素，向上平移5像素
              child: Transform.translate(
                offset: Offset(-20.0, -5.0),
                child: Text("Hello world"),
              ),
            ),
          ),
          //旋转
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.red),
              //绕x,y轴旋转时，角度90，view垂直屏幕时不限时，没有厚度？？？

              //绕z轴旋转
              child: Transform.rotate(
                //旋转90度
                angle: math.pi / 2,
                child: Text("Hello world"),
              ),
            ),
          ),

          //缩放
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                child: Transform.scale(
                    scale: 1.5, //放大到1.5倍
                    child: Text("Hello world"))),
          ),

          // transform在绘制阶段，这时text已经layout完成，会出现重叠
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DecoratedBox(
                  decoration: BoxDecoration(color: Colors.red),
                  child: Transform.scale(scale: 1.5, child: Text("Hello world"))),
              Text(
                "你好",
                style: TextStyle(color: Colors.green, fontSize: 18.0),
              )
            ],
          ),

//          RotatedBox的变换是在layout阶段，会影响在子widget的位置和大小
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(color: Colors.red),
                //将Transform.rotate换成RotatedBox
                child: RotatedBox(
                  quarterTurns: 1, //旋转90度(1/4圈)
                  child: Text("Hello world"),
                ),
              ),
              Text(
                "你好",
                style: TextStyle(color: Colors.green, fontSize: 18.0),
              )
            ],
          ),

//          FractionalTranslation  在painting 之前 移动子child
          Container(
            color: Colors.black12,
            child: FractionalTranslation(
              translation: Offset(0.25, 0),
              child: Text("hello"),
            ),
          ),

          /// FittedBox  缩放和放置 子child
          Container(
            width: 150,
            height: 100,
            color: Colors.black12,
            child: FittedBox(
              fit: BoxFit.fill,

              /// 放大child至parent大小
              alignment: Alignment.center,
              child: Text("test"),
            ),
          ),

          //todo 变换嵌套， 第二个坐标系是否发生变化，第二个角度是相对于第一个还是第二个， rotationx ,totationx
        ],
      ),
    );
  }
}
