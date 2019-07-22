import 'package:flutter/material.dart';

///测试 draggable
///draggable 一个可以拖动到[DragTarget]的widget
///DragTarget 接受来自[Draggable]数据的widget，时机在draggable拖动到dragTarget上面时
///
/// 两个泛型必须声明且一致，否则[DragTarget]接收不到data,同时[DragTarget]的builder的List<T> candidateData也必须给泛型
class DraggablePage extends StatefulWidget {
  @override
  _DraggablePageState createState() => _DraggablePageState();
}

class _DraggablePageState extends State<DraggablePage> {
  var data = "data from Draggable";

  var targetData = "DragTarget";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draggable Page"),
      ),
      body: Column(
        children: <Widget>[
          Draggable<String>(
            //拖动的方向，横轴/纵轴，null两个方向都可以
            axis: null,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(color: Colors.amber),
              child: Text("darggable child data is  $data"),
            ),
            //当拖动正在进行时，在指针下显示的widget, 拖动的widget为feedback
            feedback: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(color: Colors.green),
              child: Text("draggable feedback", style: TextStyle(inherit: false)),
            ),
            data: data,
            //拖动时，代替child，停留在原地展示的widget，可选，默认展示child
            childWhenDragging: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(color: Colors.purple),
              child: Text("childWhenDragging"),
            ),
            onDragStarted: () {
              print("onDragStarted");
            },
            onDragCompleted: () {
              print("onDragCompleted");
            },
            onDragEnd: (draggleDetails) {
              print(
                  "onDragEnd draggleDetails   wasAccepted ${draggleDetails.wasAccepted} velocity ${draggleDetails.velocity} offset ${draggleDetails.offset}");
            },
            onDraggableCanceled: (velocity, offset) {
              print("onDraggableCanceled velocity $velocity  offset $offset");
            },
          ),
          DragTarget<String>(
              //在drag结束时触发
              onAccept: (data) {
            print("onAccept $data");
            setState(() {
              targetData = data;
            });
          }, onLeave: (data) {
            print("onLeave $data");
          }, //标记data是否被DragTarget接收
              onWillAccept: (data) {
            print("onWillAccept $data");
            return true;
          }, builder: (context, List<String> candidateData, rejectedData) {
            print("builder candidateData $candidateData rejectedData $rejectedData");
            return Container(
                width: 150, height: 150, decoration: BoxDecoration(color: Colors.red), child: Text(targetData));
          })
        ],
      ),
    );
  }
}
