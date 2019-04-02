import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/pages/beautiful/lable_widget.dart';
import 'package:flutterdemo/flutter/widget/customwidget/one_line_layout.dart';

class TestOneLineLayoutWidget extends StatefulWidget {
  @override
  _TestOneLineLayoutWidgetState createState() => _TestOneLineLayoutWidgetState();
}

class _TestOneLineLayoutWidgetState extends State<TestOneLineLayoutWidget> {
  bool addLayout = false;
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TestOneLineLayoutWidget"),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () {},
            child: Ink(
              padding: EdgeInsets.all(10),
              color: Colors.grey,
              child: OneLineLayout(
                isExpanded: expanded,
                width: window.physicalSize.width / window.devicePixelRatio - 16,
                children: _buildLables(),
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                addLayout = !addLayout;
              });
            },
            child: Text("add layout"),
          ),
          RaisedButton(
            onPressed: () {
              setState(() {
                expanded = !expanded;
              });
            },
            child: Text("! expanded"),
          )
        ],
      ),
    );
  }

  List<Widget> _buildLables() {
    List<Widget> widgets = [];
    if (addLayout) {
      for (int i = 0; i < 10; i++) {
        widgets.add(
            /*Container(
          margin: EdgeInsets.all(10),
          width: 100,
          height: 50,
          color: Colors.deepOrange,
        )*/
            LableWidget("便签 $i", i));
      }
    }
    return widgets;
  }
}
