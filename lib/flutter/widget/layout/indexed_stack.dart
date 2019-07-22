import 'package:flutter/material.dart';

//可以换页
class IndexedStackPage extends StatefulWidget {
  @override
  _IndexedStackPageState createState() => _IndexedStackPageState();
}

class _IndexedStackPageState extends State<IndexedStackPage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IndexedStackPage"),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: <Widget>[Page1(), Page2()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            print(index);
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("item1")),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("item2")),
          ]),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(8),
          width: 500,
          height: 100,
          color: Colors.green,
        ),
        Container(
          margin: EdgeInsets.all(8),
          width: 500,
          height: 100,
          color: Colors.green,
        ),
        Container(
          margin: EdgeInsets.all(8),
          width: 500,
          height: 100,
          color: Colors.green,
        )
      ],
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  bool show = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        show = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(visible: show, child: Text("page2")),
      ],
    );
  }
}
