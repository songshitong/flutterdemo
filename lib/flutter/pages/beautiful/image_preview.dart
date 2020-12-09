import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImagePreviewPage extends StatelessWidget {
  String url1 = "http://pic13.nipic.com/20110409/7119492_114440620000_2.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ImagePreviewPage"),
      ),
      body: Column(
        children: <Widget>[
          ImagePreview(url1),
        ],
      ),
    );
  }
}

///图片预览 参考[photo_view]
///
/// 0 使用的image是外部传进来的，不对image进行loading动画，加载适配等
/// 1 点击放大,进入全屏预览，点击大图，退出
///   放大过程中加入hero动画
/// 2 监听手势，放大/缩小  0.5-1.5    （需要处理 放大或初始状态/放大或移动手势 ，移动时方向）
///    开始时图片是原始状态，左右可以移动，有回弹效果，向下可以全屏移动，结束时dy是向下超过100的就退出(图片下滑退出)
///    开始时图片是放大状态，任意滑动,有回弹效果
/// 3 TODO 图片缓存

const String IMAGE_PREVIEW_TAG = "image_preview_tag";

class ImagePreview extends StatefulWidget {
  String url;

  ImagePreview(this.url);

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
          tag: IMAGE_PREVIEW_TAG,
          child: Image(
            image: NetworkImage(widget.url),
          )),
      onTap: () {
        //进入全屏预览
        Navigator.of(context)
            ?.push(TransparentMaterialPageRoute(builder: (context) {
          return ImageDetail(NetworkImage(widget.url));
        }));
      },
    );
  }
}

class ImageDetail extends StatefulWidget {
  ImageProvider imageProvider;

  ImageDetail(this.imageProvider);

  @override
  _ImageDetailState createState() => _ImageDetailState();
}

///初始状态 缩放/原始大小
enum IniState { SCALE, DEFAULT }

///初始手势 移动/缩放
enum IniGesture { MOVE, SCALE }

///移动时处理，处理方向
enum IniMoveDir { LEFT, RIGHT, DOWN, UP }

///数据类
class StateData {
  static const double iniOpacity = 1.0;
  static const double iniScale = 1.0;
  static const double MAXPADDING = 100;
  double offsetX = 0.0;
  double offsetY = 0.0;
  double startOffsetX = 0.0;
  double startOffsetY = 0.0;
  late Offset lastOffset;
  double backgroundOpacity = iniOpacity;
  double scaleNum = iniScale;

  //图片与屏幕的对比
  double? iniScaleContrasW;
  double? iniScaleContrasH;

  double? scaleContrasW;
  double? scaleContrasH;

  double? firstScaleContrasW;
  double? firstScaleContrasH;

  //图片信息
  double? imgWidth;
  double? imgHeight;
}

//
abstract class HandleIniState {
  BuildContext buildContext;
  StateData stateData = new StateData();

  HandleIniState(ScaleStartDetails details, this.buildContext) {
    print("HandleIniState 初始化================");
    stateData.startOffsetX = details.focalPoint.dx;
    stateData.startOffsetY = details.focalPoint.dy;
  }

  void handleMove(
      ScaleUpdateDetails details, IniMoveDir? moveDir, double dy, double dx);

  void handleScale(ScaleUpdateDetails details);

  void moveEnd();

  void scaleEnd();
}

class HandleIniStateScale extends HandleIniState {
  HandleIniStateScale(
      ScaleStartDetails details, BuildContext buildContext, Offset lastOffset)
      : super(details, buildContext) {
    stateData.lastOffset = lastOffset;
  }

