import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/adaper/action.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/adaper/state.dart';

class ItemComponent extends Component<ItemState> {
  ItemComponent()
      : super(
          view: buildItemView,
        );
}

Widget buildItemView(ItemState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.cyanAccent.shade200,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text(" list item ${state.text}"),
          RaisedButton(
            onPressed: () {
              dispatch(ItemActionCreator.removeAction(state));
            },
            child: Text("delete item"),
          )
        ],
      ),
    ),
  );
}
