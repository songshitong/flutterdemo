import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///RefreshIndicator android 风格
///CupertinoSliverRefreshControl ios风格   菊花 CupertinoActivityIndicator   必要有AlwaysScrollableScrollPhysics作为parent的physics
class RefreshPage extends StatefulWidget {
  @override
  _RefreshPageState createState() => _RefreshPageState();
}

class _RefreshPageState extends State<RefreshPage> {
  @override
  Widget build(BuildContext context) {
    return /*CupertinoPage*/ Scaffold(
        body: CustomScrollView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: <Widget>[
        //bar的作用是让菊花从屏幕顶部下来
        CupertinoSliverNavigationBar(
          largeTitle: Text("refresh page"),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () {
            print("cupertino onrefresh === ");
            return getData();
          },
        )
      ],
    ));
  }

  Future<void> getData() {
    return Future.delayed(Duration(seconds: 3));
  }
}
