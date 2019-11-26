import 'package:flutter/material.dart';

class BoxPage extends StatelessWidget {
  Widget redBox = DecoratedBox(
    decoration: BoxDecoration(color: Colors.red),
  );
  @override
  Widget build(BuildContext context) {
//    ConstrainedBox和SizedBox都是通过RenderConstrainedBox来渲染的。SizedBox只是ConstrainedBox一个定制
//    ConstrainedBox用于对齐子widget添加额外的约束。
// 例如，如果你想让子widget的最小高度是80像素，你可以使用const BoxConstraints(minHeight: 80.0)作为子widget的约束
    // 约束可以覆盖子widget的大小
//    BoxConstraints用于设置限制条件
//    有多重限制时，对于minWidth和minHeight来说，是取父子中相应数值较大的。实际上，只有这样才能保证父限制与子限制不冲突
    // 对于maxWidth 和maxHeight 来说，取父子数值中的较小值，即同时满足父子的最大限制

//    SizedBox用于给子widget指定固定的宽高 相当于BoxConstraints.tightFor

//    UnconstrainedBox不会对子Widget产生任何限制，它允许其子Widget按照其本身大小绘制。
// 一般情况下，我们会很少直接使用此widget，但在"去除"多重限制的时候也许会有帮助
    return Scaffold(
      appBar: AppBar(
        title: Text("Sizedbox--ConstrainedBox"),
      ),
      body: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: double.infinity, //宽度尽可能大
              minHeight: 50.0, //最小高度为50像素
              maxHeight: 100, //最大100，最小50  在这之间的高度，根据内容自适应高度
            ),
            child: Container(height: 5.0, child: redBox),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.expand(height: 50), //fill parent 充满父
            child: Container(color: Colors.blue, child: Text("test")),
          ),
          //多重限制
          ConstrainedBox(
              constraints: BoxConstraints(minWidth: 90.0, minHeight: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 60.0, minHeight: 60.0),
                child: Container(
                  child: Text("minwidth"),
                  color: Colors.black,
                ),
              )),
          //多重限制
          ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 90.0, maxHeight: 20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 60.0, maxHeight: 60.0),
                child: Container(
                  child: Text("minwidth"),
                  color: Colors.black,
                ),
              )),
          SizedBox(width: 80.0, height: 80.0, child: redBox),
          SizedBox(child: Text("空盒子")),
          ConstrainedBox(
              constraints: BoxConstraints(minWidth: 60.0, minHeight: 100.0), //父
              child: UnconstrainedBox(
                //“去除”父级限制
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 90.0, minHeight: 20.0), //子
                  child: redBox,
                ),
              ))
        ],
      ),
    );
  }
}
