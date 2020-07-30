import 'package:flutter/material.dart';

///Todo  route的mainstate  opaque
///静态路由优于动态路由，动态路由只用一次，没法重复利用，没有名字，无法做统计

/// 页面替换pushReplacement  第二个页面先init 然后 第一个页面 dispose
class RouterPage extends StatefulWidget {
  @override
  _RouterPageState createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage> {
  @override
  void initState() {
    super.initState();
    print("page1 initState");
  }

  @override
  void dispose() {
    super.dispose();
    print("page1 dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("router page"),
      ),
      body: Column(
        children: <Widget>[
          Text("当前page1"),
          FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return RouterPage2();
                }));
              },
              child: Text("前进"))
        ],
      ),
    );
  }
}

class RouterPage2 extends StatefulWidget {
  @override
  _RouterPage2State createState() => _RouterPage2State();
}

class _RouterPage2State extends State<RouterPage2> {
  @override
  void initState() {
    super.initState();
    print("page2 initState");
  }

  @override
  void dispose() {
    super.dispose();
    print("page2 dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("router page"),
      ),
      body: Column(
        children: <Widget>[
          Text("当前page2"),
        ],
      ),
    );
  }
}
