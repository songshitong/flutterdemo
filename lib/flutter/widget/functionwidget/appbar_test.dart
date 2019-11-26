import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';

///使用PreferredSize自定义APPbar
class AppbarPage extends StatefulWidget {
  @override
  _AppbarPageState createState() => _AppbarPageState();
}

class _AppbarPageState extends State<AppbarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text("i am appbar"),
          ),
          preferredSize: Size(MediaQuery.of(context).size.width, 200)),
      body: Column(
        children: <Widget>[
          PreferredSize(
              child: AppBar(
                title: Text("another bar"),
              ),
              //不生效，APPBar有默认高度
              preferredSize: Size(MediaQuery.of(context).size.width, 200))
        ],
      ),
    );
  }
}