  @override
  handleMove(
      ScaleUpdateDetails details, IniMoveDir? moveDir, double dy, double dx) {
    print("HandleIniStateScale handleMove");
    double computeScreenWidth = stateData.imgWidth! * stateData.scaleContrasW!;
    double computeScreenHeight =
        stateData.imgHeight! * stateData.scaleContrasH!;
    //1 找到图片与屏幕的初始比
    //2 计算缩放后的图片与屏幕比
    //3 图片移动到与屏幕贴合的程度，往一侧的总的移动距离=左侧超出的宽度 （中心缩放时，超出宽度=(ImgWidth-ImgWidth*对比)/2）
    //4 根据图片应该移动的距离，计算手指在屏幕上的移动距离
    print(
        "computeScreenWidth $computeScreenWidth computeScreenHeight $computeScreenHeight stateData.imgWidth ${stateData.imgWidth} stateData.scaleContrasW ${stateData.scaleContrasW} stateData.imgHeight ${stateData.imgHeight} stateData.scaleContrasH ${stateData.scaleContrasH}");
    double diffWidth =
        (computeScreenWidth - MediaQuery.of(buildContext).size.width).abs();
    double diffHeight =
        (computeScreenHeight - MediaQuery.of(buildContext).size.height).abs();
//    print("diffWidth $diffWidth diffHeight $diffHeight");
    double minX = -diffWidth * ((Alignment.center.x - 1).abs() / 2);
    double maxX = diffWidth * ((Alignment.center.x + 1).abs() / 2);

    print(
        "HandleIniStateScale handleMove minX $minX maxX $maxX stateData.scaleNum ${stateData.scaleNum}");
    double maxY = diffHeight * ((Alignment.center.y + 1).abs() / 2);
    double minY = -diffHeight * ((Alignment.center.y - 1).abs() / 2);
//    print("HandleIniStateScale handleMove minY $minY maxY $maxY ");

    //放大状态下，当前的移动距离与上一次叠加, 总的移动固定
    stateData.offsetX = (dx + stateData.lastOffset.dx).clamp(minX, maxX);
    stateData.offsetY = (dy + stateData.lastOffset.dy).clamp(minY, maxY);
    //当图片为长方形，有一侧缩放后没有超过屏幕，不进行移动
    stateData.offsetX =
        computeScreenWidth > MediaQuery.of(buildContext).size.width
            ? stateData.offsetX
            : 0.0;
    stateData.offsetY =
        computeScreenHeight > MediaQuery.of(buildContext).size.height
            ? stateData.offsetY
            : 0.0;

    print(
        "stateData.offsetX ${stateData.offsetX} stateData.offsetY ${stateData.offsetY} lastOffset ${stateData.lastOffset}");
  }

  @override
  handleScale(ScaleUpdateDetails updateDetails) {
    print("HandleIniStateScale handleScale");
    //    缩放
    //变化太快，变为原来的1、40    每次变化与1的差距，除以40
    double orginScale = 1 + (updateDetails.scale - 1) / 40;
    //在上一次的基础上进行缩放
    double target = stateData.scaleNum * orginScale;
    print("target $target");
    //调用onScaleEnd后会调用onScaleUpdate，并且scaleNum回到初始值
    stateData.scaleNum = target.clamp(0.5, 8.0);
    stateData.scaleContrasW = (stateData.scaleContrasW! * orginScale).clamp(
        stateData.firstScaleContrasW! * 0.5,
        stateData.firstScaleContrasW! * 8.0);

    stateData.scaleContrasH = (stateData.scaleContrasH! * orginScale).clamp(
        stateData.firstScaleContrasH! * 0.5,
        stateData.firstScaleContrasH! * 8.0);
    print("scaleContras ${stateData.scaleContrasW}");
  }

  @override
  void moveEnd() {
    print("HandleIniStateScale moveEnd");

    //超出边界一定距离重置
  }

  @override
  void scaleEnd() {
    print("HandleIniStateScale moveEnd");

    if (stateData.scaleNum < 1) {
      stateData.scaleNum = StateData.iniScale;
      stateData.scaleContrasW = stateData.firstScaleContrasW;
      stateData.scaleContrasH = stateData.firstScaleContrasH;
    } else if (stateData.scaleNum > 4) {
      stateData.scaleNum = 4;
      stateData.scaleContrasW = stateData.firstScaleContrasW! * 4;
      stateData.scaleContrasH = stateData.firstScaleContrasH! * 4;
    }
  }
}

class HandleIniStateDefault extends HandleIniState {
  HandleIniStateDefault(ScaleStartDetails details, BuildContext buildContext)
      : super(details, buildContext);
  @override
  handleMove(
      ScaleUpdateDetails details, IniMoveDir? moveDir, double dy, double dx) {
    print("HandleIniStateDefault handleMove moveDir $moveDir");
    if (moveDir == IniMoveDir.DOWN) {
      //移动   移动监听是缩放监听的子集，1.0是移动，其他是缩放
      if (dy > 0) {
        //只有在初始向下，移动向下的同时变化背景和大小
        stateData.backgroundOpacity =
            (1 - dy.abs() / (MediaQuery.of(buildContext).size.height / 2))
                .clamp(0.2, 1.0);
        //放大状态的图片，下滑不进行缩小
        stateData.scaleNum = 1 - (1 - stateData.backgroundOpacity) / 2;
      }
      stateData.offsetX = dx;
      stateData.offsetY = dy;
    } else if (moveDir == IniMoveDir.LEFT || moveDir == IniMoveDir.RIGHT) {
      print("HandleIniStateDefault handleMove =============");
      stateData.offsetX = dx.clamp(-StateData.MAXPADDING, StateData.MAXPADDING);
      stateData.offsetY = dy.clamp(-StateData.MAXPADDING, StateData.MAXPADDING);
    }
  }

