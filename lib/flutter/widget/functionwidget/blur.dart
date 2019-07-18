import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

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
