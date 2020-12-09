import 'package:flutter/material.dart';

class MAnimatedList extends StatefulWidget {
  @override
  _MAnimatedListState createState() => _MAnimatedListState();
}

class _MAnimatedListState extends State<MAnimatedList> {
  GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<int> datas = [];

  @override
  void initState() {
    super.initState();
    addList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MAnimatedList"),
        actions: [
          RaisedButton(
            onPressed: () {
              addList();
            },
            child: Text("add list"),
          ),
          RaisedButton(
            onPressed: () {
              datas.removeAt(0);
              listKey.currentState?.removeItem(
                  0, (context, animation) => buildItem(animation, context, 0));
            },
            child: Text("remove 0"),
          )
        ],
      ),
      body: AnimatedList(
          key: listKey,
          initialItemCount: datas.length,
          itemBuilder: (context, index, animation) {
            return buildItem(animation, context, index);
          }),
    );
  }

  void addList() {
    Future.forEach(List<int>.generate(10, (index) => index), (element) {
      return Future.delayed(Duration(milliseconds: 200)).then((_) {
        print("${DateTime.now().millisecondsSinceEpoch}");
        datas.insert(0, 0);
        listKey.currentState?.insertItem(0);
      });
    });
  }

  SlideTransition buildItem(
      Animation<double> animation, BuildContext context, int index) {
    return SlideTransition(
      position: animation.drive(
          Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.decelerate))),
      child: Container(
        color: Colors.deepPurple[200],
        margin: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Text("$index"),
      ),
    );
  }
}
