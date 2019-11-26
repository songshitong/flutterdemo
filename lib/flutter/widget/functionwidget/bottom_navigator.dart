//https://www.jianshu.com/p/3bf61b805d11

//flutter 实现底部导航的集中方式

//1  TabBar + TabBarView  代码实现简单,支持左右滑动   底部指示器没法隐藏，高度设为0.1   指示器为圆形，padding是child与指示器的距离？？
//  TODO tabbar的点击居中效果

//2  BottomNavigationBar + BottomNavigationBarItem  代码实现简单,不支持左右滑动,不能自定义图标与文字间距 flutter1.10.16

//3  BottomAppBar  完全可以自定义,代码量复杂,没有自带动画

//4  CupertinoTabBar ios风格

import 'package:flutter/material.dart';

class BottomNavigatorTest extends StatefulWidget {
  @override
  _BottomNavigatorTestState createState() => _BottomNavigatorTestState();
}

class _BottomNavigatorTestState extends State<BottomNavigatorTest> {
  @override
  Widget build(BuildContext context) {
//    BottomNavigationBar(items: null)
    return Scaffold(
        bottomNavigationBar: CustomBottomNavigator(<CustomBottomItem>[
      CustomBottomItem(
          Icon(Icons.add),
          Icon(Icons.clear),
          Text("title", style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
            "untitle",
          )),
      CustomBottomItem(Icon(Icons.add), Icon(Icons.clear), Text("title", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("untitle"))
    ]));
  }
}

class CustomBottomNavigator extends StatefulWidget {
  List<CustomBottomItem> customBottomItems;

  CustomBottomNavigator(this.customBottomItems);

  @override
  _CustomBottomNavigatorState createState() => _CustomBottomNavigatorState();
}

class _CustomBottomNavigatorState extends State<CustomBottomNavigator> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    var resultChildren = widget.customBottomItems.map((item) {
      final index = widget.customBottomItems.indexOf(item);
      return Listener(
        onPointerDown: (downEvent) {
          setState(() {
            activeIndex = index;
          });
        },
        child: item,
      );
    }).toList();
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: resultChildren,
      ),
    );
  }
}

class CustomBottomItem extends StatefulWidget {
  Widget activeIcon;
  Widget inactiveIcon;
  Widget activeTitle;
  Widget inactiveTitle;
  CustomBottomItem(this.activeIcon, this.inactiveIcon, this.activeTitle, this.inactiveTitle);

  @override
  _CustomBottomItemState createState() => _CustomBottomItemState();
}

class _CustomBottomItemState extends State<CustomBottomItem> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (downEvent) {
        print("_CustomBottomItemState down ==== isActive $isActive");
        setState(() {
          isActive = !isActive;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          isActive ? widget.activeIcon : widget.inactiveIcon,
          isActive ? widget.activeTitle : widget.inactiveTitle
        ],
      ),
    );
  }
}
