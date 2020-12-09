import 'package:flutter/material.dart';

class DropsPage extends StatefulWidget {
  @override
  _DropsPageState createState() => _DropsPageState();
}

class _DropsPageState extends State<DropsPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  double startX = 0.0;
  double updateX = 0.0;
  double? centerX;
  double? centerY;
  List<TrailingItem> items = [];
  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("仿drops应用"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: GestureDetector(
              onHorizontalDragStart: (DragStartDetails start) {
                startX = start.globalPosition.dx;
              },
              onHorizontalDragUpdate: (DragUpdateDetails update) {
                //todo 以手势移动为驱动，手势停止时光圈不会消失   时间+手势  手势往集合添加，时间控制item的衰减？？
                updateX = update.globalPosition.dx;
                centerX = update.localPosition.dx;
                centerY = update.localPosition.dy;
//                print("centerX $centerX centerY $centerY");
                //减少光圈的数量
                if (items.isNotEmpty) {
                  var last = items.last;
                  if ((last.centerX! - centerX!).abs() > 3 ||
                      (last.centerY! - centerY!).abs() > 3) {
                    addItem();
                  }
                } else {
                  addItem();
                }

                setState(() {
//                  print("items $items");
                  print("items length ${items.length}");
                });
              },
              onHorizontalDragEnd: (DragEndDetails end) {
                setState(() {
                  //清空
                  items.clear();
                  addItem();
                });
              },
              child: Transform.rotate(
                angle: (updateX - startX) / 200,
                origin: Offset(0, 350 / 2 + 100),
                child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.circular(20)),
                    width: 200,
                    height: 350,
                    child: CustomPaint(
                      size: Size(200, 350),
                      painter: TrailingPainter(items: items),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  void addItem() {
    items
      ..forEach((e) {
        if (items.length > 1) {
          e.radius = e.radius - 1;
          e.opacity = e.opacity - 0.02;
        }
      })
      ..removeWhere((e) {
        return e.radius <= 0;
      })
      ..add(TrailingItem()
        ..centerX = centerX
        ..centerY = centerY
        ..radius = 20
        ..opacity = 0.8);
  }
}

class TrailingPainter extends CustomPainter {
  late Paint mPaint;
  List<TrailingItem>? items;
  TrailingPainter({this.items}) {
    mPaint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (null == items) {
      return;
    }
    for (var value in items!) {
      mPaint..color = Colors.white.withOpacity(value.opacity);
      canvas.drawCircle(
          Offset(value.centerX!, value.centerY!), value.radius, mPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TrailingItem {
  double? centerX;
  double? centerY;
  late double radius;
  late double opacity;
  @override
  String toString() {
    return 'TrailingItem{centerX: $centerX, centerY: $centerY, radius: $radius, opacity: $opacity}';
  }
}
