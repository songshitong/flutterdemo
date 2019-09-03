import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

class SwitchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SwitchPage"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //目前不能定制大小
        children: <Widget>[
          Switch(
            value: true,
            onChanged: (choice) {},
            activeTrackColor: Colors.green, //激活轨道颜色
            inactiveThumbColor: Colors.black, //关闭滑块颜色
            activeThumbImage: AssetImage(MyImgs.TEST), //激活滑块图片
          )
        ],
      ),
    );
  }
}
