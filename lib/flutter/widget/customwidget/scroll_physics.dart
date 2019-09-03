import 'package:flutter/material.dart';
import 'dart:math' as math;

///自定义 scrolls physics 使用自定义的scrollphysic+listview模拟PageView效果
class CustomScrollPhysicsPage extends StatefulWidget {
  @override
  _CustomScrollPhysicsState createState() => _CustomScrollPhysicsState();
}

class _CustomScrollPhysicsState extends State<CustomScrollPhysicsPage> {
  ScrollPhysics _physics;
  PageController _controller = PageController();
  int itemCount = 5;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.haveDimensions && _physics == null) {
        var dimension = _controller.position.maxScrollExtent / (itemCount - 1);
        _physics = _physics = CustomScrollPhysics(itemDimension: dimension);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CustomScrollPhysics"),
      ),
      body: SizedBox(
        height: 200,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            physics: _physics,
            controller: _controller,
            itemBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, math.Random.secure().nextInt(255), math.Random.secure().nextInt(255),
                        math.Random.secure().nextInt(255))),
              );
            }),
      ),
    );
  }
}

///模拟pageView的效果  滚动超过一半，弹到下一页，滚动不超过一半，回到原位置
///也可以参考gallery[_SnappingScrollPhysics]
class CustomScrollPhysics extends ScrollPhysics {
  final double itemDimension;

  CustomScrollPhysics({this.itemDimension, ScrollPhysics parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics(itemDimension: itemDimension, parent: buildParent(ancestor));
  }

  double _getPage(ScrollPosition position) {
    ///  当前位置/每一个的滚动宽度
    return position.pixels / itemDimension;
  }

  double _getPixels(double page) {
    ///返回page对应的位置
    return page * itemDimension;
  }

  double _getTargetPixels(ScrollPosition position, Tolerance tolerance, double velocity) {
    double page = _getPage(position);
    print("_getTargetPixels page  $page velocity $velocity  tolerance.velocity ${tolerance.velocity}");

    /// 拖动到临界点，停止速度为0，两个if都不进入，按四舍五入逻辑，超过0.5进1，不超过舍去
    /// 轻轻拖动 速度一般大于tolerance.velocity的绝对值，按方向加减0.5后，四舍五入
    if (velocity < -tolerance.velocity) {
      ///速度大于默认速度 page减少0.5
      page -= 0.5;
    } else if (velocity > tolerance.velocity) {
      page += 0.5;
    }
    print("page $page page.roundToDouble ${page.roundToDouble()}");

    ///返回目标page在的位置
    return _getPixels(page.roundToDouble());
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at a page boundary.
    ///滚动距离超过最大和最小，走父类的逻辑
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent))
      return super.createBallisticSimulation(position, velocity);

    ///tolerance 计算滚动的默认精度 包括速度和距离
    final Tolerance tolerance = this.tolerance;

    final double target = _getTargetPixels(position, tolerance, velocity);
    if (target != position.pixels)

      ///ScrollSpringSimulation 可以模拟减速和震动效果
      return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
    return null;
  }

  @override
  bool get allowImplicitScrolling => false;
}
