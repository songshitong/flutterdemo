import 'package:flutter/material.dart';

class DropsPage extends StatefulWidget {
  @override
  _DropsPageState createState() => _DropsPageState();
}

class _DropsPageState extends State<DropsPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double startX = 0.0;
  double updateX = 0.0;
  double centerX;
  double centerY;
  List<TrailingItem> items = [];
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: Duration(seconds: 1));
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
                updateX = update.globalPosition.dx;
                centerX = update.localPosition.dx;
                centerY = update.localPosition.dy;
//                print("centerX $centerX centerY $centerY");
                items
                  ..forEach((e) {
                    e.radius = e.radius - 1;
                    e.opacity = e.opacity - 0.02;
                  })
                  ..removeWhere((e) {
                    return e.radius <= 0;
                  });
                items.add(TrailingItem()
                  ..centerX = centerX
                  ..centerY = centerY
                  ..radius = 20
                  ..opacity = 0.8);
                setState(() {
                  print("items $items");
                });
              },
              onHorizontalDragEnd: (DragEndDetails end) {
                setState(() {
                  items.removeRange(0, items.length - 1);
                });
              },
              child: Transform.rotate(
                angle: (updateX - startX) / 200,
                origin: Offset(0, 350 / 2 + 100),
                child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.purpleAccent, borderRadius: BorderRadius.circular(20)),
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
}

class TrailingPainter extends CustomPainter {
  Paint mPaint;
  List<TrailingItem> items;
  TrailingPainter({this.items}) {
    mPaint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (null == items) {
      return;
    }
    for (var value in items) {
      mPaint..color = Colors.white.withOpacity(value.opacity);
      canvas.drawCircle(Offset(value.centerX, value.centerY), value.radius, mPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class TrailingItem {
  double centerX;
  double centerY;
  double radius;
  double opacity;
  @override
  String toString() {
    return 'TrailingItem{centerX: $centerX, centerY: $centerY, radius: $radius, opacity: $opacity}';
  }
}
