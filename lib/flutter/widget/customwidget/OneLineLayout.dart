import 'package:flutter/material.dart';

///自定义CustomMultiChildLayout  多子layout  布局标记有LayoutID的widget
class OneLineLayout extends StatelessWidget {
  List<Widget> _childs = <Widget>[
    LayoutId(id: "onelinelayout1", child: Text("a")),
    LayoutId(id: "onelinelayout2", child: Text("bbbbbbbbbb")),
    LayoutId(id: "onelinelayout3", child: Text("cccccccccc")),
    LayoutId(id: "onelinelayout4", child: Text("dddddddddddddd")),
    LayoutId(id: "onelinelayout5", child: Text("eeeeeeee")),
    LayoutId(id: "onelinelayout6", child: Text("ffffffff")),
    LayoutId(id: "onelinelayout7", child: Text("gggggggggggg")),
    LayoutId(id: "onelinelayout8", child: Text("hhhhhhhhhh")),
  ];
  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _MyDelegate(_childs),
      children: _childs,
    );
  }
}

class _MyDelegate extends MultiChildLayoutDelegate {
  List<Widget> _childs;

  _MyDelegate(this._childs);

  @override
  void performLayout(Size size) {
    //该方法必须调用layoutChild 和 positionChild
    //hasChild  判断子ID是否存在
    //
    print("onlinelayout" + size.toString());
    double allWidth = 0;
    for (int i = 0; i < _childs.length; i++) {
      final String childId = 'onelinelayout$i';
      if (hasChild(childId)) {
        final last = allWidth;
        allWidth += layoutChild(childId, BoxConstraints.loose(size)).width;
        if (allWidth >= size.width) {
          continue;
        } else {
          positionChild(childId, Offset(last, 0));
        }
      }
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) {
    return false;
  }
}
