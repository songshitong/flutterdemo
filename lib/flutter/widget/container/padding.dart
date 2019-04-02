import 'package:flutter/material.dart';

class PaddingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    Padding可以给其子节点添加补白（填充
    return Scaffold(
      appBar: AppBar(title: Text("padding")),
      body: Column(
        children: <Widget>[
          ///可选
          Padding(
            padding: EdgeInsets.only(top: 100, left: 50),
            child: Text("测试padding1"),
          ),

          ///全部
          Padding(
            padding: EdgeInsets.all(100),
            child: Text("测试padding2"),
          ),
          //左上右下
          Padding(
            padding: EdgeInsets.fromLTRB(100, 100, 100, 100),
            child: Text("测试padding3"),
          ),
          //上下 -- 左右
          Padding(
            padding: EdgeInsets.symmetric(vertical: 100, horizontal: 100),
            child: Text("测试padding4"),
          )
        ],
      ),
    );
  }
}
