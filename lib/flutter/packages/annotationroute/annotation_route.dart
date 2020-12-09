import 'package:annotation_route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/packages/annotationroute/my_router.dart';

//咸鱼路由注解  https://pub.dartlang.org/packages/annotation_route#-readme-tab-

const page1_url = "myapp://page1";
const page2_url = "myapp://page2";

@ARoute(url: page1_url)
class AnnotationRoutePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("page1"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Map<String, dynamic> params = new Map();
            params["param"] = "this is param";
            String url = page2_url;
            var page = MyRouter.getPage(MyRouteOption()
              ..urlpattern = url
              ..params = params);
            if (page is ARouterResult) {
              var widget = page.widget;
              print("get page $widget");
              if (widget == null) return;
              Navigator.of(context)?.push(MaterialPageRoute(
                  settings: RouteSettings(name: url),
                  builder: (context) {
                    return widget;
                  }));
            }
          },
          child: Text("跳转"),
        ),
      ),
    );
  }

  AnnotationRoutePage1(String? param);
}

@ARoute(url: page2_url)
class RoutePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("page2"),
      ),
    );
  }

  RoutePage2(dynamic param);
}
