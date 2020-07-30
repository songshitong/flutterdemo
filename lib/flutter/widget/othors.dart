import 'package:flutter/material.dart';

// todo IntrinsicHeight
//todo StatefulBuilder  Builder
//todo align
//todo  Material  制作material风格控件，使用主题，查看RaisedBtn  scaffold常用widget  material和sacafflod会将常用属性以inherit widget初始化到widget tree

/// PageStorage

//todo widgets.puml的State 注释完善

//InkResponse 非矩形的点击效果， 查看iOS的点击效果

//AnimatedSize
//顶部变量 每次引入dart文件，顶部变量是否重新初始化

///Material inkwell 和ink 没有水波纹时，使用material包裹

// Navigator.maybePop(context); 自动返回上一层            tooltip也可以做到
//showBottomSheet 点击外部不自动消失   showModalBottom Sheet 可以

///todo SliverLayoutBuilder layoutbuilder  Builder  StatefulBuilder  CustomSingleChildLayout

//stack  中间滚动 底部固定(设置白色 Container不透明 ink透明 查看两者的图层显示)
// 跟上一条一样，flatbutton 嵌套圆角container和ink

//stack  singlescrollview  postion(bottom textfield)  出现键盘将bottom顶上去，为何singleScroll没有顶上去

//Divider 使用

//StatefulBuilder setState的用法

//stful->stful    stful只initState一次      父类重建，怎么让子重建然后走init刷新从父类过来的数据

//ValueChanged及相关文件的监听事件

///软键盘弹出  onMetricschange  MediaQuery的viewInset没有改变   使用MediaQueryData.fromWindow(WidgetsBinding.instance.window);
///
///
/// TODO 通过key找到state基本可以调用widget的state里面的方法，flutter框架的，第三方的都可以

///透明区域可点击
///HitTestBehavior.translucent
///
///
/// customScroller view     SliverList 分页构建    SliverToBoxAdapter 一次把item Builder全部加载出来
/// singlechildScroll  colunm  listview 不限制大小，一次性全部builder  BoxContrain,给listview进行限制  是不是跟shrinkwrap有关，高度由内容决定
/// https://github.com/flutter/flutter/issues/29214  使用CustomScroll with SliverList/SliverGrid替代可以吗

///chip
///
///上拉刷新controller  http://flutter.link/2018/05/03/ListView%E4%B8%8B%E6%8B%89%E5%88%B7%E6%96%B0%E4%B8%8E%E5%8A%A0%E8%BD%BD%E6%9B%B4%E5%A4%9A/
///
/// 滚动停止
/// new NotificationListener(
//  child: new ListView(
//    controller: _scrollController,
//    children: ...
//  ),
//  onNotification: (t) {
//    if (t is ScrollEndNotification) {
//      print(_scrollController.position.pixels);
//    }
//  },
//),

///push 返回值  pop传入

///获取大小   context.findeRenderObject也可以，但要在绘制完成
///globle.currentcontext.size
///widgetKey.currentContext.findRenderObject().semanticBounds.size
///widgetKey.currentContext.findRenderObject().paintBounds.size
///
///
///
///  获取全局的坐标  为什么可以强转为Renderbox   Renderbox定义了坐标体系
///  RenderBox box = widgetKey.currentContext.findRenderObject();
//    Offset offset = box.localToGlobal(Offset.zero);
//    Size size = box.size;

///
/// 文字动画实现可以用Matrix4和Vector3，比较高级（这个在TabBar用上了）
///
/// todo 线性插值
///
///todo layoutbuilder  实现根据constrains动态子布局，父固定-》constarins固定/充满屏-》类似gallery的多个产品

//todo 不同项目使用不同版本渠道的flutter
//各种theme

// function 是const吗  一个const构造器，接受一个function     class外面的是function，里面的是method???

//SynchronousFuture
//Completer
//AspectRatio
//Texture

//Zone 类使用  ImageProvider.resolve 方法，根据image配置读取image
//rootBundle    ByteData   Uint8List   ByteData.buffer.asUint8List()   String.fromCharCode(e.codeUnitAt(0) & 0xff)
//ByteData.buffer.asUint8List(value.offsetInBytes, value.lengthInBytes).cast<int>()
//Uint8List.view

