import 'package:flutter/material.dart';

//自定义widget
//状态不可更改的widget   build中创建布局
class slw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//StatefulWidget 状态可变的widget，发生重建  setState 改变数据，从而实现画面变化
//todo 触发每个生命周期
class sfw extends StatefulWidget {
  String user;
  @override
  _sfwState createState() => _sfwState();
}

//State 中主要的声明周期有 ：
//initState ：初始化，理论上只有初始化一次，第二篇中会说特殊情况下。
//didChangeDependencies：在 initState 之后调用，此时可以获取其他 State 。
//dispose ：销毁，只会调用一次。
class _sfwState extends State<sfw> {
  @override
  Widget build(BuildContext context) {
    var user = widget.user;
//    flutter.widget 是对应StatefulWidget的对象实例
    return Container();
  }
}

//带有动画的satefulwidget
class stani extends StatefulWidget {
  @override
  _staniState createState() => _staniState();
}

///SingleTickerProviderStateMixin 提供一个ticker，只在tree可用的情况下
class _staniState extends State<stani> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  /// 清除销毁
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

//生命周期
//initState：当Widget第一次插入到Widget树时会被调用，对于每一个State对象，Flutter framework只会调用一次该回调

//didChangeDependencies()：当State对象的依赖发生变化时会被调用
//在之前build() 中包含了一个InheritedWidget（数据共享），然后在之后的build() 中InheritedWidget发生了变化，那么此时InheritedWidget的子widget的didChangeDependencies()回调都会被调用。
//典型的场景是当系统语言Locale或应用主题改变时，Flutter framework会通知widget调用此回调
//如果Widget的build方法中没有使用InheritedWidget的数据，那么它的didChangeDependencies()将不会被调用，因为它并没有依赖InheritedWidget。

//build()：此回调读者现在应该已经相当熟悉了，它主要是用于构建Widget子树的，会在如下场景被调用：
//在调用initState()之后。
//在调用didUpdateWidget()之后。
//在调用setState()之后。
//在调用didChangeDependencies()之后。
//在State对象从树中一个位置移除后（会调用deactivate）又重新插入到树的其它位置之后。

//reassemble()：此回调是专门为了开发调试而提供的，在热重载(hot reload)时会被调用，此回调在Release模式下永远不会被调用

//didUpdateWidget()：在widget重新构建时，Flutter framework会调用Widget.canUpdate来检测Widget树中同一位置的新旧节点，然后决定是否需要更新，如果Widget.canUpdate返回true则会调用此回调。正如之前所述，Widget.canUpdate会在新旧widget的key和runtimeType同时相等时会返回true，
// 也就是说在在新旧widget的key和runtimeType同时相等时didUpdateWidget()就会被调用

//deactivate()：当State对象从树中被移除时，会调用此回调。
// 在一些场景下，Flutter framework会将State对象重新插到树中，如包含此State对象的子树在树的一个位置移动到另一个位置时（可以通过GlobalKey来实现）。如果移除后没有重新插入到树中则紧接着会调用dispose()方法

//响应式的编程框架中都会有一个永恒的主题——“状态管理”
//以下是管理状态的最常见的方法：
//Widget管理自己的state。
//父widget管理子widget状态。
//混合管理（父widget和子widget都管理状态）。
//如何决定使用哪种管理方法？以下原则可以帮助你决定：
//
//如果状态是用户数据，如复选框的选中状态、滑块的位置，则该状态最好由父widget管理。
//如果状态是有关界面外观效果的，例如颜色、动画，那么状态最好由widget本身来管理。
//如果某一个状态是不同widget共享的则最好由它们共同的父widget管理。
//在widget内部管理状态封装性会好一些，而在父widget中管理会比较灵活。有些时候，如果不确定到底该怎么管理状态，那么推荐的首选是在父widget中管理（灵活会显得更重要一些）。

//全句状态管理
//当应用中包括一些跨widget（甚至跨路由）的状态需要同步时
//1实现一个全局的事件总线，将语言状态改变对应为一个事件，然后在APP Widget所在的父widgetinitState 方法中订阅语言改变的事件，当用户在设置页切换语言后，我们触发语言改变事件，然后APP Widget那边就会收到通知，然后重新build一下即可。
//2使用redux这样的全局状态包
