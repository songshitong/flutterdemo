import 'package:flutter/material.dart';

///共享动画
//todo 自定义共享动画  createRectTween
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
    return Scaffold(
      appBar: AppBar(
        title: Text("HeroPage"),
      ),
      body: Column(
        children: <Widget>[
          Hero(
            tag: "hero",
            child: RaisedButton(
              onPressed: () {
                Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                  return new FadeTransition(
                    opacity: animation,
                    child: Scaffold(appBar: AppBar(title: Text("TargetPage")), body: TargetPage()),
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
