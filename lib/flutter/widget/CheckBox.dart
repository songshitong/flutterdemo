import 'package:flutter/material.dart';

class CheckBoxPage extends StatefulWidget {
  @override
  _CheckBoxPageState createState() => _CheckBoxPageState();
}

class _CheckBoxPageState extends State<CheckBoxPage> {
  bool _checkValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("checkbox"),
      ),
      body: Column(
        children: <Widget>[
          Checkbox(
              value: true,
              activeColor: Colors.red,
              onChanged: (value) {
                print("onchaged1 $value");
              }),
          Checkbox(
              value: _checkValue,
              onChanged: (value) {
                print("onchaged2 $value");
                _checkValue = value;
                setState(() {});
              }),
          Checkbox(
              value: null,
              tristate: true,
              onChanged: (value) {
                print("onchaged3 $value");
              }),
        ],
      ),
    );
  }
}