//TextTheme 字体主题之类的系统资源
//查看foundation  import 'package:flutter/foundation.dart' as foundation;     foundation.defaultTargetPlatform

//todo Material 控件

//TODO Matrix4.identity()
//              ..translate(offsetX, offsetY)
//              ..scale(scaleNum)    matrix 平移距离相同时，先平移后缩放，与先缩放后平移的效果不一样

//TODO 分析图片加载结构，GIF一直播放？ 内存缓存机制 ，预加载机制，手写一个图片缓存，内存/磁盘
//todo nestscrollwidget 解决冲突原理
//todo 使用form做表单验证，登录？？多个框的验证失败

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

///todo  路由为什么会触发这个？？ 路由切换会触发build
//didchangedependences   常见用法，旧的移除新的添加
//void didUpdateWidget(VideoPlayer oldWidget) {
//  super.didUpdateWidget(oldWidget);
//  oldWidget.controller.removeListener(_listener);
//  _textureId = widget.controller.textureId;
//  widget.controller.addListener(_listener);
//}

//todo SingleTickerProviderStateMixin 原理 与 controller的关系  controller内部实例化了ticker
//TickerMode 控制子树的动画

//todo ServicesBinding 中的BinaryMessenger 消息传递

//TODO 查看constranlayout源码进行改造
//https://blog.csdn.net/m0_37667770/article/details/100557072 动画 基础，一个view，两个view，多个view

///stateful  deactive方法
///
/// dispose后 仍然有监听 markneedrebuild,setState然后出错
/// https://github.com/flutter/flutter/issues/25047   标记dispose，true不进行setstate

//一个易用的布局
//居中  水平居中，竖直居中
//靠边  与父级的上下左右对齐
//流式布局  flowlayout  按百分比扩散  布局如何扩展  多种布局是应结合到一起还是进行拆分，组件式设计？？
//按比例  占据某个方向的比例位置和宽度
//相邻子元素的关系  一起运动，相对运动（相对位置的不断变化）
//适配？？自动缩放
//性能  layout和paint的次数，重绘边界，延迟处理计算？？
//是否便于获取布局信息（孩子的大小，位置，自身信息等）
//滚动是否支持？？（优先级很低，）
// 重叠(重叠谁在上，谁在下)，是否可以更改子的绘制顺序，
//  相对布局  一个元素与另一个的对齐关系    使用水平竖直排列是否可以完成

//异常捕获
//runZoned
//FlutterError.onError   自定义flutter err 页面
//Isolate.current.addErrorListener
//sentry 官方插件

//重写base state
//abstract class BaseState<T extends StatefulWidget> extends State<T>

//InkResponse

//todo pageview 源码   没有item缓存   itembuilder每次调用？一次生成则可以复用？
//tabbarview 源码

///flutter 的build是在页面更新的时候调用，不是GPU的重绘，频繁build说明页面频繁build
///
/// TODO info: This class (or a class which this class inherits from) is marked as '@immutable', but one or more of its instance fields are not final: SearchWithResults.content (must_be_immutable at [gwadarpro] lib/pages/news/news_search.dart:221)
///  查看flutter的指导规则
///
/// context.owner.debugbuilding 查看是否处于build状态

//安装
//flutter_downloader: ^1.3.2
//install_plugin: ^2.0.0
// app查询版本
//http://itunes.apple.com/cn/lookup?id=APPID

///Clipboard 剪切板  Clipboard.setData(ClipboardData(text: '复制到剪切板'))   Clipboard.getData(Clipboard.kTextPlain)

//优化断网后获取到系统配置，联网后重新请求，网络波动，频繁断连网怎么解决
///异步任务  异步队列怎么写
///
///
///
/// 代码规范 https://github.com/alibaba/flutter-go/blob/develop/Flutter_Go%20%E4%BB%A3%E7%A0%81%E5%BC%80%E5%8F%91%E8%A7%84%E8%8C%83.md
///
/// flutter 静态路由     动态路由--》不好操控，重用
///
/// factory todo factory原理
///
/// Overlay.of(context).context.findRenderObject()