  @override
  handleScale(ScaleUpdateDetails updateDetails) {
    print("HandleIniStateDefault handleScale");

//    缩放
    //变化太快，变为原来的1、40    每次变化与1的差距，除以40
    double orginScale = 1 + (updateDetails.scale - 1) / 40;
    //在上一次的基础上进行缩放
    double target = stateData.scaleNum * orginScale;
    print("target $target");
    //调用onScaleEnd后会调用onScaleUpdate，并且scaleNum回到初始值
    stateData.scaleNum = target.clamp(0.5, 8.0);
    stateData.scaleContrasW = (stateData.scaleContrasW! * orginScale).clamp(
        stateData.firstScaleContrasW! * 0.5,
        stateData.firstScaleContrasW! * 8.0);

    stateData.scaleContrasH = (stateData.scaleContrasH! * orginScale).clamp(
        stateData.firstScaleContrasH! * 0.5,
        stateData.firstScaleContrasH! * 8.0);
    print(
        "scaleContrasW ${stateData.scaleContrasW}  scaleContrasH ${stateData.scaleContrasH}");
  }

  @override
  void moveEnd() {
    print("HandleIniStateDefault moveEnd");

    if (stateData.offsetY > 100) {
      Navigator.of(buildContext)?.pop();
      return;
    }
    //移动结束，重置状态
    stateData.offsetX = 0;
    stateData.offsetY = 0;
    stateData.backgroundOpacity = StateData.iniOpacity;
    stateData.scaleNum = StateData.iniScale;
    stateData.scaleContrasH = stateData.firstScaleContrasH;
    stateData.scaleContrasW = stateData.firstScaleContrasW;

    print("scaleContras ${stateData.scaleContrasW}");
  }

  @override
  void scaleEnd() {
    print("HandleIniStateDefault scaleEnd");
    if (stateData.scaleNum < 1) {
      stateData.scaleNum = StateData.iniScale;
      stateData.scaleContrasW = stateData.firstScaleContrasW;
      stateData.scaleContrasH = stateData.firstScaleContrasH;
    } else if (stateData.scaleNum > 4) {
      stateData.scaleNum = 4;
      stateData.scaleContrasW = stateData.firstScaleContrasW! * 4;
      stateData.scaleContrasH = stateData.firstScaleContrasH! * 4;
    }
    print(
        "stateData.scaleContrasW ${stateData.scaleContrasW} stateData.scaleContrasH ${stateData.scaleContrasH} ");
  }
}

class _ImageDetailState extends State<ImageDetail> {
  static const double iniOpacity = 1.0;
  static const double iniScale = 1.0;

  double scaleNum = iniScale;
  double offsetX = 0.0;
  double offsetY = 0.0;
  double backgroundOpacity = iniOpacity;

  late HandleIniState handleIniState;
  IniMoveDir? iniMoveDir;
  bool isMove = false;

  //图片大小与屏幕的对比
  double? iniScaleContrasW;
  double? iniScaleContrasH;

  double? scaleContrasW;
  double? scaleContrasH;

  double? firstScaleContrasW;
  double? firstScaleContrasH;

  double? imgWidth;
  double? imgHeight;
  @override
  void initState() {
    //全屏模式，隐藏状态栏，底部导航
//    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(Duration duration) {
    _getImageInfo();
  }

