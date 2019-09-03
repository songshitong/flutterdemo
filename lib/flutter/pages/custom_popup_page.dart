import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdemo/dart/version_2x/async/stream.dart' as prefix0;
import 'package:flutterdemo/flutter/common/MyImgs.dart';
import 'package:flutterdemo/flutter/widget/animation/route_animation.dart';
import 'dart:ui' as ui;

import 'beautiful/image_preview.dart';

// 全局悬浮窗
// 球形状态  可以移动，移动结束贴边，贴边时变为半圆矩形，圆形图片旋转
// 点击球形，背景为0.9不透明白色，变为长矩形半圆，存在圆形图片，播放按钮，上下按钮，关闭按钮

//一个悬浮球 最多个图片  1（微信原版）一个站中间，两个站一排，三个成三角，四个对角线是y轴的正方形/长方形,五个是五边形
//            2   将1改为  一个占中间，两个并排不叠加，三个(两个一排，第三个叠加),4个(三角形，第四个叠加)，5个(4个方形，5个叠加) 最突出的那个旋转
//点开后  长矩形半圆呈列表排列  图片要旋转
//超过5个提示不支持  计数器要放在外面，显示列表时取消悬浮球，不显示列表时展示悬浮球，内部经历了一次计数
//  ---改为技术器放内部，放外部，外部要负责计数的重置，同时与内部通讯，获取内部计数的变化。至于内部经历的计数，将计数和popup分开，区分哪些计数，哪些不计数

//todo https://github.com/kongnanlive/android-combination-avatar
///全局悬浮球
class CustomPopup extends StatefulWidget {
  //初始popupX 初始位置在右侧贴边
  double popupX =
      WidgetsBinding.instance.window.physicalSize.width / WidgetsBinding.instance.window.devicePixelRatio - 50;
  double popupY = 100.0;
  OverlayEntry overlayEntry;
  var instance;

  CustomPopup() {
    instance = this;
  }

  OverlayState overlayState;
  BuildContext outContext;
  // 计数器，最多调用5次，展示5张图片，点击到列表页面，列表中显示5个
  int _count = 0;

  countAdd() {
    _count++;
  }

  popup(BuildContext context, {double popupX = -1.0, double popupY = -1.0}) {
    if (_count > 5) {
      //重置
      _count = 5;
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("最多支持5个"),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("确定"),
                )
              ],
            );
          });
      return;
    }
    if (_count > 1 && state.mounted) {
      //大于1 要刷新界面同时页面要mounted，dispose后重新执行下面的overlayState.insert
      state.setState(() {});
//      dismiss();
      //todo setState不生效
//      overlayState.setState(() {});
//      context.ancestorStateOfType(const TypeMatcher<OverlayState>()).setState(() {});
    }
    if (popupX >= 0) {
      this.popupX = popupX;
    }
    if (popupY >= 0) {
      this.popupY = popupY;
    }
    outContext = context;
    if (null == overlayEntry && null == overlayState) {
      // 只展示一个 并且多次添加不重置位置
      overlayState = Overlay.of(context);
      overlayEntry = new OverlayEntry(
          builder: (context) {
            return instance;
          },
          opaque: false,
          maintainState: true);
      overlayState.insert(overlayEntry);
    }
  }

  dismiss() {
    if (null != overlayEntry && null != overlayState) {
      overlayEntry.remove();
      overlayEntry = null;
      overlayState = null;
    }
  }

  CustomPopupState state;
  @override
  CustomPopupState createState() {
    state = CustomPopupState();
    return state;
  }
}

