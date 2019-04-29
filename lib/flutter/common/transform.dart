import 'package:flutter/widgets.dart';

class TransformUtil {
  //应用带透视效果的围绕x轴的旋转  perspective越大，物体距离人眼越近，近大远小，靠近人眼的部分也越大
  static Matrix4 perspectiveRotateX(double angle, {double perspective = 0.001}) {
    return Matrix4.identity()
      ..setEntry(3, 2, perspective)
      ..rotateX(angle);
  }
}
