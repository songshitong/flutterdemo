import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

class ImagePage extends StatefulWidget {
  static const url =
      "https://img.alicdn.com/imgextra/i2/2053469401/O1CN01HnPAtY2JJhyZa3MFe_!!2053469401.jpg";

  ImagePage();

  @override
  _ImagePageState createState() => _ImagePageState();

  static Future<ui.Image> getImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
//    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
//    ui.FrameInfo fi = await codec.getNextFrame();
    var image;
//      image = fi.image;
//    ui.decodeImageFromList(data.buffer.asUint8List(), (image) {
//      //对instantiateImageCodec和getNextFrame的包装
//    });
    //image decoder 对instantiateImageCodec和getNextFrame的包装
    print(" getImage ${data.buffer.asUint8List()}");
    // 和Image.memory走相同的流程，然后解析失败？？ 能有和引擎一起debug，需要设置图片格式ImageByteFormat.png
    image = await decodeImageFromList(data.buffer.asUint8List());

    //包装与不包装的区别
    // 包装直接拿到ui.Iamge,其中gif只包含第一帧的信息，通过Image.memory图片加载需要转码
    // 不包装可以拿到ui.FrameInfo，通过RawIamge加载，不用转码
    return image;
  }
}

class _ImagePageState extends State<ImagePage> {
  Uint8List imgList;
  @override
  void initState() {
    super.initState();
    rootBundle.load(MyImgs.JINX).then((data) {
      setState(() {
        imgList = data.buffer.asUint8List();
        print("initState imgList $imgList");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var dpFactor = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      appBar: AppBar(
        title: Text('image'),
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              ImagePage.getImage(MyImgs.SANTAIZI).then((image) async {
                //TODO 图片格式 RawImage
                //
                image.toByteData(format: ImageByteFormat.png).then((byteData) {
                  imgList = byteData.buffer.asUint8List(
                      byteData.offsetInBytes, byteData.lengthInBytes);
                  print("after getImage imgList $imgList");
                  setState(() {});
                });
              }).catchError((e) {
                print("getImage error ${e.toString()}");
              });
            },
            child: Text("测试getImage"),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: imgList != null
                  ? Image.memory(imgList, gaplessPlayback: true)
                  : Container(),
            ),
            Image.asset(MyImgs.SANTAIZI),
            Image.network(ImagePage.url),
            Image.asset(
              MyImgs.TEST,
              height:
                  100, //width、height：用于设置图片的宽、高，当不指定宽高时，图片会根据当前父容器的限制，尽可能的显示其原始大小，如果只设置width、height的其中一个，那么另一个属性默认会按比例缩放，但可以通过下面介绍的fit属性来指定适应规则
            ),
            Image.asset(
              MyImgs.TEST,
              width: 150,
              height: 150,

              ///查看[paintImage] boxFit的默认行为
              ///* `fit`: How the image should be inscribed into `rect`. If null, the
              ///    default behavior depends on `centerSlice`. If `centerSlice` is also null,
              ///    the default behavior is [BoxFit.scaleDown]. If `centerSlice` is
              ///    non-null, the default behavior is [BoxFit.fill]. See [BoxFit] for
              ///    details.
              ///
              //fill：会拉伸填充满显示空间，图片本身长宽比会发生变化，图片会变形。
              //cover：会按图片的长宽比放大后居中填满显示空间，图片不会变形，超出显示空间部分会被剪裁。
//              contain：图片会在保证图片本身长宽比不变的情况下缩放以适应当前显示空间，图片不会变形
//              fitWidth：图片的宽度会缩放到显示空间的宽度，高度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁
//              fitHeight：图片的高度会缩放到显示空间的高度，宽度会按比例缩放，然后居中显示，图片不会变形，超出显示空间部分会被剪裁
//              none：图片没有适应策略，会在显示空间内显示图片，如果图片比显示空间大，则显示空间只会显示图片中间部分
              fit: BoxFit.fill,
              //当image provider更改时，是继续显示旧图像（true）还是简单地显示任何内容(false) 当图片改变时，直到读到新图片的流才会改变
              //在这之前一直显示旧图片，可以减少图片切换时的闪烁白屏
              gaplessPlayback: true,
              //scale 是由image provider的各个子类实现的，默认是1.0，Image.asset会根据scale分为ExactAssetImage和AssetImage
              scale: 1.0,
            ),
            Image.asset(
              MyImgs.TEST, height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode
                  .difference, //在图片绘制时可以对每一个像素进行颜色混合处理，color指定混合色，而colorBlendMode指定混合模式
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.color,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.clear,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.colorBurn,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.colorDodge,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.darken,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dst,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstATop,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstIn,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstOut,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.dstOver,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.exclusion,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.hardLight,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.hue,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.lighten,
            ),
            Image.asset(
              MyImgs.TEST,
              color: Colors.blue,
              height: 50,
              colorBlendMode: BlendMode.luminosity,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.modulate,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.multiply,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.overlay,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.plus,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.saturation,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.screen,
            ),
            Image.asset(
              MyImgs.TEST,
              color: Colors.blue,
              height: 50,
              colorBlendMode: BlendMode.softLight,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.src,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.srcATop,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.srcIn,
            ),
            Image.asset(
              MyImgs.TEST,
              color: Colors.blue,
              height: 50,
              colorBlendMode: BlendMode.srcOut,
            ),
            Image.asset(
              MyImgs.TEST,
              height: 50,
              color: Colors.blue,
              colorBlendMode: BlendMode.srcOver,
            ),
            Image.asset(
              MyImgs.TEST,
              color: Colors.blue,
              colorBlendMode: BlendMode.xor,
              height: 50,
            ),
            Text("jinx 259*194 BoxFit.cover  container 259*100"),
            Image.asset(
              MyImgs.JINX,
              width: 259 / dpFactor,
              height: 100 / dpFactor,
              fit: BoxFit.cover,
            ),
            Text("jinx 259*194 BoxFit.cover  container 100*100"),
            Image.asset(
              MyImgs.JINX,
              width: 100 / dpFactor,
              height: 100 / dpFactor,
              fit: BoxFit.cover,
            ),
            Text("jinx 259*194 BoxFit.cover  container 100*194"),
            Image.asset(
              MyImgs.JINX,
              width: 100 / dpFactor,
              height: 194 / dpFactor,
              fit: BoxFit.cover,
            ),
            Text("jinx 259*194 BoxFit.cover  container 300*300"),
            Image.asset(
              MyImgs.JINX,
              width: 300 / dpFactor,
              height: 300 / dpFactor,
              fit: BoxFit.cover,
            ),
            Text("jinx 259*194 default BoxFit.cover  container 300*300"),
            Image.asset(
              MyImgs.JINX,
              width: 300 / dpFactor,
              height: 300 / dpFactor,
            )
          ], //加载本地图片
        ),
      ),
    );
  }

  ///TODO 获取图片信息，createLocalImageConfiguration、precacheImage预缓存
