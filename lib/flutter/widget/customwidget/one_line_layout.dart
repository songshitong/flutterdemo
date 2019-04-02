import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

///只绘制一行，传入任意个child，超出width不绘制
///绘制多行，自动换行
class OneLineLayout extends MultiChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRB(width, this.isExpanded);
  }

  double width;

  ///false 展示一行 true 展示多行
  bool isExpanded;
  OneLineLayout({
    this.width = 0,
    this.isExpanded = false,
    List<Widget> children = const <Widget>[],
  }) : super(children: children);

  @override
  void updateRenderObject(BuildContext context, CustomRB renderObject) {
    /// 设置 setSate 生效的
    super.updateRenderObject(context, renderObject);
    renderObject
      ..width = width
      ..isExpanded = this.isExpanded
      ..child = children;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties
        .add(FlagProperty("isExpanded", value: isExpanded, ifTrue: "expanded is true", ifFalse: "expanded is false"));
    properties.add(IterableProperty('child', children));
  }
}

class CustomRB extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, CustomRbData>, RenderBoxContainerDefaultsMixin<RenderBox, CustomRbData> {
  double _width;
  bool _isExpanded;
  List<Widget> _children;

  set width(double w) {
    _width = w;

    ///标记宽度变化时 布局更改
    markNeedsLayout();
    markParentNeedsLayout();
  }

  set isExpanded(bool boo) {
    _isExpanded = boo;
    markNeedsLayout();
    markParentNeedsLayout();
  }

  set child(List<Widget> children) {
    _children = children;
    markNeedsLayout();
    markParentNeedsLayout();
  }

  CustomRB(this._width, this._isExpanded) {
    if (null == _isExpanded) {
      _isExpanded = false;
    }
  }

  @override
  void performLayout() {
    print("online layout performLayout");
    RenderBox child = firstChild;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    double mainAxisExtent = 0;
    double crossAxisExtent = 0;
    //一行宽度
    double lineWidth = 0;
    BoxConstraints childConstraints = BoxConstraints(maxWidth: constraints.maxWidth);
    if (null != _width && _width > 0) {
      mainAxisExtent = _width;
    } else {
      mainAxisExtent = constraints.maxWidth;
    }
    //遍历个数---计数用
    int index = 1;
    while (child != null) {
//      LogUtil.debug("index $index");
      index++;
//      LogUtil.debug("parentdata ${child.parentData}");
      final CustomRbData childParentData = child.parentData;
      child.layout(childConstraints, parentUsesSize: true);
      if (_isExpanded) {
        lineWidth += child.size.width;
        if (0 == crossAxisExtent) {
          //初始height
          crossAxisExtent = child.size.height;
        }
        print("performLayout lineWidth $lineWidth mainAxisExtent $mainAxisExtent");
        if (lineWidth > mainAxisExtent) {
          //换行后当前总长度为第一个长度
          lineWidth = child.size.width;
          crossAxisExtent += child.size.height;
          print("performLayout 换行 crossAxisExtent $crossAxisExtent");
        }
      } else {
        crossAxisExtent = child.size.height;
      }
      size = constraints.constrain(Size(mainAxisExtent, crossAxisExtent));
      child = childParentData.nextSibling;
    }
    print("one line layout performLayout size $size");
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! CustomRbData) child.parentData = CustomRbData();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    RenderBox child = firstChild;
    final Size boxSize = size;
    double allWidth = 0;
    double allHeight = 0;
//    LogUtil.debug("boxSize.width ${boxSize.width} isExpanded $_isExpanded");
    while (child != null) {
      final CustomRbData childParentData = child.parentData;
//      LogUtil.debug("childParentData $childParentData offset $offset");
      var last = allWidth;
      //上一行高度
      Offset paintOffset;
      allWidth = (last + child.size.width);
      if (_isExpanded) {
        if (allWidth > boxSize.width) {
//          LogUtil.debug("换行 allwidth $allWidth boxSize.width ${boxSize.width}");
          //重启一行 height增加
          //总宽度为换行第一个，高度自动增加
          allWidth = child.size.width;
          allHeight += child.size.height;
          paintOffset = offset + Offset(0, allHeight);
        } else {
          paintOffset = offset + Offset(last, allHeight);
        }
//        LogUtil.debug("paintOffset $paintOffset  offset $offset Offset(last, allHeight) ${Offset(last, allHeight)}");
        context.paintChild(child, paintOffset);
      } else if (allWidth <= boxSize.width) {
        context.paintChild(child, offset + Offset(last, allHeight));
      }
      child = childParentData.nextSibling;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', _width));
    properties.add(FlagProperty("isExpanded", value: _isExpanded));
    properties.add(IterableProperty('child', _children));
  }
}

/// Parent data for use with [CustomRB].
class CustomRbData extends ContainerBoxParentData<RenderBox> {
  int _runIndex = 0;
}
