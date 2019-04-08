import 'package:flutter/material.dart';

//todo mediaquery  获取size    window.physicalSize.width / window.devicePixelRatio;不可靠，release mode可能获取不到
// todo IntrinsicHeight
//todo 自定义scrollview  listview(横竖布局)
//todo StatefulBuilder  Builder
//todo align
//todo  Material  制作material风格控件，使用主题，查看RaisedBtn
//todo SafeArea
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

///获取大小
///globle.currentcontext.size
///widgetKey.currentContext.findRenderObject().semanticBounds.size
///widgetKey.currentContext.findRenderObject().paintBounds.size
///
///  获取全局的坐标  为什么可以强转为Renderbox
///  RenderBox box = widgetKey.currentContext.findRenderObject();
//    Offset offset = box.localToGlobal(Offset.zero);
//    Size size = box.size;

///控件Dismissible
///
///     WidgetsBinding.instance.addPostFrameCallback(_afterLayout);   WidgetsBinding  widget和flutter engine之间的胶水
///
/// app的生命周期监听   class _AppLifecycleReactorState extends State<AppLifecycleReactor> with WidgetsBindingObserver
///
///
/// 文字动画实现可以用Matrix4和Vector3，比较高级（这个在TabBar用上了）
///
/// todo 线性插值
///
///todo Dismissible
void main() {
  Visibility(
    child: LayoutBuilder(builder: null),
  );
  Colors.black.withOpacity(0.1);
}
