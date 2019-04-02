import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

///自定义layout-- renderbox
class CustomRBWidget extends MultiChildRenderObjectWidget {
  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRB(_width);
  }

  double _width = 0;

  CustomRBWidget(
    this._width, {
    List<Widget> children = const <Widget>[],
  }) : super(children: children);
}

class CustomRB extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, CustomRbData>, RenderBoxContainerDefaultsMixin<RenderBox, CustomRbData> {
  double _width;
  CustomRB(this._width) {
    markNeedsLayout();
  }

  @override
  void performLayout() {
    RenderBox child = firstChild;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    double mainAxisExtent = 0;
    double crossAxisExtent = 0;
    BoxConstraints childConstraints = BoxConstraints(maxWidth: constraints.maxWidth);
    while (child != null) {
      print("parentdata ${child.parentData}");
      final CustomRbData childParentData = child.parentData;
      child.layout(childConstraints, parentUsesSize: true);
      crossAxisExtent = child.size.height;
      child = childParentData.nextSibling;
    }
    print("constraints $constraints");
    mainAxisExtent = _width;
    size = constraints.constrain(Size(mainAxisExtent, crossAxisExtent));
  }

  @override
  bool hitTestChildren(HitTestResult result, {Offset position}) {
    return defaultHitTestChildren(result, position: position);
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
    while (child != null) {
      final CustomRbData childParentData = child.parentData;
//      LogUtil.debug("childParentData $childParentData offset $offset");
      final last = allWidth;
      allWidth += child.size.width;
      if (allWidth <= boxSize.width) {
        context.paintChild(child, childParentData.offset + offset + Offset(last, 0));
      }
      child = childParentData.nextSibling;
    }
  }
}

/// Parent data for use with [RenderWrap].
class CustomRbData extends ContainerBoxParentData<RenderBox> {
  int _runIndex = 0;
}