///状态管理
/// 全局状态   永久不变/改变
///
/// 多页面状态  共享与销毁
///
/// 两个页面 共享对象可以直接修改   进入另一个页面，然后返回，返回的当前页面是否进入build方法，进入的话，build使用共享变量是否达到自动更新功能
///  进入build发生重绘？？   GlobalKey的widget的不重绘，key.state.setState
///
///
/// 网络接口   setsate  判断mounted
///
///
/// TOdo  ffi
///
/// createBorderSide
///
///
/// 页面间通信   父子      不同模块不同页面    同一页面多个级别
///
/// TODO APPbar源码   release模式，第一次mediaquery 拿不到数据
///
/// IntrinsicWidth
///
/// scrollable.ensurevisiable  RenderAbstractViewport
///
///
/// https://book.flutterchina.club/chapter7/dailog.html  代码优化部分  context的范围
///
/// dialog 弹出后怎么判断当前是否消失，navigator   传入的context与builder的context      当前页有dialog即是当前页不是first
/// dialog 管理 https://medium.com/flutter-community/manager-your-flutter-dialogs-with-a-dialog-manager-1e862529523a
///
/// PageStorageBucket
///
/// BackdropFilter
///
///
/// 信号量   三个异步任务，信号量为3，没完成一个信号量减1，信号量为0全部异步任务完成。  信号量为0不能创建新的异步。iOS
///
/// 权限框架  后端的shrio ,angula, 权限模型的几个角色
///
/// Size.fromHeight(myAppBarHeight)
///
/// relase 模式下，mediaquery.of.size.view.padding 一开始为空，原生未进行回调，增加闪屏页
///
///
/// MediaQuery.of(Constant().rootContext).padding.top  在didupdatewidget为0，使用根context
///
///     WidgetSpan(child: null) 富文本使用
///
/// http://www.ptbird.cn/flutter-route-named-route-list-root-route.html 静态路由传参
///
///
/// 两个页面使用通信框架与直接传递变量或者监听的比较
///
///
/// 断网重连
/// https://www.jianshu.com/p/110d1f0b457d
/// https://gameinstitute.qq.com/community/detail/109927
///
///     IsolateNameServer
///
///
///  flutter_downloader 研究下载机制
///
///
/// ScrollablePositionedList
///
/// 类似single task
/// ///   navigator.pushAndRemoveUntil(
//  ///     MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
//  ///     ModalRoute.withName('/'),
//  ///   );

//todo SliderTheme.of(context).copyWith  SliderTheme自定义滑块样式     Slider
void main() {
  Visibility(
    child: LayoutBuilder(builder: null),
  );
  Colors.black.withOpacity(0.1);

  // unit8list 保存为图片
//  File.fromRawPath(rawPath);

  ///ancestor
//  widget.button.localToGlobal(Offset.zero, ancestor: widget.overlay),

  ///paintImage 与 boxfit的关系
}

///颜色转换
/// 1 手动替换# 0xFF   int.parse(String); 不要radix
/// 2
/// Construct a color from a hex code string, of the format #RRGGBB.
///
///  ///https://www.jianshu.com/p/0f96ce199c38 图片裁剪，拼接
//  ///
//  /// SVGAPlayer-Flutter
//  ///
//  ///

///flutter cache manager 缓存管理机制
///
/// 异步
/// https://blog.csdn.net/email_jade/article/details/88941434
///
///
/// DefaultTextStyle.of(context).style.fontSize
///
///  IntTween()
//    TweenSequence(items)

//BouncingScrollPhysics  TODO 滚动原理，实现初始位置滑动，停住，结束位置滑动，继续滑动，停住

//https://www.didierboelens.com/2019/05/is-a-widget-inside-a-scrollable-visible/

///flutter texture的使用 textureid
///
/// rangeSlider
///
///
/// WillPopScope 路由拦截原理  ModalRoute.addScopedWillPopCallback
///
/// datatable
///
/// textStyle fontFeatures
Color hexToColor(String code) {
  ///todo 颜色渐变 通过lerp
//  Color.lerp(a, b, t)
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
