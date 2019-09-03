import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

///轮播图
///[PageController] initialPage 初始页面 keepPage 是否缓存页面 viewportFraction 每个页面占当前的比例
///[PageView]  pageSnapping true 超过一定距离滚动，否则回弹回来与应用[PageScrollPhysics]还是自定义physics有关
///
///
/// 1 可以自定义item及进入动画
/// 2 可以自定义指示器进切换动画
///
class PageViewPage extends StatefulWidget {
  @override
  _PageViewPageState createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> {
  @override
  Widget build(BuildContext context) {
    print("_PageViewPageState  build =======");
    return Scaffold(
      appBar: AppBar(
        title: Text("PageView"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
              height: 200,
              child: MPageView.builder(
                autoScroll: true,
                itemCount: 5,
                itemBuilder: (context, index, fractionPage) {
//                  print("build index item $index  controllerPage.floor() ${fractionPage.floor()}   ======== ");
                  if (index == fractionPage.floor()) {
                    //正在离开
                    return Opacity(
                      opacity: 1 - (fractionPage - index),
                      child: Transform(
                          transform: Matrix4.identity()..rotateX(fractionPage - index),
                          child: Image.asset(MyImgs.JINX)),
                    );
                  } else if (index == fractionPage.floor() + 1) {
                    //正在进入
                    return Opacity(
                      opacity: 1 - (index - fractionPage),
                      child: Transform(
                          transform: Matrix4.identity()..rotateX(fractionPage - index),
                          child: Image.asset(MyImgs.JINX)),
                    );
                  } else {
                    //离开
                    return Opacity(opacity: 1, child: Image.asset(MyImgs.JINX));
                  }
                },
                indicatorBuilder: (context, index, fractionPage) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ClipOval(
                      child: Container(
                        width: 8,
                        height: 8,
                        color: fractionPage.round() % 5 == index ? Colors.white : Colors.grey,
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}

typedef MPageViewItemBuilder = Widget Function(BuildContext context, int index, double pageFraction);
typedef MPageViewIndicatorBuilder = Widget Function(BuildContext context, int index, int pageIndex);

class MPageView extends StatefulWidget {
  MPageViewItemBuilder itemBuilder;
  MPageViewIndicatorBuilder indicatorBuilder;
  int itemCount;
  bool autoScroll;

  MPageView.builder({@required this.itemBuilder, this.indicatorBuilder, this.itemCount = 0, this.autoScroll = false})
      : assert(itemBuilder != null),
        assert(itemCount != null);

  @override
  _MPageViewState createState() => _MPageViewState();
}

class _MPageViewState extends State<MPageView> {
  PageController _controller = PageController();
  double controllerPage = 0.0;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
//        print("_controller.page ${_controller.page}  _controller.page.toInt  ${_controller.page.toInt()}");
        controllerPage = _controller.page;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback(postFrameCallback);
  }

  void postFrameCallback(Duration duration) {
    //自动滚动--->滚动到极限
    if (widget.autoScroll) {
      print("start auto scroll");
      initTimer();
    }
  }

  void initTimer() {
    if (null != _timer) {
      cancelTimer();
    }
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      int page = controllerPage.round() + 1;
      print("periodic page $page");
      _controller.animateToPage(page, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  void cancelTimer() {
    if (null != _timer) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Listener(
        onPointerDown: (pointerDownEvent) {
          print("onPointerDown ======");
          cancelTimer();
        },
        onPointerUp: (pointerUpEvent) {
          print("onPointerUp ======");

          initTimer();
        },
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: _controller,
          itemBuilder: (context, index) {
            return widget.itemBuilder(context, index % widget.itemCount, controllerPage);
          },

          ///不设置itemCount会无限滚动，设置后只能滚动固定大小
//          itemCount: widget.itemCount,
          onPageChanged: (current) {
            print("onPageChanged current $current");
          },
        ),
      ),
      Positioned(
          bottom: 20,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(widget.itemCount, (index) {
                return widget.indicatorBuilder(
                    context, index % widget.itemCount, controllerPage.round() % widget.itemCount);
              })))
    ]);
  }
}
