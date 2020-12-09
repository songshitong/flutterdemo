library gif_ani;

import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

import 'gif/gif_decode.dart';

///todo  学习大佬解码图片的操作
class GifTestPage extends StatefulWidget {
  @override
  _GifTestPageState createState() => _GifTestPageState();
}

class DeocdeParam {
  SendPort sp;
  ByteData value;
  DeocdeParam(this.sp, this.value);
}

void decode(DeocdeParam deocdeParam) {
  final value = deocdeParam.value;
  //imgLists是10进制
  var imgLists = value.buffer
      .asUint8List(value.offsetInBytes, value.lengthInBytes) /*.cast<int>()*/;
//  print("imgLists $imgLists");
  var gifDecoder = CustomDecodeGif(imgLists);
  List<int> gifBytes = gifDecoder.decodeFirstFrame();
//  print("gifBytes $gifBytes");
//  var encodeBytes = OImage.decodeGif(imgLists);
//  print("encodeBytes ${encodeBytes.getBytes()}");
//  var bytes = OImage.encodeGif(encodeBytes);
  deocdeParam.sp.send(gifBytes);
}

class _GifTestPageState extends State<GifTestPage>
    with SingleTickerProviderStateMixin {
  bool isRefreshFrame = false;
  Uint8List? imgBytes;
  Uint8List? sourceBytes;
  @override
  void initState() {
    super.initState();
    print("start load   ${DateTime.now().millisecondsSinceEpoch}");
    rootBundle.load(MyImgs.SANTAIZI).then((value) {
      sourceBytes =
          value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes);
      print("end load   ${DateTime.now().millisecondsSinceEpoch}");
      print("load value $value");
      var decodeStart = DateTime.now().millisecondsSinceEpoch;
      print("start decodegif  $decodeStart");
//      getImgBytesAsync(value).then((bytes) {
//        setState(() {
//          imgBytes = bytes;
//          var decodeEnd = DateTime.now().millisecondsSinceEpoch;
//          print("end decodegif  $decodeEnd   time ${decodeEnd - decodeStart}");
//          //解码第一帧大约两到三秒
////          print("imgBytes $imgBytes");
//        });
//      });
      var gifDecoder = CustomDecodeGif(
          value.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes));
      setState(() {
        var start = DateTime.now().millisecondsSinceEpoch;
        imgBytes = gifDecoder.decodeFirstFrame() as Uint8List?;
        print(
            "main thread time  ${DateTime.now().millisecondsSinceEpoch - start}");
      });
    });
  }

  Future getImgBytesAsync(ByteData value) async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(decode, DeocdeParam(receivePort.sendPort, value));
    // Get the processed image from the isolate.
    return await receivePort.first;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GifTestPage"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildImage(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      isRefreshFrame = true;
                    });
                  },
                  child: Text("开始GIF动画")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      isRefreshFrame = false;
                    });
                  },
                  child: Text("结束GIF动画")),
            )
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    if (null == imgBytes) {
      return Container();
    } else {
      return GestureDetector(
        child: Image.memory(imgBytes!, gaplessPlayback: true),
        onLongPress: () {
          setState(() {
            imgBytes = sourceBytes;
          });
        },
      );
    }
  }

  Image buildNativeGif() {
    return new Image(
//      frameBuilder: (context, widget, frame, wasSynchronouslyLoaded) {
//        print("frame $frame");
//        return Image(
//          image: AssetImage(MyImgs.EARRINGS),
//        );
//      },
      image: new AssetImage(MyImgs.LIKEGIF),
    );
  }

  Widget buildTestGif() {
    return GifAnimation(
      image: AssetImage(MyImgs.LIKEGIF),
      refreshFrame: isRefreshFrame,
    );
  }
}

class GifAnimation extends StatefulWidget {
  GifAnimation(
      {required this.image,
      this.semanticLabel,
      this.excludeFromSemantics = false,
      this.width,
      this.height,
      this.color,
      this.colorBlendMode,
      this.fit,
      this.alignment = Alignment.center,
      this.repeat = ImageRepeat.noRepeat,
      this.centerSlice,
      this.matchTextDirection = false,
      this.gaplessPlayback = false,
      this.scale = 1.0,
      this.refreshFrame = false});
  final ImageProvider image;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxFit? fit;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final double scale;
  final bool refreshFrame;
  @override
  State<StatefulWidget> createState() {
    return new _AnimatedImageState();
  }
}

