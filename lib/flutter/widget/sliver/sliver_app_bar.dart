import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';
import 'package:flutterdemo/flutter/widget/sliver/CourseCenter.dart';

class SliverAppBarPage extends StatefulWidget {
  @override
  _SliverAppBarPageState createState() => _SliverAppBarPageState();
}

class _SliverAppBarPageState extends State<SliverAppBarPage>
    with SingleTickerProviderStateMixin {
//  介绍Sliver布局，必须得先介绍Viewport组件，因为Sliver相关组件需要在Viewport组件下使用，而Viewport组件的主要作用就是提供滚动机制，可以根据传入的offset参数来显示特定的内容
  // todo https://segmentfault.com/a/1190000015086603 viewport
  List<int> datas = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<String> longDatas = List<String>.generate(100, (index) {
    return "$index";
  });
  GlobalKey centerKey = GlobalKey();
  GlobalKey keyListHeight = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        //设置某个child成为scrollview的主要滚动，测试只展示一个
//        primary: true,
//        center: centerKey,
        slivers: <Widget>[
          SliverAppBar(
            title: Text('SliverAppBar'),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context)
                      ?.push(MaterialPageRoute(builder: (contxt) {
                    return CourseCenter();
                  }));
                },
                child: Text("CourseCenter "),
              )
            ],
            //展开高度
            expandedHeight: 200,
            //true appbar随着用户向下滑动而展开，false 用户向下滚动，等到列表滚动到顶部时才展开appbar
            floating: true,
            //只有在floating为true时才能设置snap为true    用户只要向下滚动appbar立即展开，而不用滑动一定距离
            snap: true,
            //appbar 是否保持显示，appear不会消失
            pinned: false,
            //通常为FlexibleSpaceBar，位置在状态栏，可根据child最大占据appbar,根据内容展开或缩小
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                MyImgs.TEST,
                fit: BoxFit.cover,
              ),
            ),
          ),
          //给其他sliver设置padding的sliver
          SliverPadding(
            padding: new EdgeInsets.all(8),
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
              //不设置childcount 默认无限个
              return Text("SliverList $index");
            }, childCount: 40)),
          ),
          SliverList(
            key: keyListHeight,
            delegate:
                SliverChildListDelegate(List.generate(datas.length, (index) {
              return GestureDetector(
                  onTap: () {
                    print("sliver list ontap");
                    getHeightToIndex(index);
                  },
                  child: SizedBox(
                      width: 50,
                      height: 20,
                      child: Text("all height sliver list $index")));
            })),
          ),
          SliverGrid(
              //使用数量较少的情况
              delegate: SliverChildListDelegate(
                  List<Widget>.generate(datas.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text("SliverGrid ${datas[index]}"),
                );
              })),
              //决定grid 的横竖布局    crossAxisCount 一行几个
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4)),
          //与appbar 类似，任意位置，随内容滚动收缩，展开   appbar的内部实现就是SliverPersistentHeader
          SliverPersistentHeader(
            //保持最小高度
            pinned: false,
            delegate: _SPHD(
                maxHeight: 300,
                minHeight: 150,
                child: Image.asset(
                  MyImgs.TEST,
                  fit: BoxFit.fill,
                )),
          ),
          //在customscrollview 中使用普通控件
          SliverToBoxAdapter(
            child: Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.5)),
              child: Text("SliverToBoxAdapter 使用普通控件"),
            ),
          ),
          //固定长度列表，不用performlayout比SliverList高效
          SliverFixedExtentList(
            itemExtent: 120.0,
            delegate: SliverChildListDelegate(
                List<Widget>.generate(datas.length, (index) {
              return Text("SliverFixedExtentList item $index");
            })),
          ),
          SliverFillRemaining(
            key: centerKey,
            //false child只占用剩余的长度  true child可以超出viewport并滚动
            hasScrollBody: true,
            child: TabBarView(
                controller: new TabController(vsync: this, length: 2),
                children: [
                  ListView(
                    children: List<Widget>.generate(longDatas.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                            "SliverFillRemaining TabBarView1 ${longDatas[index]}"),
                      );
                    }),
                  ),
                  ListView(
                    children: List<Widget>.generate(longDatas.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                            "SliverFillRemaining TabBarView2 ${longDatas[index]}"),
                      );
                    }),
                  )
                ]),
          )
        ],
      ),
    );
  }

  double getHeightToIndex(int index) {
    RenderSliverMultiBoxAdaptor renderObject = keyListHeight.currentContext
        ?.findRenderObject() as RenderSliverMultiBoxAdaptor;
    var child = renderObject.firstChild!;
    var allHeight = 0.0;
    allHeight = renderObject.paintExtentOf(child);
    print("firstChild allHeight $allHeight");
    if (index > 0) {
      //缺点在绘制完成后使用
      //第0个已经取得高度了，所以进行判断
      //不进行判断，while中childIndex一直大于0，此时获取的第一个高度为list的总高度
      while ((child = renderObject.childAfter(child)!) != null) {
        allHeight += renderObject.paintExtentOf(child);
        var childIndex = renderObject.indexOf(child);
        if (childIndex == index) {
          break;
        }
      }
    }

    print("index $index paintExtent $allHeight");
    return allHeight;
  }
}

/// 自定义 SliverPersistentHeaderDelegate
///
/// 需要重写build，maxExtent，minExtent，shouldRebuild
class _SPHD extends SliverPersistentHeaderDelegate {
  _SPHD({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => math.min(maxHeight, minHeight);

  @override
  bool shouldRebuild(_SPHD oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
