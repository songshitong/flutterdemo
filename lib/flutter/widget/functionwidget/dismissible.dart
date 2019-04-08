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
            child: Text("this is Dismissible"),
            //右滑背景
            background: Container(
              decoration: BoxDecoration(color: Colors.grey),
            ),
            //左滑背景 只有在background设置后才能设置
            secondaryBackground: Container(
              decoration: BoxDecoration(color: Colors.green),
            ),
          )
        ],
      ),
    );
  }
}
