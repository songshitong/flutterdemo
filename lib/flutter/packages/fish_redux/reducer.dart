//import 'package:fish_redux/fish_redux.dart' as Fish;
//import 'package:flutter/material.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/action.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/state.dart';
//
////对状态改变进行处理
//Fish.Reducer<PageState> buildReducer() {
//  return Fish.asReducer(
//    <Object, Fish.Reducer<PageState>>{
//      PageAction.init: _initPageReducer,
//      PageAction.add: _addPageReducer,
//      PageAction.controller: _addController
//    },
//  );
//}
//
//PageState _initPageReducer(PageState state, Fish.Action action) {
//  var param = action.payload;
//  String str = param["text"] as String;
//  PageState newState = state.clone()
//    ..text = str
//    ..datas = param["itemList"];
//  return newState;
//}
//
//PageState _addPageReducer(PageState state, Fish.Action action) {
//  String str = action?.payload == null ? "" : action.payload;
//  PageState newState = state.clone()..text = str;
//  return newState;
//}
//
//PageState _addController(PageState state, Fish.Action action) {
//  AnimationController ac = action.payload;
//  if (null != ac) {
//    ac.forward();
//  }
//  PageState newState = state.clone()..animationController = action.payload;
//
//  return newState;
//}
