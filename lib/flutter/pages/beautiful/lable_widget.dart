import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/pages/beautiful/OfpColor.dart';

typedef GestureTapCallback = void Function(bool);

///用户标签--我需要，我提供
class LableWidget extends StatefulWidget {
  @override
  LableWidgetState createState() {
    return new LableWidgetState();
  }

  String content;

  ///是否可选 false不可选
  bool isSelectable;

  ///默认选择状态 true选中
  bool isSelected;

  ///点击状态下，背景是否改变
  bool isChangeBg;
  final GestureTapCallback onTap;
  Widget leftWidget;

  ///使用index避免随机数每次变化
  int index;
  LableWidget(this.content, this.index,
      {this.isSelectable = false, this.onTap, this.isSelected = true, this.leftWidget, this.isChangeBg = true}) {
    if (null == this.leftWidget) {
      this.leftWidget = Container();
    }
  }
}

class LableWidgetState extends State<LableWidget> {
  Color bgColor = OfpColor.MINE_LABLE_ENBLE;
  @override
  void initState() {
    super.initState();
    if (!widget.isSelected) {
      bgColor = OfpColor.MINE_LABLE_UNENBLE;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isSelectable) {
          widget.isSelected = !widget.isSelected;
          setState(() {
            if (widget.isChangeBg) {
              if (bgColor == OfpColor.MINE_LABLE_ENBLE) {
                bgColor = OfpColor.MINE_LABLE_UNENBLE;
              } else {
                bgColor = OfpColor.MINE_LABLE_ENBLE;
              }
            }
          });
          if (null != widget.onTap) {
            widget.onTap(widget.isSelected);
          }
        }
      },
      child: CustomPaint(
        painter: _MyCustomPainter(bgColor, widget.isSelected, widget.index),
        child: RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                widget.leftWidget,
                Text(
                  widget.content,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyCustomPainter extends CustomPainter {
  double _radius = 0;
  static const colors = [
    OfpColor.MINE_LABLE_LEFT1,
    OfpColor.MINE_LABLE_LEFT2,
    OfpColor.MINE_LABLE_LEFT3,
    OfpColor.MINE_LABLE_LEFT4,
    OfpColor.MINE_LABLE_LEFT5,
  ];
  bool isSelected;
  int index;
  _MyCustomPainter(this.bgColor, this.isSelected, this.index) {
    bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.fill;
    linePaint = Paint()
      ..color = colors[index % 5]
      ..style = PaintingStyle.fill;
  }

  Paint bgPaint;
  Paint linePaint;
  Color bgColor;
  @override
  void paint(Canvas canvas, Size size) {
//    LogUtil.debug(size);
    _radius = size.height / 2;
    //背景
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width - _radius, size.height), bgPaint);
    //右侧半圆
    canvas.drawCircle(Offset(size.width - _radius, size.height - _radius), _radius, bgPaint);
    //左侧线
    if (isSelected) {
      canvas.drawRect(Rect.fromLTRB(0, 0, 3, size.height), linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
