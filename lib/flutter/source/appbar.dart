import 'package:flutter/material.dart';
import 'package:gwadarpro/common/assets.dart';
import 'package:gwadarpro/common/functions.dart';

final double baseAppBarHeight = hs(110);

///todo 标题栏样式不一致  PreferredSize的大小
class MAppBar {
  static PreferredSize buildAppBar(BuildContext context, List<Widget> children, {Key key}) {
    var viewPaddingTop = MediaQuery.of(context).viewPadding.top;
    if (null == viewPaddingTop || viewPaddingTop == 0) {
      viewPaddingTop = hs(60);
    }
    return PreferredSize(
        child: Container(
          padding: EdgeInsets.only(
            top: viewPaddingTop,
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(end: Alignment(1.2, 0), colors: <Color>[Color(0xff1a52a4), Color(0xff0e2a6f)])),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: children),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, baseAppBarHeight + viewPaddingTop));
  }

  static PreferredSize buildAppBarWidthBack(BuildContext context, List<Widget> children, {Key key}) {
    children.insert(
        0,
        FlatButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          padding: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.only(left: ws(50), right: ws(20)),
            child: Image.asset(
              AllAssets.icon_back,
              width: ws(27),
              height: hs(49),
            ),
          ),
        ));
    return buildAppBar(context, children, key: key);
  }

  static PreferredSize buildCenterTitleWithClose(BuildContext context, String title, TextStyle titleStyle,
      {Widget left = const CloseButton(),
      Color startColor = const Color(0xff1a52a4),
      Color endColor = const Color(0xff0e2a6f)}) {
    var viewPaddingTop = MediaQuery.of(context).viewPadding.top;
    if (null == viewPaddingTop || viewPaddingTop == 0) {
      viewPaddingTop = hs(60);
    }
    return PreferredSize(
        child: Container(
          padding: EdgeInsets.only(
            top: viewPaddingTop,
          ),
          decoration:
              BoxDecoration(gradient: LinearGradient(end: Alignment(1.2, 0), colors: <Color>[startColor, endColor])),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              left,
              Center(
                  child: Text(
                title,
                style: titleStyle,
              ))
            ],
          ),
        ),
        preferredSize: Size(MediaQuery.of(context).size.width, baseAppBarHeight + viewPaddingTop / 2));
  }

  static PreferredSize buildCenterTitleWithBack(BuildContext context, String title, TextStyle titleStyle) {
    return buildCenterTitleWithClose(context, title, titleStyle,
        left: GestureDetector(
          onTap: () {
            Navigator.of(context).maybePop();
          },
          child: Padding(
            padding: EdgeInsets.only(left: ws(50), right: ws(20)),
            child: Image.asset(
              AllAssets.icon_back,
              width: ws(27),
              height: hs(49),
            ),
          ),
        ));
  }
}
