import 'package:fish_redux/fish_redux.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/adaper/state.dart';

enum ItemAction { remove }

class ItemActionCreator {
  static removeAction(ItemState itemState) {
    return Action(ItemAction.remove, payload: itemState);
  }
}
