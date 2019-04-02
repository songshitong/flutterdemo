import 'package:flutter/material.dart';

class BottomBtnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ButtomBtnPage"),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(width: MediaQuery.of(context).size.width, alignment: Alignment.center, child: BottomBtn()),
            bottom: 0,
          ),
        ],
      ),
    );
  }
}

///    BottomNavigationBar 和  appbar 的适配原理     适配刘海屏,底部导航按钮等
class BottomBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //查询底部buttom
    double bottom = MediaQuery.of(context).padding.bottom;
    print("bootom $bottom");
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      //这块没有内容？？
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: RaisedButton(
          onPressed: () {},
          child: Text("bottom btn"),
        ),
      ),
    );
  }
}
