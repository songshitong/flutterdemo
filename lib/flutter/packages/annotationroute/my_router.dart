import 'package:annotation_route/route.dart';
import 'package:flutterdemo/flutter/packages/annotationroute/my_router.internal.dart';

//flutter packages pub run build_runner build --delete-conflicting-outputs
// flutter packages pub run build_runner clean
@ARouteRoot()
class MyRouter {
  static ARouterInternal internal = ARouterInternalImpl();
  static dynamic getPage(MyRouteOption option) {
    return internal.findPage(ARouteOption(option.urlpattern, option.params), option);
  }
}

class MyRouteOption {
  String urlpattern;
  Map<String, dynamic> params;
}
