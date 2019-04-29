import 'package:flutter/material.dart';

class BottomAppBarPage extends StatefulWidget {
  @override
  BottomAppBarPageState createState() {
    return new BottomAppBarPageState();
  }
}

class BottomAppBarPageState extends State<BottomAppBarPage> {
  List<FloatingActionButtonLocation> locations = [
    FloatingActionButtonLocation.centerDocked,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endTop,
    FloatingActionButtonLocation.miniStartTop,
    FloatingActionButtonLocation.startTop
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///设置 floatingaction的模式
      floatingActionButtonLocation: locations[index],
      appBar: AppBar(
        title: Text("底部凹陷"),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton(
              hint: Text(locations[index].toString()),
              items: List<DropdownMenuItem<int>>.generate(locations.length, (i) {
                String text = locations[i].toString();
                return DropdownMenuItem(value: i, child: Text(text));
              }),
              onChanged: (i) {
                setState(() {
                  index = i;
                });
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.repeat),
        shape: Triangle(BorderSide(style: BorderStyle.none)),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: CustomsNotched(),
        // BeveledRectangleBorder() 角为斜角或扁平角
        // 底部导航栏打一个圆形的洞 CircularNotchedRectangle
        // 打个圆角矩形 AutomaticNotchedShape(RoundedRectangleBorder(), RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.home)),
            SizedBox(), //中间位置空出 用来存放凹陷的按钮
            IconButton(icon: Icon(Icons.business)),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
        ),
      ),
    );
  }
}

class CustomsNotched extends NotchedShape {
  //在host上面打出guest形状的洞，使用继承方式可以得到Scaffold中设置的floatingActionButton外轮廓
  //通常为host的轮廓path减去 guest的轮廓path
  //返回值为打完洞后最终效果的外轮廓path

  //AutomaticNotchedShape原理类似但传入的gust形状在类实例化时确定
  //AutomaticNotchedShape 根据传入的shapeborder获取path    shapeborder.getouterPath
  @override
  Path getOuterPath(Rect host, Rect guest) {
    double hw = host.width;
    double hh = host.height;
    double gw = guest.width;
    double gh = guest.height;

    //抠个三角形
    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(hw / 2 - gw / 2, host.top)
      ..lineTo(hw / 2, hh)
      ..lineTo(hw / 2 + gw / 2, host.top)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

//自定义一个三角形
class Triangle extends ShapeBorder {
  //三角形边的样式
  final BorderSide side;

  Paint mPaint;

  Triangle(this.side) {
    //根据borderside生成paint
    mPaint = side.toPaint();
  }

  //边两侧间的宽度，返回EdgeInsets
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  //返回内轮廓path  内外轮廓的差距与边的宽度，即画笔的宽度有关
  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.width / 2, rect.height)
      ..close();
  }

  //返回外轮廓path
  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.width / 2, rect.height)
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
    //根据边的类型进行绘制 一般有无none和solid实心
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        canvas.drawPath(
            Path()
              ..moveTo(rect.left, rect.top)
              ..lineTo(rect.right, rect.top)
              ..lineTo(rect.width / 2, rect.height)
              ..close(),
            mPaint);
    }
  }

  //进行缩放
  @override
  ShapeBorder scale(double t) {
    //side.scale 根据缩放倍数t，在原有样式基础上进行缩放
    return Triangle(side.scale(t));
  }
}
