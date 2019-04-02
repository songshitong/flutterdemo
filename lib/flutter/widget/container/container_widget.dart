import 'package:flutter/material.dart';

class ContainerPage extends StatefulWidget {
  @override
  ContainerPageState createState() {
    return ContainerPageState();
  }
}

class ContainerPageState extends State<ContainerPage> {
  double _width = 200;

  double _height = 50;

  @override
  Widget build(BuildContext context) {
//    Container是我们要介绍的最后一个容器类widget，
//    它本身不对应具体的RenderObject，它是DecoratedBox、ConstrainedBox、Transform、Padding、Align等widget的一个组合widget
//    容器的大小可以通过width、height属性来指定，也可以通过constraints来指定，如果同时存在时，width、height优先。实际上Container内部会根据width、height来生成一个constraints。
//    color和decoration是互斥的，实际上，当指定color时，Container内会自动创建一个decoration。
    return Scaffold(
      appBar: AppBar(
        title: Text("Container"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 50.0, left: 120.0),
            //容器外补白
            constraints: BoxConstraints.tightFor(width: 200.0, height: 150.0),
            //卡片大小
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black45), //设置边框
                //背景装饰
                gradient: RadialGradient(//背景径向渐变
                    colors: [Colors.red, Colors.orange], center: Alignment.topLeft, radius: .98),
                boxShadow: [
                  //卡片阴影
                  BoxShadow(color: Colors.black54, offset: Offset(2.0, 2.0), blurRadius: 4.0)
                ]),
            transform: Matrix4.rotationZ(.5),
            //卡片倾斜变换
            alignment: Alignment.center,
            //卡片内文字居中
            child: Text(
              //卡片文字
              "5.20", style: TextStyle(color: Colors.white, fontSize: 40.0),
            ),
          ),
//          inkwell 在container等不透明控件下面没有水波效果 用ink代替container
          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: InkWell(
              onTap: () {},
              child: Ink(
                color: Colors.black12,
                child: Column(
                  children: <Widget>[
                    SizedBox(width: _width, height: _height, child: Text("ink container")),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: FlatButton(
                onPressed: () {
                  setState(() {
                    _width = 100;
                    _height = 100;
                  });
                },
                child: Text("改变上面ink大小")),
          )
        ],
      ),
    );
  }
}
