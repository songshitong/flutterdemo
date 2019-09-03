import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

///不用[ClipRect]包裹，默认全屏模糊    实现方式context.pushLayer(BackdropFilterLayer(filter: _filter), super.paint, offset)
///用ClipRect包裹后，只对子大小的区域裁剪
///
/// 子是container 设置背景为透明，防止产生影响
/// Container(
///                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
///                  width: 200.0,
///                  height: MediaQuery.of(context).size.height,
///                ),
class BlurPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("blur page"),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            MyImgs.JINX,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.contain,
          ),
          Center(
            child: ClipRect(
              // <-- clips to the 200x200 [Container] below
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5.0,
                  sigmaY: 5.0,
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 200.0,
                  height: 200.0,
                  child: Text('Hello World'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
