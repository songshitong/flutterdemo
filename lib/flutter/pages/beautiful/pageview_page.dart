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
/// 3 itemcount为0，默认不展示
/// 4 itemcount为1不进行轮播
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
                itemCount: 2,
                itemBuilder: (context, index) {
//                  print("build index item $index  controllerPage.floor() ${fractionPage.floor()}   ======== ");
                  return Image.asset(MyImgs.JINX);
                },
                indicatorBuilder: (context, index, fractionPage) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: ClipOval(
                      child: Container(
                        width: 8,
                        height: 8,
                        color: fractionPage.round() % 5 == index
                            ? Colors.white
                            : Colors.grey,
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

//todo pageview滑动，不显示时停止滚动
/////todo  轮播图覆盖，滚动出可视区不滚动

///TODO 使用RepaintBoundary减少重绘范围
typedef MPageViewItemBuilder = Widget Function(BuildContext context, int index);
typedef MPageViewItemTransitionBuilder = Widget Function(
    BuildContext context, int index, double pageFraction, Widget item);

typedef MPageViewIndicatorBuilder = Widget Function(
    BuildContext context, int index, int pageIndex);

///itemcount为0，默认不展示
class MPageView extends StatefulWidget {
  MPageViewItemBuilder itemBuilder;
  MPageViewIndicatorBuilder? indicatorBuilder;
  MPageViewItemTransitionBuilder? itemTransitionBuilder;
  int itemCount;
  bool autoScroll;
  double pageTime;
  double? indicatorBottom;
  double? indicatorTop;
  double? indicatorLeft;
  double? indicatorRight;
  double indicatorRadius;
  double indicatorSpace;
  bool showIndicator;
  PageController? pageController;
  MPageView.builder(
      {required this.itemBuilder,
      this.indicatorBuilder,
      this.itemTransitionBuilder,
      this.itemCount = 0,
      this.autoScroll = false,
      this.pageTime = 3.0,
      this.indicatorBottom,
      this.indicatorTop,
      this.indicatorLeft,
      this.indicatorRight,
      this.indicatorRadius = 5,
      this.indicatorSpace = 5,
      this.showIndicator = true,
      this.pageController})
      : assert(itemBuilder != null),
        assert(itemCount != null);

  @override
  _MPageViewState createState() => _MPageViewState();
}

///todo controller.hasClients 判断controller绑定view
class _MPageViewState extends State<MPageView> {
  PageController? _controller = PageController();
  double controllerPage = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.pageController != null) {
      _controller = widget.pageController;
    }
    _controller!.addListener(() {
      setState(() {
        print(
            "offset ${_controller!.offset} _controller.page ${_controller!.page}  _controller.page.toInt  ${_controller!.page?.toInt()}");
        controllerPage = _controller!.page!;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback(postFrameCallback);
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
    //一张图片不轮播
    if (widget.itemCount == 1) return;
    _timer = Timer.periodic(
        Duration(milliseconds: (widget.pageTime * 1000).toInt()), (timer) {
      int page = controllerPage.round() + 1;
      print("periodic page $page");
      _controller!.animateToPage(page,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  void cancelTimer() {
    if (null != _timer) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount == 0) {
      return Container();
    } else {
      return Stack(alignment: Alignment.center, children: <Widget>[
        widget.itemCount > 1
            ? Listener(
                onPointerDown: (pointerDownEvent) {
                  print("onPointerDown ======");
                  cancelTimer();
                },
                onPointerUp: (pointerUpEvent) {
                  print("onPointerUp ======");

                  initTimer();
                },
                child: buildPageView(),
              )
            : buildPageView(),
        Visibility(
          visible: widget.showIndicator && widget.itemCount > 1,
          child: Positioned(
              bottom: widget.indicatorBottom!,
              top: widget.indicatorTop!,
              left: widget.indicatorLeft!,
              right: widget.indicatorRight!,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(widget.itemCount, (index) {
                    if (null != widget.indicatorBuilder) {
                      return widget.indicatorBuilder!(
                          context,
                          index % widget.itemCount,
                          controllerPage.round() % widget.itemCount);
                    } else {
                      return DefaultIndicator(
                          widget.indicatorSpace,
                          widget.indicatorRadius,
                          index % widget.itemCount,
                          controllerPage,
                          widget.itemCount);
                    }
                  }))),
        )
      ]);
    }
  }

  PageView buildPageView() {
    return PageView.builder(
      physics: widget.itemCount == 1
          ? NeverScrollableScrollPhysics()
          : PageScrollPhysics(),
      scrollDirection: Axis.horizontal,
      controller: _controller!,
      itemBuilder: (context, index) {
        final realIndex = index % widget.itemCount;
        final fractionPage = controllerPage;
        final item = widget.itemBuilder(context, realIndex);
        if (null == widget.itemTransitionBuilder) {
          return DefaultItemTransition(realIndex, fractionPage, item);
        } else {
          return widget.itemTransitionBuilder!(
              context, realIndex, fractionPage, item);
        }
      },

      ///不设置itemCount会无限滚动，设置后只能滚动固定大小
//          itemCount: widget.itemCount,
      onPageChanged: (current) {
        print("onPageChanged current $current");
      },
    );
  }
}

class DefaultItemTransition extends StatelessWidget {
  int index;
  double fractionPage;
  Widget item;

  DefaultItemTransition(this.index, this.fractionPage, this.item);

  @override
  Widget build(BuildContext context) {
    if (index == fractionPage.floor()) {
      //正在离开
      return Opacity(
        opacity: 1 - (fractionPage - index),
        child: Transform(
            transform: Matrix4.identity()..rotateX(fractionPage - index),
            child: item),
      );
    } else if (index == fractionPage.floor() + 1) {
      //正在进入
      return Opacity(
        opacity: 1 - (index - fractionPage),
        child: Transform(
            transform: Matrix4.identity()..rotateX(fractionPage - index),
            child: item),
      );
    } else {
      //离开
      return Opacity(opacity: 1, child: item);
    }
  }
}

class DefaultIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: indicatorSpace),
      child: ClipOval(
        child: Container(
          width: indicatorRadius,
          height: indicatorRadius,
          color: fractionPage.round() % count == index
              ? Colors.white
              : Colors.grey,
        ),
      ),
    );
  }

  double indicatorSpace;
  double indicatorRadius;
  int index;
  double fractionPage;
  int count;
  //todo 修改颜色
  Color? selectedColor;
  Color? unSelectedColor;
  DefaultIndicator(this.indicatorSpace, this.indicatorRadius, this.index,
      this.fractionPage, this.count);
}
