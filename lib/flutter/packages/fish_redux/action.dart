import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

enum PageAction { init, add, controller }

//用户操作和初始化的action
//Effect 接受处理的 Action，以 on{Verb} 命名
//Reducer 接受处理的 Action，以{verb} 命名
class PageActionCreator {
  static initAction(Map<String, dynamic> params) {
    return Action(PageAction.init, payload: params);
  }

  static addAction(String str) {
    return Action(PageAction.add, payload: str);
  }

  static createController(AnimationController controller) {
    return Action(PageAction.controller, payload: controller);
  }
}
