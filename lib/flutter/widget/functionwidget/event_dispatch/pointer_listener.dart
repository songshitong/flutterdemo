import 'package:flutter/material.dart';

///原始指针事件   使用[Listener]监听
///当指针按下时，Flutter会对应用程序执行命中测试(Hit Test)，以确定指针与屏幕接触的位置存在哪些widget，
/// 指针按下事件（以及该指针的后续事件）然后被分发到由命中测试发现的最内部的widget，然后从那里开始，事件会在widget树中向上冒泡，
/// 这些事件会从最内部的widget被分发到widget根的路径上的所有Widget，这和Web开发中浏览器的事件冒泡机制相似，
/// 但是Flutter中没有机制取消或停止冒泡过程，而浏览器的冒泡是可以停止的。注意，只有通过命中测试的Widget才能触发事件
///
///
/// 各个事件集成自PointerEvent，跟pressure有关的是按压力度，要求屏幕有压力传感器（3d touch）。
///
///
/// 阻止某个子树响应PointerEvent    IgnorePointer和AbsorbPointer
///
///AbsorbPointer本身会参与命中测试，而IgnorePointer本身不会参与，这就意味着AbsorbPointer本身是可以接收指针事件的(但其子树不行)，而IgnorePointer不可以
class PointerListener extends StatefulWidget {
  @override
  _PointerListenerState createState() => _PointerListenerState();
}

class _PointerListenerState extends State<PointerListener> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ponter listener page"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
          children: <Widget>[
            Listener(
              //translucent：当点击Widget透明区域时，可以对自身边界内及底部可视区域都进行命中测试，
              // 这意味着点击顶部widget透明区域时，顶部widget和底部widget都可以接收到事件

              //opaque 在命中测试时，将当前Widget当成不透明处理(即使本身是透明的)，最终的效果相当于当前Widget的整个区域都是点击区域

              //deferToChild 子widget会一个接一个的进行命中测试，如果子Widget中有测试通过的，则当前Widget通过，
              // 这就意味着，如果指针事件作用于子Widget上时，其父(祖先)Widget也肯定可以收到该事件
              behavior: HitTestBehavior.deferToChild,
              onPointerDown: (event) {
                print("onPointerDown $event");
              },
              onPointerMove: (event) {
                print("onPointerMove $event");
              },
              onPointerUp: (event) {
                print("onPointerUp $event");
              },
              child: Container(
                alignment: Alignment.center,
                width: 150,
                height: 150,
                child: Text("pointer listener info "),
                decoration: BoxDecoration(color: Colors.green),
              ),
            ),
            //这个例子在deferToChild情况下只有点击text才能触发，在opaque情况下，外部的ConstrainedBox也能触发
            //ConstrainedBox 的renderObject RenderConstrainedBox 没有重写hitTest方法，不参与命中测试
            //opaque 将整个区域变为点击区域
            Listener(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(150.0, 150.0)),
                  child: Center(child: Text("Box A")),
                ),
//              behavior: HitTestBehavior.opaque,
                onPointerDown: (event) => print("down A")),
            buildTranslucent(),
            buildAbsorbPointer(),
            buildIgnorePointer()
          ],
        ),
      ),
    );
  }

  Widget buildTranslucent() {
    //多层页面时，
    //deferToChild情况，点击文本，打印down1；点击300*100以下，打印down0；点击300*100的非文字区域，打印down0，这部分未参与命中测试
    //translucent 情况 点击文本，打印down1；点击300*100以下，打印down0；点击300*100的非文字区域，打印down1,down0,此时事件从上层展示
    //击穿到下层展示
    return Stack(
      children: <Widget>[
        Listener(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(300.0, 200.0)),
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.blue)),
          ),
          onPointerDown: (event) => print("down0"),
        ),
        Listener(
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(Size(300.0, 100.0)),
            child: Center(child: Text("左上角300*100范围内非文本区域点击")),
          ),
          onPointerDown: (event) => print("down1"),
//          behavior: HitTestBehavior.translucent, //放开此行注释后可以"点透"
        )
      ],
    );
  }

  Widget buildAbsorbPointer() {
    return Listener(
      child: AbsorbPointer(
        //true 子树不可以响应原始指针   false 可以
        absorbing: true,
        child: Listener(
          //absorbing: true, 页面可以滚动，listview收不到move事件，外部的scrollview可以
          child: ListView(
            shrinkWrap: true,
            children: List<Widget>.generate(20, (index) {
              return Text("$index");
            }),
          ),
          onPointerDown: (event) => print("in"),
          onPointerMove: (e) => print("in move"),
        ),
      ),
      onPointerDown: (event) => print("up"),
      onPointerMove: (e) => print("out move"),
    );
  }

  Widget buildIgnorePointer() {
    return Listener(
      child: IgnorePointer(
        //true 阻止子树响应指针事件   false 不阻止
        ignoring: true,
        child: Listener(
          child: ListView(
            shrinkWrap: true,
            children: List<Widget>.generate(20, (index) {
              return Text("$index");
            }),
          ),
          onPointerDown: (event) => print("IgnorePointer in"),
          onPointerMove: (e) => print("IgnorePointer in move"),
        ),
      ),
      onPointerDown: (event) => print("IgnorePointer up"),
      onPointerMove: (e) => print("IgnorePointer out move"),
    );
  }
}
