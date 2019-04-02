import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteAnimationPage extends StatefulWidget {
  @override
  _RouteAnimationPageState createState() => _RouteAnimationPageState();
}

class _RouteAnimationPageState extends State<RouteAnimationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RouteAnimation"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.of(context).push(customRoute());
            },
            child: Text("跳转"),
          )
        ],
      ),
    );
  }

  Route buildMaterialRoute() {
    ///Android上下动画
    return MaterialPageRoute(builder: (context) {
      return TargetRoutePage();
    });
  }

  Route buildCupertinoRoute() {
    ///iOS 左右动画
    return CupertinoPageRoute(builder: (context) {
      return TargetRoutePage();
    });
  }

  Route customRouteBuilder() {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return new FadeTransition(
            //使用渐隐渐入过渡,
            opacity: animation,
            child: TargetRoutePage() //路由B
            );
      },
    );
  }

  Route customRoute() {
    return FadeRoute(builder: (context) {
      return TargetRoutePage();
    });
  }
}

//实际使用时应考虑优先使用PageRouteBuilder，这样无需定义一个新的路由类，使用起来会比较方便。
//但是有些时候PageRouteBuilder是不能满足需求的，例如在应用过渡动画时我们需要读取当前路由的一些属性，这时就只能通过继承PageRoute的方式了
class FadeRoute extends PageRoute {
  FadeRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    //当前路由被激活，是打开新路由
    if (isActive) {
      return FadeTransition(
        opacity: animation,
        child: builder(context),
      );
    } else {
      //是返回，则不应用过渡动画
      return Padding(padding: EdgeInsets.zero);
    }
  }
}

class TargetRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TargetRoute"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("跳转后"),
      ),
    );
  }
}