class _AnimatedImageState extends State<GifAnimation>
    with WidgetsBindingObserver {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  bool _isListeningToStream = false;
  late bool _invertColors;
  int frameNum = 0;
  late ImageStreamListener _imageStreamListener;

  @override
  void initState() {
    super.initState();
    _imageStreamListener = ImageStreamListener(
      _handleImageFrame,
    );
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    assert(_imageStream != null);
    WidgetsBinding.instance?.removeObserver(this);
    _stopListeningToStream();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _updateInvertColors();
    _resolveImage();

    if (TickerMode.of(context))
      _listenToStream();
    else
      _stopListeningToStream();

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(GifAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isListeningToStream) {
      _imageStream!.addListener(_imageStreamListener);
    }
    if (widget.image != oldWidget.image) _resolveImage();
  }

  @override
  void didChangeAccessibilityFeatures() {
    super.didChangeAccessibilityFeatures();
    setState(() {
      _updateInvertColors();
    });
  }

  @override
  void reassemble() {
    _resolveImage(); // in case the image cache was flushed
    super.reassemble();
  }

  void _updateInvertColors() {
    _invertColors = MediaQuery.of(context).invertColors;
  }

  void _resolveImage() {
    if (frameNum > 0 && widget.refreshFrame) {
      print("_resolveImage 11");
      _startResolveImage();
    } else if (frameNum == 0) {
      print("_resolveImage 22");
      _startResolveImage();
    }
  }

  void _startResolveImage() {
    final ImageStream newStream =
        widget.image.resolve(createLocalImageConfiguration(
      context,
      size: widget.width != null && widget.height != null
          ? Size(widget.width!, widget.height!)
          : null!,
    ));
    assert(newStream != null);
    _updateSourceStream(newStream);
  }

  void _handleImageFrame(ImageInfo imageInfo, bool synchronousCall) {
    if (!mounted) {
      return;
    }
    frameNum++;
    if (frameNum > 1 && widget.refreshFrame) {
      setState(() {
        _imageInfo = imageInfo;
      });
    } else if (frameNum == 1) {
      //第一帧加载
      setState(() {
        _imageInfo = imageInfo;
      });
    } else {
      //当不播放GIF动画时，移除监听防止一直读取监听
      _imageStream!.removeListener(_imageStreamListener);
    }
  }

  // Updates _imageStream to newStream, and moves the stream listener
  // registration from the old stream to the new stream (if a listener was
  // registered).
  void _updateSourceStream(ImageStream newStream) {
    if (_imageStream?.key == newStream.key) return;

    if (_isListeningToStream) {
      _imageStream!.removeListener(_imageStreamListener);
    }

    if (!widget.gaplessPlayback)
      setState(() {
        _imageInfo = null;
      });

    _imageStream = newStream;
    if (_isListeningToStream) _imageStream!.addListener(_imageStreamListener);
  }

  void _listenToStream() {
    if (_isListeningToStream) return;
    _imageStream!.addListener(_imageStreamListener);
    _isListeningToStream = true;
  }

  void _stopListeningToStream() {
    print("_stopListeningToStream  _isListeningToStream $_isListeningToStream");
    if (!_isListeningToStream) return;
    _imageStream!.removeListener(_imageStreamListener);
    _imageStream!.completer!.removeListener(_imageStreamListener);
    _isListeningToStream = false;
  }

  @override
  Widget build(BuildContext context) {
    final RawImage image = new RawImage(
      image: _imageInfo?.image,
      width: widget.width!,
      height: widget.height!,
      scale: widget.scale,
      color: widget.color!,
      colorBlendMode: widget.colorBlendMode!,
      fit: widget.fit!,
      alignment: widget.alignment,
      repeat: widget.repeat,
      centerSlice: widget.centerSlice!,
      invertColors: _invertColors,
      matchTextDirection: widget.matchTextDirection,
    );
    if (widget.excludeFromSemantics) return image;
    return new Semantics(
      container: widget.semanticLabel != null,
      image: true,
      label: widget.semanticLabel == null ? '' : widget.semanticLabel!,
      child: image,
    );
  }
}
