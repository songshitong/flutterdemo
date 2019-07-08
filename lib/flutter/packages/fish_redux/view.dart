//import 'package:fish_redux/fish_redux.dart';
//import 'package:flutter/material.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/action.dart';
//import 'package:flutterdemo/flutter/packages/fish_redux/state.dart';
//
////构建视图view
//Widget buildView(PageState state, Dispatch dispatch, ViewService viewService) {
//  ListAdapter listAdapter = viewService.buildAdapter();
//  return Scaffold(
//    appBar: AppBar(
//      title: const Text('FishReduxPage'),
//    ),
//    body: Container(
//      child: Column(
//        children: <Widget>[
//          Text("${state.text}"),
//          ScaleTransition(
//              scale: CurvedAnimation(parent: state.animationController, curve: Curves.bounceOut),
//              child: viewService.buildComponent("container")),
//          Expanded(
//              child: ListView.builder(
//            itemBuilder: listAdapter.itemBuilder,
//            itemCount: listAdapter.itemCount,
//          ))
//        ],
//      ),
//    ),
//    floatingActionButton: FloatingActionButton(
//      onPressed: () => {
//            //分发action，触发状态
//            dispatch(PageActionCreator.addAction("${state.text} add "))
//          },
//      tooltip: 'Add',
//      child: const Icon(Icons.add),
//    ),
//  );
//}
