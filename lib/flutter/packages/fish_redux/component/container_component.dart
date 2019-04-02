import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/component/action.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/component/reducer.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/component/state.dart';

//定义子组件ContainerComponent
class ContainerComponent extends Component<ContainerState> {
  ContainerComponent()
      : super(
          view: buildContainerView,
          reducer: buildReducer(),
        );
}

Widget buildContainerView(
  ContainerState state,
  Dispatch dispatch,
  ViewService viewService,
) {
  return Container(
    decoration: BoxDecoration(color: Colors.black12),
    child: Column(
      children: <Widget>[
        Text("ContainerComponent text is ${state.text}"),
        RaisedButton(
          onPressed: () {
            dispatch(ContainerActionCreator.onEditAction("${state.text} 1"));
          },
          child: Text("append father text 1"),
        ),
        RaisedButton(
          onPressed: () {
            if (state.text.length < 2) {
              return;
            }
            dispatch(ContainerActionCreator.onDeleteAction("${state.text.substring(0, state.text.length - 2)}"));
          },
          child: Text("delete father text last char"),
        )
      ],
    ),
  );
}