class CustomPopupState extends State<CustomPopup> with SingleTickerProviderStateMixin {
  double popupX;
  double popupY;
  double preX;
  double preY;
  double radius = 25.0;
  double leftRadius;
  double rightRadius;

  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 400))
      ..addListener(() {
        setState(() {
          popupX = MediaQuery.of(context).size.width * _controller.value - radius;
          //贴边 而不是进入屏幕一部分
          popupX = popupX.clamp(0.0, MediaQuery.of(context).size.width - radius * 2);
        });
      })
      ..addStatusListener((status) {
        print("status $status ${_controller.value}");

        if (status == AnimationStatus.completed) {
          //右侧
          setState(() {
            rightRadius = rightRadius * (1 - _controller.value);
          });
        } else if (status == AnimationStatus.dismissed) {
          //左侧
          setState(() {
            leftRadius = leftRadius * _controller.value;
          });
        }
      });
    if (widget.popupX >= 0) {
      popupX = widget.popupX;
    }

    if (widget.popupY >= 0) {
      popupY = widget.popupY;
    }
    print(
        "_CustomPopupState  popupX $popupX popupY $popupY  widget.popupX ${widget.popupX} widget.popupY ${widget.popupY}");

    //更新时处理左右侧radius
    double windowWidth =
        WidgetsBinding.instance.window.physicalSize.width / WidgetsBinding.instance.window.devicePixelRatio;
    if (popupX < windowWidth / 2) {
      //左侧
      rightRadius = radius;
      leftRadius = 0.0;
    } else if (popupX > windowWidth / 2) {
      leftRadius = radius;
      rightRadius = 0.0;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: popupX,
          top: popupY,
          width: 50,
          height: 50,
          child: GestureDetector(
              onTap: () {
                //打开列表页
                Navigator.of(context).push(FadeTransparentRoute(builder: (context) {
                  return PopupListPage(
                    popupY: popupY,
                    popupX: popupX,
                    leftRadius: leftRadius,
                    rightRadius: rightRadius,
                    count: widget._count,
                  );
                })).then((result) {
                  print("push PopupListPage result $result popupX $popupX popupY $popupY");
//                  WidgetsBinding.instance.addPostFrameCallback((duration) {  加入监听会闪一下，感觉刷新多次
                  if (null != result) {
                    widget._count = result;
                  }
                  if (result > 0) {
                    widget.popup(widget.outContext, popupX: popupX, popupY: popupY);
                  } else {
                    //result为0 列表页关闭所有item，此时关闭外部悬浮窗
                    widget.dismiss();
                  }
//                  });
                });
                widget.dismiss();
              },
              onPanStart: (dragStartDetails) {
                preX = dragStartDetails.globalPosition.dx;
                preY = dragStartDetails.globalPosition.dy;
                resetRadius();
              },
              onPanUpdate: (dragUpdateDetails) {
                var currentX = dragUpdateDetails.globalPosition.dx;
                var currentY = dragUpdateDetails.globalPosition.dy;
                popupX = popupX + currentX - preX;
                popupY = popupY + currentY - preY;
                popupX = popupX.clamp(0.0, MediaQuery.of(context).size.width - radius * 2);
                popupY = popupY.clamp(0.0, MediaQuery.of(context).size.height - radius * 2);
                preX = currentX;
                preY = currentY;
                setState(() {});
              },
              onPanEnd: (dragEndDetails) {
                //贴边动画
                if (popupX + radius >= MediaQuery.of(context).size.width / 2) {
                  _controller.forward(from: (popupX + radius) / MediaQuery.of(context).size.width);
                } else {
                  _controller.reverse(from: (popupX + radius) / MediaQuery.of(context).size.width);
                }
              },
              child: PopupContent(leftRadius: leftRadius, rightRadius: rightRadius, count: widget._count)),
        ),
      ],
    );
  }

  void resetRadius() {
    setState(() {
      leftRadius = 25;
      rightRadius = 25;
    });
  }
}

class PopupContent extends StatelessWidget {
  double leftRadius;
  double rightRadius;
  int count;
  PopupContent({this.leftRadius = 25, this.rightRadius = 25, this.count = 1});

  @override
  Widget build(BuildContext context) {
    Widget child;
    print("PopupContent  build count $count");
    switch (count) {
      case 1:
        child = PopupChildOne(
          rotate: true,
        );
        break;
      case 2:
        child = new CustomMultiChildLayout(
          children: <Widget>[
            LayoutId(
                id: "two1",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "two2",
                child: PopupChildOne(
                  radius: 10,
                  rotate: true,
                )),
          ],
          delegate: PopupChildTwoDelegate(),
        );
        break;
      case 3:
        child = new CustomMultiChildLayout(
          children: <Widget>[
            LayoutId(
                id: "three1",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "three2",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "three3",
                child: PopupChildOne(
                  radius: 10,
                  rotate: true,
                )),
          ],
          delegate: PopupChildThreeDelegate(),
        );
        break;
      case 4:
        child = new CustomMultiChildLayout(
          children: <Widget>[
            LayoutId(
                id: "four1",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "four2",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "four3",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "four4",
                child: PopupChildOne(
                  radius: 10,
                  rotate: true,
                )),
          ],
          delegate: PopupChildFourDelegate(),
        );
        break;
      case 5:
        child = new CustomMultiChildLayout(
          children: <Widget>[
            //todo 刷新逻辑，一层不变，自层变化是否刷新，还是与LayoutID有关
            LayoutId(
                id: "five1",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "five2",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "five3",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "five4",
                child: PopupChildOne(
                  radius: 10,
                  rotate: false,
                )),
            LayoutId(
                id: "five5",
                child: PopupChildOne(
                  radius: 10,
                  rotate: true,
                )),
          ],
          delegate: PopupChildFiveDelegate(),
        );
        break;
    }
    return Card(
      margin: EdgeInsets.all(0),
      color: Colors.deepPurpleAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(leftRadius), right: Radius.circular(rightRadius)),
      ),
      child: SizedBox(
        width: 50,
        height: 50,
        child: Center(child: child),
      ),
    );
  }
}

