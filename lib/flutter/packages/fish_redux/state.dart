//import 'package:fish_redux/fish_redux.dart';
//import 'package:flutter/material.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/adaper/state.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/component/state.dart';
//
////状态信息及初始化状态
//PageState initState(Map<String, dynamic> args) {
//  return PageState();
//}
//
//class PageState extends Cloneable<PageState> {
//  String text;
//  AnimationController animationController;
//  List<ItemState> datas;
//  @override
//  PageState clone() {
//    //返回一个相同的PageState
//    return PageState()
//      ..text = text
//      ..animationController = animationController
//      ..datas = datas;
//  }
//}
//
////设置父子数据同步方式                     父组件状态 ，子组件状态
//class ContainerConnector extends ConnOp<PageState, ContainerState> {
//  //根据父组件状态获取子组件状态
//  @override
//  ContainerState get(PageState state) {
//    return ContainerState()..text = state.text;
//  }
//
//  //根据子组件状态更新父组件
//  @override
//  void set(PageState state, ContainerState substate) {
//    state.text = substate.text;
//  }
//}
