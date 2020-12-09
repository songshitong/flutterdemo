import 'package:flutter/material.dart';

///row
///column
///嵌套超出屏幕(两个无限大的发生嵌套)，可以限制layout大小，
///也可以使用expanded让子child充满(在row,column,flex中使用)，而不是无限扩大,FittedBox也可以
///充满[SizedBox]也可以
class RowAndColumnPage extends StatefulWidget {
  @override
  RowAndColumnPageState createState() {
    return new RowAndColumnPageState();
  }
}

class RowAndColumnPageState extends State<RowAndColumnPage> {
  static const column = "column";
  static const row = "row";
  var layoutType = "column";
  List<TextDirection> textDirections = [TextDirection.ltr, TextDirection.rtl];
  List<VerticalDirection> verticalDirections = [VerticalDirection.down, VerticalDirection.up];
  List<MainAxisAlignment> mainAxisAlignments = [
    MainAxisAlignment.center,
    MainAxisAlignment.start,
    MainAxisAlignment.end,
    MainAxisAlignment.spaceAround,
    MainAxisAlignment.spaceBetween,
    MainAxisAlignment.spaceEvenly,
  ];
  List<CrossAxisAlignment> crossAxisAlignments = [
    CrossAxisAlignment.start,
    CrossAxisAlignment.end,
    CrossAxisAlignment.center,
//    CrossAxisAlignment.baseline,  flex中CrossAxisAlignment不能设置为CrossAxisAlignment.baseline
    CrossAxisAlignment.stretch

    ///让子充满纵轴
  ];
  int mainIndex = 0;
  int crossIndex = 0;
  int textDirectionIndex = 0;
  int verticalIndex = 0;
  @override
  Widget build(BuildContext context) {
//    Row和Column都继承自Flex
    return Scaffold(
      appBar: AppBar(
        title: Text("row column"),
      ),
      body: Column(
        children: <Widget>[
          DropdownButton(
              hint: Text(layoutType),
              items: [
                DropdownMenuItem(child: Text(column), value: column),
                DropdownMenuItem(child: Text(row), value: row)
              ],
              onChanged: (dynamic value) {
                setState(() {
                  layoutType = value;
                });
              }),
          DropdownButton(
              hint: Text(mainAxisAlignments[mainIndex].toString()),
              items: buildDropMenus(mainAxisAlignments),
              onChanged: (dynamic value) {
                setState(() {
                  mainIndex = value;
                });
              }),
          DropdownButton(
              hint: Text(crossAxisAlignments[crossIndex].toString()),
              items: buildDropMenus(crossAxisAlignments),
              onChanged: (dynamic value) {
                setState(() {
                  crossIndex = value;
                });
              }),
          DropdownButton(
              hint: Text(textDirections[textDirectionIndex].toString()),
              items: [
                DropdownMenuItem(child: Text(textDirections[0].toString()), value: 0),
                DropdownMenuItem(child: Text(textDirections[1].toString()), value: 1)
              ],
              onChanged: (dynamic value) {
                setState(() {
                  textDirectionIndex = value;
                });
              }),
          DropdownButton(
              hint: Text(verticalDirections[verticalIndex].toString()),
              items: [
                DropdownMenuItem(child: Text(verticalDirections[0].toString()), value: 0),
                DropdownMenuItem(child: Text(verticalDirections[1].toString()), value: 1)
              ],
              onChanged: (dynamic value) {
                setState(() {
                  verticalIndex = value;
                });
              }),
          buildLayout(),
        ],
      ),
    );
  }

  List<DropdownMenuItem> buildDropMenus(List list) {
    List<DropdownMenuItem> items = [];
    for (int i = 0; i < list.length; i++) {
      items.add(DropdownMenuItem(child: Text(list[i].toString()), value: i));
    }
    return items;
  }

  buildLayout() {
    if (layoutType == column) {
      return Column(
        // 高度最大屏幕，宽度自适应,最大屏幕宽度，超出报错
        mainAxisAlignment: mainAxisAlignments[mainIndex],
        // 主轴对齐方式
        crossAxisAlignment: crossAxisAlignments[crossIndex],
        //纵轴对齐
        //文字方向  textDirection是mainAxisAlignment的参考系。
        textDirection: textDirections[textDirectionIndex],
        //在主轴(水平)方向占用的空间
        mainAxisSize: MainAxisSize.min,
        //纵轴（垂直）的对齐方向，默认是VerticalDirection.down，表示从上到下。  child 顺序发生反转
        verticalDirection: verticalDirections[verticalIndex],
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("text111"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("text2222222"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("text3"),
          ),
        ],
      );
    } else {
      return Row(
        //高度自适应，宽度最大屏幕
        mainAxisAlignment: mainAxisAlignments[mainIndex],
        crossAxisAlignment: crossAxisAlignments[crossIndex],
        textDirection: textDirections[textDirectionIndex],
        verticalDirection: verticalDirections[verticalIndex],
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("text11"),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("text222222222"),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text("text3"),
          ),
        ],
      );
    }
  }
}
