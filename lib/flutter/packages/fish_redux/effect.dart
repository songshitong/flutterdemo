//import 'package:fish_redux/fish_redux.dart' as Fish;
//import 'package:flutter/material.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/action.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/adaper/state.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/fish_redux_page.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/state.dart';
//
////对不改变数据状态行为的处理，通过触发action来改变数据状态
//Fish.Effect<PageState> buildEffect() {
//  return Fish.combineEffects(<Object, Fish.Effect<PageState>>{
//    Fish.Lifecycle.initState: _initState,
//  });
//}
//
//dynamic _initState(dynamic action, Fish.Context<PageState> ctx) {
//  //初始列表
//  List<ItemState> list = [
//    ItemState(text: "item 1"),
//    ItemState(text: "item 2"),
//    ItemState(text: "item 3"),
//    ItemState(text: "item 4"),
//    ItemState(text: "item 5"),
//    ItemState(text: "item 6"),
//    ItemState(text: "item 7"),
//    ItemState(text: "item 8"),
//    ItemState(text: "item 9"),
//    ItemState(text: "item 10"),
//    ItemState(text: "item 11"),
//    ItemState(text: "item 12"),
//    ItemState(text: "item 13"),
//    ItemState(text: "item 14"),
//    ItemState(text: "item 15"),
//    ItemState(text: "item 16"),
//    ItemState(text: "item 17"),
//    ItemState(text: "item 18"),
//    ItemState(text: "item 19"),
//  ];
//  ctx.dispatch(PageActionCreator.initAction({"text": "text init now ", "itemList": list}));
//
//  //动画
//  final TickerProvider tickerProvider = ctx.stfState as CustomStfState;
//  AnimationController controller = AnimationController(vsync: tickerProvider, duration: Duration(seconds: 3));
//  ctx.dispatch(PageActionCreator.createController(controller));
//}
