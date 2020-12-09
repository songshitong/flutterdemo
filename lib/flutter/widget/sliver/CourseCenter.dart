import 'package:flutter/material.dart';

///滑动冲突前结构   滑动listview页面不滚动，滑动listview上面的部分，页面可以滚动
///Scaffold
/// body:CustomScrollView
///  slivers[
///   SliverToBoxAdapter
///    child: container()
///  SliverPersistentHeader
///    child: TabBar()
///  SliverFillRemaining
///    child: TabBarView[
///     ListView,
///     ListView
///    ]
///  ]
class CourseCenter extends StatefulWidget {
  @override
  _CourseCenterState createState() {
    return new _CourseCenterState();
  }
}

class _CourseCenterState extends State<CourseCenter>
    with SingleTickerProviderStateMixin {
  late List<String> tabList;
  late TabController mController;
  late CourseSliverList courseSliverList;

  @override
  void initState() {
    super.initState();
    //初始化tab标签
    tabList = ["课程表", "课程资料"];
    //初始化controller
    mController = TabController(
      length: tabList.length,
      vsync: this,
    );
    getData();
  }

  Future getData() async {}

  @override
  void dispose() {
    super.dispose();
    mController.dispose();
    courseSliverList.createState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: PreferredSize(
            child: AppBar(
              title: Text(
                "课程中心",
                style: new TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              elevation: 0.5,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black), //自定义图标
                  onPressed: () {
                    //
                  },
                );
              }),
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                    ),
                    onPressed: () {}),
              ],
            ),
            preferredSize: Size.fromHeight(44)),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              buildCard(),
              SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: buildTabBarTitle()),
            ];
          },
          body: TabBarView(controller: mController, children: <Widget>[
            buildTabItem(),
            buildTabItem(),
          ]),
        ));
  }

  Builder buildTabItem() {
    return Builder(builder: (context) {
      return CustomScrollView(
        shrinkWrap: true,
        slivers: <Widget>[
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverFixedExtentList(
              itemExtent: 48.0,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
                childCount: 30,
              ),
            ),
          ),
        ],
      );
    });
  }

  SliverToBoxAdapter buildCard() {
    return SliverToBoxAdapter(
      child: Container(
          margin: EdgeInsets.all(16), //容器外补白
          constraints: BoxConstraints(minWidth: double.infinity), //卡片大小
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
              boxShadow: [
                //卡片阴影
                BoxShadow(color: Color(0x14000000), blurRadius: 5.0)
              ]), //卡片内文字居中
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //标签布局
              Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        topRight: Radius.circular(12)),
                    color: Color(0xfffff7E9),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Text(
                      "小学语文",
                      style: TextStyle(
                        color: Color(0xFFFF6C00),
                      ),
                    ),
                  )), //标题布局
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "黄寺大街是砥砺奋进阿里斯顿开发及ADSL房间里进垃圾堆",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff2D2D2D)),
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ), //日期布局
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 8),
                child: Text(
                  "12.30-02.10 共4节课",
                  style: TextStyle(fontSize: 15, color: Color(0xff2D2D2D)),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ), //有效期布局
              Container(
                margin:
                    EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 16),
                child: Text(
                  "有效期至  2019.04.04",
                  style: TextStyle(fontSize: 13, color: Color(0xff9D9D9D)),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )),
    );
  }

  SliverPersistentHeader buildTabBarTitle() {
    return SliverPersistentHeader(
      pinned: false,
      delegate: _SliverAppBarDelegate(
        minHeight: 50,
        maxHeight: 50,
        child:
            //选项卡布局
            TabBar(
          isScrollable: true,
          controller: mController,
          labelColor: Color(0xffff6c00),
          unselectedLabelColor: Color(0xff2d2d2d),
          indicatorColor: Colors.transparent,
          labelStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          tabs: tabList.map((String str) {
            return new Tab(
              text: str,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class CourseSliverList extends StatefulWidget {
  @override
  CourseListState createState() {
    return new CourseListState();
  }
}

class CourseListState extends State<CourseSliverList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Container(
          child: Text("xixixi"),
          height: 20,
        );
      }, childCount: 20),
    );
  }
}
