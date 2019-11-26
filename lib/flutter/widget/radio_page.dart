import 'package:flutter/material.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

//通过groupValue来确保唯一选中，groupValue是动态改变的
class _RadioPageState extends State<RadioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("radio page"),
      ),
      body: Column(
        children: <Widget>[
          Radio(
            value: 1,
            //选中radio的值
            groupValue: 1,
            onChanged: (value) {},
          ),
          Radio(
            value: 2,
            groupValue: 2,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
