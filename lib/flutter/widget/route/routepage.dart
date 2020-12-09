import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/pages/page_home.dart';

///Todo  route的mainstate  opaque
///静态路由优于动态路由，动态路由只用一次，没法重复利用，没有名字，无法做统计

/// 页面替换pushReplacement  第二个页面先init 然后 第一个页面 dispose
///
/// flutter 1.20.2以后页面新建  page1 init  page1 didChangeDependencies page1 build 点击push page2 initState page2 didChangeDependencies page2 build
///    点击返回 page2 dispose  点击返回 page1 didChangeDependencies page1 build  page1 dispose
///
/// todo 两个页面 didChangeDependencies 判断一下Module.current 哪个先后
/// flutter1.17以前 新建页面，上一个页面会重新走didChangeDependencies
class RouterPage extends StatefulWidget {
  @override
  _RouterPageState createState() => _RouterPageState();
}

class _RouterPageState extends State<RouterPage>
    with RouteAware, WidgetsBindingObserver {
  ///路由监控
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    print("page1 initState");
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    routeObserver.unsubscribe(this);
    print("page1 dispose");
  }

  @override
  void didUpdateWidget(RouterPage oldWidget) {
    print("page1 didUpdateWidget");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
    print("page1 didChangeDependencies");
  }

  @override
  void didPush() {
    super.didPush();
    print("page1 didPush");
  }

  @override
  void didPushNext() {
    super.didPushNext();
    print("page1 didPushNext");
  }

  @override
  void didPop() {
    super.didPop();
    print("page1 didPop");
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print("page1 didPopNext");
  }

  @override
  Future<bool> didPopRoute() async {
    print("page1 didPopRoute");
    return true;
  }

  @override
  Future<bool> didPushRoute(String route) async {
    print("page1 didPushRoute $route");
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("page1 build");
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
                    ?.pushReplacement(MaterialPageRoute(builder: (context) {
                  return RouterPage2();
                }));
              },
              child: Text("pushReplacement")),
          FlatButton(
              onPressed: () {
                Navigator.of(context)
                    ?.push(MaterialPageRoute(builder: (context) {
                  return RouterPage2();
                }));
              },
              child: Text("push")),

          ///测试child生命周期
          Page1Child()
        ],
      ),
    );
  }
}

///测试 page1中child的监听
class Page1Child extends StatefulWidget {
  @override
  _Page1ChildState createState() => _Page1ChildState();
}

class _Page1ChildState extends State<Page1Child> with RouteAware {
  static const TAG = "Page1Child";
  @override
  Widget build(BuildContext context) {
    debugPrint("$TAG build ====");
    return Container();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("$TAG didChangeDependencies ====");
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  /// Called when the top route has been popped off, and the current route
  /// shows up.
  @override
  void didPopNext() {
    debugPrint("$TAG didPopNext ====");
  }

  /// Called when the current route has been pushed.
  @override
  void didPush() {
    debugPrint("$TAG didPush ====");
  }

  /// Called when the current route has been popped off.
  @override
  void didPop() {
    debugPrint("$TAG didPop ====");
  }

  /// Called when a new route has been pushed, and the current route is no
  /// longer visible.
  @override
  void didPushNext() {
    debugPrint("$TAG didPushNext ====");
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
  void didUpdateWidget(RouterPage2 oldWidget) {
    print("page2 didUpdateWidget");
  }

  @override
  void didChangeDependencies() {
    print("page2 didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("page2 build");
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
