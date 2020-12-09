import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';
import 'dart:math' as math;

///todo ui chalange  https://github.com/chrisbanes/tivi/tree/d72f561345e4df57ad190437fd91102b1695f7f0/ui-showdetails
/// https://twitter.com/Fa__oB/status/1057935966848065537
class OverlayChangePage extends StatefulWidget {
  @override
  _OverlayChangePageState createState() => _OverlayChangePageState();
}

class _OverlayChangePageState extends State<OverlayChangePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _cuteController;
  late CurveTween _tween;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    _cuteController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    _tween = CurveTween(curve: Curves.slowMiddle);
    _tween.animate(_controller);
    _controller.addListener(() {
      print("_controller value ${_controller.value} ");
      setState(() {});
    });

    _cuteController.addStatusListener((status) {
      if (_controller.isAnimating) {
        if (status == AnimationStatus.completed) {
          _cuteController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _cuteController.forward();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    var angry = GestureDetector(
        onTap: () {
          if (_controller.value == _controller.lowerBound) {
            _controller.forward();
            _cuteController.forward();
          } else {
            _controller.reverse();
            _cuteController.forward();
          }
        },
        child: Transform.translate(
          offset: Offset(0.0, 150 * _controller.value),
          child: ClipPath(
            clipper: ShapeBorderClipper(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(100 * _controller.value)))),
            child: Image.asset(
              MyImgs.midouzi,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 267 / 189,
              fit: BoxFit.fill,
            ),
          ),
        ));
    var cute = Positioned(
        left: -40,
        child: Transform.rotate(
          angle: math.pi / 4 * _cuteController.value,
          child: Transform.translate(
            offset: Offset(0.0, 100 * _controller.value),
            child: Image.asset(
              MyImgs.midouzi_cute2,
              width: 112,
              height: 112,
            ),
          ),
        ));
    if (_controller.value < _controller.upperBound / 2) {
      children..add(cute)..add(angry);
    } else {
      children..add(angry)..add(cute);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("overlay change"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.purpleAccent),
        child: Stack(children: children),
      ),
    );
  }
}
