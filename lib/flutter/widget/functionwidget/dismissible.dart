import 'package:flutter/material.dart';

//Dismissible  滑动将子widget移除，本身一直在
class DismissiblePage extends StatefulWidget {
  @override
  _DismissablePageState createState() => _DismissablePageState();
}

class _DismissablePageState extends State<DismissiblePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DismissablePage"),
      ),
      body: Column(
        children: <Widget>[
          Dismissible(
            key: Key("Dismissible"),
            child: Container(
              child: Text("this is Dismissible"),
              width: 100,
              height: 150,
            ),
            //右滑背景
            background: Container(decoration: BoxDecoration(color: Colors.grey), width: 100, height: 150),
            //左滑背景 只有在background设置后才能设置
            secondaryBackground: Container(decoration: BoxDecoration(color: Colors.green), width: 100, height: 150),
          )
        ],
      ),
    );
  }
}
