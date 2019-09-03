import 'package:flutter/material.dart';

//todo mediaquery  获取size    window.physicalSize.width / window.devicePixelRatio;不可靠，release mode可能获取不到
// todo IntrinsicHeight
//todo 自定义scrollview  listview(横竖布局)
//todo StatefulBuilder  Builder
//todo align
//todo  Material  制作material风格控件，使用主题，查看RaisedBtn  scaffold常用widget  material和sacafflod会将常用属性以inherit widget初始化到widget tree
//buildcontext可从key获得     buildcontext 不能是pop的会报unsafe,

//Navigator operation requested with a context that does not include a Navigator
//It happens because you used a context that doesn't contain a Navigator instance as parent      发生在使用的context的父widget没有包含navigator
// But this error can still happens when you use a context that is a parent of MaterialApp/WidgetApp  不能使用MaterialApp/WidgetApp的上下文
//Navigator.of 的源码    所使用的context不能是顶层Widget的context，同时顶层Widget必须是StatefulWidget

/// clip系列
/// PageStorage
/// 自定义overlay
/// static show(BuildContext context, String msg) {
//    var overlayState = Overlay.of(context);
//    OverlayEntry overlayEntry;
//    overlayEntry = new OverlayEntry(builder: (context) {
//      return buildToastLayout(msg);
//    });
//    overlayState.insert(overlayEntry);
//  }

//todo Visibility 替代，动画，原理

//todo widgets.puml的State 注释完善

//StadiumBorder    BeveledRectangleBorder todo 各种border的使用
//RelativeRect
//AnimatedSize
//ScopedModelDescendant

///获取大小   context.findeRenderObject也可以，但要在绘制完成
///globle.currentcontext.size
///widgetKey.currentContext.findRenderObject().semanticBounds.size
///widgetKey.currentContext.findRenderObject().paintBounds.size
///
///  获取全局的坐标  为什么可以强转为Renderbox   Renderbox定义了坐标体系
///  RenderBox box = widgetKey.currentContext.findRenderObject();
//    Offset offset = box.localToGlobal(Offset.zero);
//    Size size = box.size;

///     监听绘制后    此时大小仍然在layout阶段确定
///     WidgetsBinding.instance.addPostFrameCallback(_afterLayout);   WidgetsBinding  widget和flutter engine之间的胶水
///
/// app的生命周期监听   class _AppLifecycleReactorState extends State<AppLifecycleReactor> with WidgetsBindingObserver
///
///
/// 文字动画实现可以用Matrix4和Vector3，比较高级（这个在TabBar用上了）
///
/// todo 线性插值
///
///todo layoutbuilder  实现根据constrains动态子布局，父固定-》constarins固定/充满屏-》类似gallery的多个产品
///todo PreferredSize
///
/// mediaquery.of(contexy) 不能再inistate之前调用，可以监听addPostFrameCallback第一帧
/// final MediaQueryData mediaQueryData = MediaQuery.of(context);
//    final double statusBarHeight = mediaQueryData.padding.top;
//    final double screenHeight = mediaQueryData.size.height;
//    final double appBarMaxHeight = screenHeight - statusBarHeight;

//各种theme

// function 是const吗  一个const构造器，接受一个function     class外面的是function，里面的是method???
//pageview  快速回弹效果 PageScrollPhysics
//ValueNotifier 各种listener
//WidgetsBinding.instance.window.devicePixelRatio

//SynchronousFuture
//Completer
//Opacity
//AspectRatio
//Texture

//Zone 类使用  ImageProvider.resolve 方法，根据image配置读取image
//rootBundle    ByteData   Uint8List   ByteData.buffer.asUint8List()   String.fromCharCode(e.codeUnitAt(0) & 0xff)
//ByteData.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes).cast<int>()
//Uint8List.view

//TextTheme 字体主题之类的系统资源
//查看foundation  import 'package:flutter/foundation.dart' as foundation;     foundation.defaultTargetPlatform

//全屏 SystemChrome.setEnabledSystemUIOverlays([]) services层
//Table table cell

//todo Material 控件
//MaterialApp navigatorObsevrs 导航监听 监听全局页面进入和离开

//TODO Matrix4.identity()
//              ..translate(offsetX, offsetY)
//              ..scale(scaleNum)    matrix 平移距离相同时，先平移后缩放，与先缩放后平移的效果不一样

//TODO 分析图片加载结构，GIF一直播放？ 内存缓存机制 ，预加载机制，手写一个图片缓存，内存/磁盘

////曝光坑位Widget的context
//
//final RenderObject childRenderObject = context.findRenderObject();
//
//final RenderAbstractViewport viewport = RenderAbstractViewport.of(childRenderObject);
//
//if (viewport == null) {
//
//  return;
//
//}
//
//if (!childRenderObject.attached) {
//
//  return;
//
//}
//
////曝光坑位在容器内的偏移量
//
//final RevealedOffset offsetToRevealTop = viewport.getOffsetToReveal(childRenderObject, 0.0);
//

//hasDrawer scaffold中了解关于context的用法

//static Future<ui.Image> getImage(String asset) async {
//ByteData data = await rootBundle.load(asset);
//ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
//ui.FrameInfo fi = await codec.getNextFrame();
//return fi.image;
//}

//todo SingleTickerProviderStateMixin 原理 与 controller的关系  controller内部实例化了ticker

//todo ServicesBinding 中的BinaryMessenger 消息传递
//todo globlekey的应用 Currently the key is recreated every time _LoginState is rebuilt, which defeats it's purpose.
//     https://github.com/flutter/flutter/issues/20042 声明为static final

void main() {
  Visibility(
    child: LayoutBuilder(builder: null),
  );
  Colors.black.withOpacity(0.1);
}