class PopupChildOne extends StatefulWidget {
  double radius;
  bool rotate;
  PopupChildOne({this.radius = 20, this.rotate = false});

  @override
  _PopupChildOneState createState() => _PopupChildOneState();
}

class _PopupChildOneState extends State<PopupChildOne> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))
      ..addListener(() {
        setState(() {});
      });
    if (widget.rotate) {
      _controller.repeat();
      print("_PopupChildOneState initState  widget.rotate ${widget.rotate}");
    }
  }

  @override
  void didUpdateWidget(PopupChildOne oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("_PopupChildOneState  didUpdateWidget  ===========");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("_PopupChildOneState  didUpdateWidget  ===========");
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    print("_PopupChildOneState dispose ======================");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    print("_PopupChildOneState build ====================== ");
    double width = 2 * widget.radius;
    return RotationTransition(
      turns: _controller,
      child: ClipOval(
          child: Image.asset(
        MyImgs.JINX,
        width: width,
        height: width,
        fit: BoxFit.cover,
      )),
    );
  }
}

class PopupChildTwoDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final String childId1 = "two1";
    final String childId2 = "two2";
    double child1W;
    if (hasChild(childId1)) {
      Size child1Size = layoutChild(childId1, BoxConstraints.loose(size));
      child1W = child1Size.width;
      positionChild(childId1, Offset(child1W, size.height / 2 - child1Size.height / 2));
    }
    if (hasChild(childId2)) {
      Size child2Size = layoutChild(childId2, BoxConstraints.loose(size));
      double child2W = child2Size.width;
      positionChild(childId2, Offset(child1W / 2, size.height / 2 - child2Size.height / 2));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class PopupChildThreeDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final String childId1 = "three1";
    final String childId2 = "three2";
    final String childId3 = "three3";
    double child1W;
    if (hasChild(childId1)) {
      Size child1Size = layoutChild(childId1, BoxConstraints.loose(size));
      child1W = child1Size.width;
      positionChild(childId1, Offset(child1W / 2, size.height / 2 - child1Size.height / 2));
    }
    if (hasChild(childId2)) {
      Size child2Size = layoutChild(childId2, BoxConstraints.loose(size));
      double child2W = child2Size.width;
      positionChild(childId2, Offset(child1W, size.height / 2 - child2Size.height / 2));
    }
    if (hasChild(childId3)) {
      Size child3Size = layoutChild(childId3, BoxConstraints.loose(size));
      double child3W = child3Size.width;
      positionChild(childId3, Offset(size.width / 2 - child3W / 2, size.height / 2 - child3Size.height / 2));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class PopupChildFourDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final String childId1 = "four1";
    final String childId2 = "four2";
    final String childId3 = "four3";
    final String childId4 = "four4";

    double child1W;
    //整体下移5
    double offset = 5;
    if (hasChild(childId1)) {
      Size child1Size = layoutChild(childId1, BoxConstraints.loose(size));
      child1W = child1Size.width;
      positionChild(childId1, Offset(child1W / 2, size.height / 2 - child1Size.height / 2 + offset));
    }
    if (hasChild(childId2)) {
      Size child2Size = layoutChild(childId2, BoxConstraints.loose(size));
      double child2W = child2Size.width;
      positionChild(childId2, Offset(child1W, size.height / 2 - child2Size.height / 2 + offset));
    }
    if (hasChild(childId3)) {
      Size child3Size = layoutChild(childId3, BoxConstraints.loose(size));
      double child3W = child3Size.width;
      positionChild(childId3, Offset(size.width / 2 - child3W / 2, size.height / 2 - child3Size.height + offset));
    }
    if (hasChild(childId4)) {
      Size child4Size = layoutChild(childId4, BoxConstraints.loose(size));
      double child4W = child4Size.width;
      positionChild(childId4, Offset(size.width / 2 - child4W / 2, size.height / 2 - child4Size.height / 2));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

class PopupChildFiveDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final String childId1 = "five1";
    final String childId2 = "five2";
    final String childId3 = "five3";
    final String childId4 = "five4";
    final String childId5 = "five5";

    double child1W;
    //整体下移
    double offset = 5;
    if (hasChild(childId1)) {
      Size child1Size = layoutChild(childId1, BoxConstraints.loose(size));
      child1W = child1Size.width;
      positionChild(childId1, Offset(child1W / 2, size.height / 2 - child1Size.height / 2 + offset));
    }
    if (hasChild(childId2)) {
      Size child2Size = layoutChild(childId2, BoxConstraints.loose(size));
      double child2W = child2Size.width;
      positionChild(childId2, Offset(child1W, size.height / 2 - child2Size.height / 2 + offset));
    }
    if (hasChild(childId3)) {
      Size child3Size = layoutChild(childId3, BoxConstraints.loose(size));
      double child3W = child3Size.width;
      positionChild(childId3, Offset(child3W / 2, size.height / 2 - child3Size.height + offset));
    }
    if (hasChild(childId4)) {
      Size child4Size = layoutChild(childId4, BoxConstraints.loose(size));
      double child4W = child4Size.width;
      positionChild(childId4, Offset(child4W, size.height / 2 - child4Size.height + offset));
    }
    if (hasChild(childId5)) {
      Size child5Size = layoutChild(childId5, BoxConstraints.loose(size));
      double child5W = child5Size.width;
      positionChild(childId5, Offset(size.width / 2 - child5W / 2, size.height / 2 - child5Size.height / 2));
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}

///悬浮列表是一个不覆盖底部的PageRoute
class FadeTransparentRoute extends PageRoute {
  FadeTransparentRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = false,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    //当前路由被激活，是打开新路由
    if (isActive) {
      return FadeTransition(
        opacity: animation,
        child: builder(context),
      );
    } else {
      //是返回，则不应用过渡动画
      return Padding(padding: EdgeInsets.zero);
    }
  }
}

///悬浮列表页
class PopupListPage extends StatefulWidget {
  double popupY;
  double popupX;
  double leftRadius;
  double rightRadius;
  int count;
  PopupListPage({this.popupY = 0.0, this.popupX, this.leftRadius = 0.0, this.rightRadius = 0.0, this.count = 1});

  @override
  _PopupListPageState createState() => _PopupListPageState();
}

class PopupListItemData {
  Widget widget;
  String layoutId;
}

class _PopupListPageState extends State<PopupListPage> {
  List<Widget> children;
  List<PopupListItemData> datas = [];
  @override
  void initState() {
    super.initState();
    children = List<Widget>.generate(widget.count, (int index) {
      bool rotate = false;
      if (index == 0) {
        rotate = true;
      }
      String layoutId = "PopupListItem$index";
      Widget child;
      child = LayoutId(
          id: layoutId,
          child: PopupListItem(
            leftRadius: widget.leftRadius,
            rightRadius: widget.rightRadius,
            canRotate: rotate,
            onItemClose: () {
              print("onItemClose ==== index $index  children.length ${children.length}");
              //点击关闭，移除item
              removeItem(child, layoutId);
              if (children.length == 0) {
                Navigator.of(context).pop(children.length);
              } else {
                setState(() {
                  print(" after remove ==== children.length ${children.length} datas.length ${datas.length}");
                });
              }
            },
          ));
      datas.add(PopupListItemData()
        ..widget = child
        ..layoutId = layoutId);
      return child;
    });
  }

  void removeItem(Widget child, String layoutId) {
    children.removeWhere((widget) {
      return widget == child;
    });
    datas.removeWhere((data) {
      return data.widget == child && data.layoutId == layoutId;
    });
  }

  @override
  Widget build(BuildContext context) {
    //贴边处理
    double windowWidth = MediaQuery.of(context).size.width;
    double poupX = widget.popupX;
    if (widget.popupX < windowWidth / 2) {
      poupX = 0.0;
    } else if (widget.popupX > windowWidth / 2) {
      poupX = windowWidth - 200;
    }
    return GestureDetector(
      onTap: () {
        //点击空白处返回
        Navigator.of(context).pop(children.length);
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
        child: CustomMultiChildLayout(
          delegate: PopupListDelegate(
              datas: datas,
              left: poupX,
              top: widget.popupY,
              windowHeight: MediaQuery.of(context).size.height,
              itemSpace: 15),
          children: children,
        ),
      ),
    );
  }
}

class PopupListDelegate extends MultiChildLayoutDelegate {
  //第一个item的top和left
  double top;
  double left;
  List<PopupListItemData> datas;
  double itemSpace;
  double windowHeight;
  PopupListDelegate({this.top = 0.0, this.left = 0.0, this.datas, this.itemSpace = 0.0, this.windowHeight = 0.0});

  @override
  void performLayout(Size size) {
    final int count = datas.length;
    print("performLayout count $count");
    double allHeight = 0.0;
    Map<int, Size> sizes = new Map();
    for (int i = 0; i < count; i++) {
      final String childId = datas[i].layoutId;
      if (hasChild(childId)) {
        Size childSize = layoutChild(childId, BoxConstraints.loose(size));
        sizes[i] = childSize;
        if (null != childSize) {
          allHeight += childSize.height;
        } else {
          print(" i $i childSize is null");
        }
      }
    }
    double bottomSpace = itemSpace;
    if (top <= bottomSpace) {
      //上部留边  上部留边只适用于列表不占满全屏
      top = bottomSpace;
    }

    double lastHeight = 0.0;
    Offset offset;
    for (int i = 0; i < count; i++) {
      final childId = datas[i].layoutId;
      if (hasChild(childId)) {
        //大于一个 判断列表排列时是否有足够的空间，如果列表超出屏幕，则最后一个在屏幕底部，其余的往上放。
        //   底部留边，最后一个与屏幕底部有间距，底部留边只适用于列表+底部间距大于全屏   ; 上部也要留边，
        if (top + allHeight + itemSpace * (count - 1) + bottomSpace > windowHeight) {
          //倒放
          offset = Offset(left, windowHeight - itemSpace * (count - i - 1) - (allHeight - lastHeight) - bottomSpace);
        } else {
          if (top + bottomSpace + allHeight + itemSpace * i > windowHeight) {
            //底部留边
            top = windowHeight - bottomSpace - allHeight - itemSpace * i;
          }
          //正放  top+几个间隔+几个item的height
          offset = Offset(left, top + itemSpace * i + lastHeight);
        }
        positionChild(childId, offset);
        lastHeight += sizes[i].height;
      } else {
        print(" not hasChild $childId");
      }
    }
  }

  @override
  bool shouldRelayout(PopupListDelegate oldDelegate) {
    return oldDelegate.datas != this.datas ||
        oldDelegate.top != this.top ||
        oldDelegate.left != this.left ||
        oldDelegate.itemSpace != this.itemSpace;
  }
}

///悬浮列表的每一个item
class PopupListItem extends StatefulWidget {
  double leftRadius;
  double rightRadius;
  bool canRotate;
  VoidCallback onItemClose;
  PopupListItem({this.leftRadius, this.rightRadius, this.canRotate = false, this.onItemClose});

  @override
  _PopupListItemState createState() => _PopupListItemState();
}

class _PopupListItemState extends State<PopupListItem> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isPlay = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))
      ..addListener(() {
        setState(() {});
      });
    if (widget.canRotate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //手势拦截 点击空白区域，手势不会向上继续消费
      },
      child: Card(
        margin: EdgeInsets.all(0),
        color: Colors.deepPurpleAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(widget.leftRadius), right: Radius.circular(widget.rightRadius)),
        ),
        child: SizedBox(
          width: 200,
          height: 50,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: RotationTransition(
                    turns: _controller,
                    child: ClipOval(
                        child: Image.asset(
                      MyImgs.JINX,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ))),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPlay = (!isPlay);
                      if (isPlay) {
                        _controller.stop();
                      } else {
                        _controller.repeat();
                      }
                    });
                  },
                  child: Icon(
                    isPlay ? Icons.play_arrow : Icons.pause,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: widget.onItemClose,
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