  @override
  void dispose() {
    super.dispose();
    //还原屏幕
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Colors.black.withOpacity(backgroundOpacity)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)?.pop();
        },
        onScaleStart: (startDetails) {
          if (scaleNum != 1) {
            handleIniState = new HandleIniStateScale(
                startDetails, context, Offset(offsetX, offsetY));
            //初始化上一次缩放的scaleNum
            handleIniState.stateData.scaleNum = scaleNum;
            handleIniState.stateData.iniScaleContrasW = iniScaleContrasW;
            handleIniState.stateData.iniScaleContrasH = iniScaleContrasH;

            handleIniState.stateData.scaleContrasW = iniScaleContrasW;
            handleIniState.stateData.scaleContrasH = iniScaleContrasH;

            handleIniState.stateData.imgWidth = imgWidth;
            handleIniState.stateData.imgHeight = imgHeight;
            handleIniState.stateData.firstScaleContrasW = firstScaleContrasW;
            handleIniState.stateData.firstScaleContrasH = firstScaleContrasH;

            print(
                "onScaleStart scaleNum $scaleNum iniScaleContrasW $iniScaleContrasW iniScaleContrasH $iniScaleContrasH imgWidth $imgWidth imgHeight $imgHeight");
          } else {
            handleIniState = new HandleIniStateDefault(startDetails, context);
            handleIniState.stateData.iniScaleContrasW = iniScaleContrasW;
            handleIniState.stateData.iniScaleContrasH = iniScaleContrasH;

            handleIniState.stateData.scaleContrasW = iniScaleContrasW;
            handleIniState.stateData.scaleContrasH = iniScaleContrasH;

            handleIniState.stateData.firstScaleContrasW = firstScaleContrasW;
            handleIniState.stateData.firstScaleContrasH = firstScaleContrasH;
          }
        },
        onScaleUpdate: (updateDetails) {
          print(
              "focalPoint.dy ${updateDetails.focalPoint.dy} focalPoint.dx ${updateDetails.focalPoint.dx}");
          double dy = updateDetails.focalPoint.dy -
              handleIniState.stateData.startOffsetY;
          double dx = updateDetails.focalPoint.dx -
              handleIniState.stateData.startOffsetX;
          print("before updateDetails ${updateDetails.scale} dx $dx dy $dy");
          //确定初始方向
          if (handleIniState.stateData.offsetX == 0 &&
              handleIniState.stateData.offsetY == 0) {
            if (dy > 0 && dy.abs() > dx.abs()) {
              iniMoveDir = IniMoveDir.DOWN;
            } else if (dx > 0 && dx.abs() > dy.abs()) {
              iniMoveDir = IniMoveDir.RIGHT;
            } else if (dx < 0 && dx.abs() > dy.abs()) {
              iniMoveDir = IniMoveDir.LEFT;
            } else {
              iniMoveDir = IniMoveDir.UP;
            }
          }
          print("scaleNum $scaleNum");
          if (updateDetails.scale == 1.0) {
            //scale 不变，位移变
            isMove = true;
            handleIniState.handleMove(updateDetails, iniMoveDir, dy, dx);
          } else if (updateDetails.scale != 1.0) {
            //scale改变
            isMove = false;
            handleIniState.handleScale(updateDetails);
          } else {
            isMove = false; //不看做move
            //end后再次调用update
            return null;
          }
          setState(() {
            changeState();
          });
        },
        onScaleEnd: (endDetails) {
          print("更新结束状态======== onScaleEnd scale $scaleNum isMove $isMove");
          setState(() {
            if (isMove) {
              handleIniState.moveEnd();
            } else {
              handleIniState.scaleEnd();
            }
            changeState();
          });
        },
        child: Hero(
          tag: IMAGE_PREVIEW_TAG,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(offsetX, offsetY)
              ..scale(scaleNum),
            child: SizedBox(
                child: Image(
              image: widget.imageProvider,
            )),
          ),
        ),
      ),
    );
  }

  void changeState() {
    print("changeState ====== scaleNum ${handleIniState.stateData.scaleNum}");
    scaleNum = handleIniState.stateData.scaleNum;
    offsetY = handleIniState.stateData.offsetY;
    offsetX = handleIniState.stateData.offsetX;
    print("changeState offsetY $offsetY offsetX $offsetX ");

    backgroundOpacity = handleIniState.stateData.backgroundOpacity;
    iniScaleContrasW = handleIniState.stateData.scaleContrasW;
    iniScaleContrasH = handleIniState.stateData.scaleContrasH;

    print(
        "changeState iniScaleContras $iniScaleContrasW iniScaleContrasH $iniScaleContrasH");
  }

  Future<ImageInfo> _getImageInfo() {
    final Completer completer = Completer<ImageInfo>();
    final ImageStream stream =
        widget.imageProvider.resolve(const ImageConfiguration());
    final listener =
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (!completer.isCompleted) {
        completer.complete(info);
        if (mounted) {
          imgWidth = info.image.width.toDouble();
          imgHeight = info.image.height.toDouble();
          var size = Size(imgWidth!, imgHeight!);
          print("_getImageInfo size $size");
          print(
              "scrennwidth ${MediaQuery.of(context).size.width} screenHeight ${MediaQuery.of(context).size.height}");
          //图片与屏幕的对比取，宽和高比的最大值
          firstScaleContrasW = MediaQuery.of(context).size.width / imgWidth!;
          firstScaleContrasH = MediaQuery.of(context).size.height / imgHeight!;
          iniScaleContrasW = firstScaleContrasW;
          iniScaleContrasH = firstScaleContrasH;
        }
      }
    });
    stream.addListener(listener);
    completer.future.then((_) {
      stream.removeListener(listener);
    });
    return completer.future as Future<ImageInfo>;
  }
}

class TransparentMaterialPageRoute extends PageRoute {
  WidgetBuilder? builder;
  @override
  // 不遮挡前一页
  bool get opaque => false;
  TransparentMaterialPageRoute({this.builder});

  @override
  Color get barrierColor => null!;

  @override
  String get barrierLabel => null!;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget result = builder!(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return theme.buildTransitions(
        this, context, animation, secondaryAnimation, child);
//    return CupertinoPageTransition(
//      primaryRouteAnimation: animation,
//      secondaryRouteAnimation: secondaryAnimation,
//      child: child,
//      linearTransition: true,
//    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