//  Future<ImageInfo> _getImage() {
//    final Completer completer = Completer<ImageInfo>();
//    final ImageStream stream =
//    widget.imageProvider.resolve(const ImageConfiguration());
//    final listener =
//    ImageStreamListener((ImageInfo info, bool synchronousCall) {
//      if (!completer.isCompleted) {
//        completer.complete(info);
//        if (mounted) {
//          setState(() {
//            _childSize =
//                Size(info.image.width.toDouble(), info.image.height.toDouble());
//            _loading = false;
//          });
//        }
//      }
//    });
//    stream.addListener(listener);
//    completer.future.then((_) {
//      stream.removeListener(listener);
//    });
//    return completer.future;
//  }

  /// 获取图片某一像素点的颜色  代码来自https://github.com/HitenDev/flutter_effects pixel_utils.dart
  /// palette_generator插件
  Color getColorByPixel(ByteData byteData, Size size, Offset pixel) {
    //rawRgba
    assert(byteData.lengthInBytes == size.width * size.height * 4);
    assert(pixel.dx < size.width && pixel.dy < size.height);
//    找到像素 pixel 的点  *4 4字节？？
    int index = ((pixel.dy * size.width + pixel.dx) * 4).toInt();
    int r = byteData.getUint8(index);
    int g = byteData.getUint8(index + 1);
    int b = byteData.getUint8(index + 2);
    int a = byteData.getUint8(index + 3);
    return Color.fromARGB(a, r, g, b);
  }
}
