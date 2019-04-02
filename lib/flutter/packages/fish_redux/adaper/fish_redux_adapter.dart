import 'package:fish_redux/fish_redux.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/adaper/item_compeonent.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/adaper/state.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/state.dart';
import 'reducer.dart';

class FishReduxAdapter extends DynamicFlowAdapter<PageState> {
  FishReduxAdapter()
      : super(
          pool: <String, Component<Object>>{
            "type_1": ItemComponent(),
          },
          connector: _BuildConnect(),
          reducer: buildReducer(),
        );
}

// state与adapter建立关系， ItemBean 保存type和data
class _BuildConnect extends ConnOp<PageState, List<ItemBean>> {
  //根据state 初始化 adapter 数据list<ItemBean>
  @override
  List<ItemBean> get(PageState state) {
    if (state.datas?.isNotEmpty == true) {
      return state.datas.map<ItemBean>((ItemState data) => ItemBean('type_1', data)).toList(growable: true);
    } else {
      return <ItemBean>[];
    }
  }

  //substate 改变 同步 state改变
  @override
  void set(PageState state, List<ItemBean> subState) {
    if (subState?.isNotEmpty == true) {
      state.datas = List<ItemState>.from(subState.map<PageState>((ItemBean bean) => bean.data).toList());
    } else {
      state.datas = <ItemState>[];
    }
  }
}
