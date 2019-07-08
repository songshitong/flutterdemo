//import 'package:fish_redux/fish_redux.dart';
//import 'package:flutter/material.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/adaper/fish_redux_adapter.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/component/container_component.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/effect.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/reducer.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/state.dart';
//import 'view.dart';
//
//class FishReduxPageWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return FishReduxPage().buildPage(null);
//  }
//}
//
////生成page component    调用buildwidget 生成flutter widget 用于页面跳转
//class FishReduxPage extends Page<PageState, Map<String, dynamic>> {
//  FishReduxPage()
//      : super(
//            initState: initState,
//            view: buildView,
//            effect: buildEffect(),
//            reducer: buildReducer(),
//            dependencies: Dependencies(
//                adapter: FishReduxAdapter(),
//                slots: <String, Dependent<PageState>>{"container": ContainerConnector() + ContainerComponent()}),
//            middleware: <Middleware<PageState>>[
//              logMiddleware(tag: 'Fish Redux Page ===>'),
//            ]);
//
//  //动画 自定义state
//  @override
//  ComponentState<PageState> createState() => CustomStfState();
//}
//
////动画
//class CustomStfState extends ComponentState<PageState> with SingleTickerProviderStateMixin {}
