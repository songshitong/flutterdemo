import 'package:flutter/material.dart';

class ImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              "lib/img/test.jpg",
              height:
                  100, //width、height：用于设置图片的宽、高，当不指定宽高时，图片会根据当前父容器的限制，尽可能的显示其原始大小，如果只设置width、height的其中一个，那么另一个属性默认会按比例缩放，但可以通过下面介绍的fit属性来指定适应规则
            ),
            Image.asset(
              "lib/img/test.jpg",
              width: 150,
              height: 150,
              //fill：会拉伸填充满显示空间，图片本身长宽比会发生变化，图片会变形。
              //cover：会按图片的长宽比放大后居中填满显示空间，图片不会变形，超出显示空间部分会被剪裁。
//              contain：这是图片的默认适应规则，图片会在保证图片本身长宽比不变的情况下缩放以适应当前显示空间，图片不会变形
//              fitWidth：图片的宽度会缩放到显示空间的宽度，高度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁
//              fitHeight：图片的高度会缩放到显示空间的高度，宽度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁
//              none：图片没有适应策略，会在显示空间内显示图片，如果图片比显示空间大，则显示空间只会显示图片中间部分
              fit: BoxFit.fill,
            ),
            Image.asset(
              "lib/img/test.jpg", height: 50,
              color: Colors.blue,
              colorBlendMode:
                  BlendMode.difference, //在图片绘制时可以对每一个像素进行颜色混合处理，color指定混合色，而colorBlendMode指定混合模式
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.color,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.clear,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.colorBurn,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.colorDodge,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.darken,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dst,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstATop,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstIn,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstOut,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstOver,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.exclusion,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.hardLight,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.hue,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.lighten,
            ),
            Image.asset(
              "lib/img/test.jpg",
              color: Colors.blue,
              height: 50,
              colorBlendMode: BlendMode.luminosity,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.modulate,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.multiply,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.overlay,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.plus,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.saturation,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.screen,
            ),
            Image.asset(
              "lib/img/test.jpg",
              color: Colors.blue,
              height: 50,
              colorBlendMode: BlendMode.softLight,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.src,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.srcATop,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.srcIn,
            ),
            Image.asset(
              "lib/img/test.jpg",
              color: Colors.blue,
              height: 50,
              colorBlendMode: BlendMode.srcOut,
            ),
            Image.asset(
              "lib/img/test.jpg",
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.srcOver,
            ),
            Image.asset(
              "lib/img/test.jpg",
              color: Colors.blue,
              colorBlendMode: BlendMode.xor,
              height: 50,
            ),
          ], //加载本地图片
        ),
      ),
    );
  }
}
