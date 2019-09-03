import 'dart:ui';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';
import 'dart:math' as math;

///侧边栏
class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  var color = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        ///[title]前的内容，可以放置头像或菜单按钮，用来提示存在侧边栏
        leading: Builder(builder: (buildContext) {
          return InkWell(
            onTap: () {
              Scaffold.of(buildContext).openDrawer();
            },
            child: CircleAvatar(
              child: Image.asset(MyImgs.JINX),
            ),
          );
        }),
        title: Text("DrawerPage"),
        actions: <Widget>[
          Builder(builder: (buildContext) {
            return RaisedButton(
                onPressed: () {
                  Scaffold.of(buildContext).openEndDrawer();
                },
                child: Text("打开右边侧栏"));
          })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(),
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(color: color),
                child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      print("set state DrawerHeader");
                      color = color == Colors.purple ? Colors.yellow : Colors.purple;
                    });
                  },
                  child: Text("改变颜色时应有DrawerHeader内部动画"),
                )),
            UserAccountsDrawerHeader(
                accountName: Text("account name"),
                accountEmail: Text("email"),
                currentAccountPicture: CircleAvatar(
                  child: Image.asset(MyImgs.JINX),
                ),
                otherAccountsPictures: [
                  CircleAvatar(
                    child: Text("other account pic"),
                  )
                ]),
            new ListTile(
              leading: new CircleAvatar(child: new Text("B")),
              title: new Text('Drawer item B'),
              subtitle: new Text("Drawer item B subtitle"),
              onTap: () => {},
            ),
            new AboutListTile(
              icon: new CircleAvatar(child: new Text("Ab")),
              child: new Text("About"),
              applicationName: "Test",
              applicationVersion: "1.0",
              applicationIcon: new Image.asset(
                MyImgs.SANTAIZI,
                width: 64.0,
                height: 64.0,
              ),
              applicationLegalese: "applicationLegalese",
              aboutBoxChildren: <Widget>[new Text("BoxChildren"), new Text("box child 2")],
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset(
              MyImgs.EARRINGS,
              fit: BoxFit.fill,
            ),
            Positioned(
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5.0,
                    sigmaY: 5.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    width: 200.0,
                    height: MediaQuery.of(context).size.height,
                  ),
                ),
              ),
            ),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - 80),
              painter: _MyPainter(),
            )
          ],
        ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(path, painter);
    painter.color = Colors.purple;
    print("width ${size.width / 2}  ");
    painter.style = PaintingStyle.fill;
//    canvas.drawRect(Rect.fromLTWH(0, 0, size.width / 2, size.height), painter);
    canvas.save();
    path.reset();
    path.moveTo(0, 0);
    var curveStart = size.width / 2 + 70;
    path.lineTo(curveStart, 0);
    // y=sin(x);    y对应x轴坐标，x对应y轴坐标
    for (int i = 0; i < size.height; i++) {
      path.lineTo(-math.sin(i / (math.pi * 6)) * 25 + curveStart, i.toDouble() * math.pi);
    }
    path.lineTo(0, size.height);
    path.close();
    //canvas 区域与path的交集  path是闭合路径可以剪切出一个完整的形状
    canvas.clipPath(path, doAntiAlias: true);
    canvas.drawColor(Colors.purple, BlendMode.srcIn);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  Paint painter = new Paint();
  Path path = new Path();
  _MyPainter() {
    path.moveTo(50, 50);
    path.lineTo(150, 50);
    path.moveTo(50, 100);
    path.lineTo(150, 100);
    painter
      ..color = Colors.red
      ..isAntiAlias = true
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
  }
}
