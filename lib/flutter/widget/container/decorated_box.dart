import 'package:flutter/material.dart';

class DecoratedBoxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    DecoratedBox可以在其子widget绘制前(或后)绘制一个装饰Decoration（如背景、边框、渐变等）
//    decoration：代表将要绘制的装饰，它类型为Decoration，Decoration是一个抽象类，它定义了一个接口 createBoxPainter()，子类的主要职责是需要通过实现它来创建一个画笔，该画笔用于绘制装饰。
//    position：此属性决定在哪里绘制Decoration，它接收DecorationPosition的枚举类型，该枚举类两个值：
//    background：在子widget之后绘制，即背景装饰。
//    foreground：在子widget之上绘制，即前景
    return Scaffold(
      appBar: AppBar(
        title: Text("DecoratedBox"),
      ),
      body: Column(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange[700]]), //背景渐变
                borderRadius: BorderRadius.circular(3.0), //3像素圆角
                boxShadow: [
                  //阴影
                  BoxShadow(color: Colors.black54, offset: Offset(2.0, 2.0), blurRadius: 4.0)
                ]),
            position: DecorationPosition.background,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("text"),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.red, Colors.orange[700]]), //背景渐变
                shape: BoxShape.circle,
                boxShadow: [
                  //阴影
                  BoxShadow(color: Colors.black54, offset: Offset(2.0, 2.0), blurRadius: 4.0)
                ]),
            position: DecorationPosition.background,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("text"),
            ),
          )
        ],
      ),
    );
  }
}
