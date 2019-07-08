////对状态改变进行处理
//import 'package:fish_redux/fish_redux.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/component/action.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/component/state.dart';
//
//Reducer<ContainerState> buildReducer() {
//  return asReducer(
//    <Object, Reducer<ContainerState>>{ContainerAction.append: _appendReducer, ContainerAction.delete: _deleteReducer},
//  );
//}
//
//ContainerState _deleteReducer(ContainerState state, Action action) {
//  String str = action?.payload == null ? "" : action.payload;
//  ContainerState newState = state.clone()..text = str;
//  return newState;
//}
//
//ContainerState _appendReducer(ContainerState state, Action action) {
//  String str = action?.payload == null ? "" : action.payload;
//  ContainerState newState = state.clone()..text = str;
//  return newState;
//}
