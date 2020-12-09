import 'package:flutter/material.dart';

///共享动画
//todo 自定义共享动画  createRectTween
// 同一颗书上不能存在多个相同tag的hero,也不能改变tag共用一个hero
class HeroPage extends StatefulWidget {
  @override
  _HeroPageState createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage> {
  @override
  Widget build(BuildContext context) {
//    Hero指的是可以在路由(页面)之间“飞行”的widget，简单来说Hero动画就是在路由切换时，有一个共享的Widget可以在新旧路由间切换，
//    由于共享的Widget在新旧路由页面上的位置、外观可能有所差异，所以在路由切换时会逐渐过渡，这样就会产生一个Hero动画
//    在Flutter中将图片从一个路由“飞”到另一个路由称为hero动画，尽管相同的动作有时也称为 共享元素转换

//    Hero(
//         child:widget
//        tag: "avatar"） //唯一标记，前后两个路由页Hero的tag必须相同

    //todo hero 原理
    //HeroController中做了判断动画只对PageRoute生效
    return Scaffold(
      appBar: AppBar(
        title: Text("HeroPage"),
      ),
      body: Column(
        children: <Widget>[
          Hero(
            tag: "hero",

            ///[HeroController] 控制hero    didPop  navigator.userGestureInProgress为false不进行动画
            //手势触发page transition时，是否进行hero动画，例如iOS，右滑动返回上一页
            transitionOnUserGestures: false,
            //hero动画中，代替child留在原地的widget
            placeholderBuilder: (
              BuildContext context,
              Size heroSize,
              Widget child,
            ) {
              return Text("placeholder");
            },
            //hero动画，飞行中的widget，到达目的后变为目标widget
            //该widget不能拥有global key，动画内部使用其在前后widget tree共享widget
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return Material(child: Text("flightShuttle"));
            },
            //定义目标hero的界限在从起始route飞向目的地route时如何变化,MaterialApp默认使用MaterialRectArcTween
            createRectTween: (Rect? begin, Rect? end) {
              return MaterialRectArcTween(begin: begin, end: end);
            },
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, PageRouteBuilder(pageBuilder:
                    (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                  return new FadeTransition(
                    opacity: animation as Animation<double>,
                    child: Scaffold(
                        appBar: AppBar(title: Text("TargetPage")),
                        body: TargetPage()),
                  );
                }));
              },
              child: Text("hero跳转"),
            ),
          )
        ],
      ),
    );
  }
}

class TargetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: Hero(
        tag: "hero",
        child: Text("目标页"),
      ),
    );
  }
}
