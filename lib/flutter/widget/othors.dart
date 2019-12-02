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

// Navigator.maybePop(context); 自动返回上一层
//showBottomSheet 点击外部不自动消失   showModalBottomSheet 可以

//stack  中间滚动 底部固定(设置白色 Container不透明 ink透明 查看两者的图层显示)
// 跟上一条一样，flatbutton 嵌套圆角container和ink

//stack  singlescrollview  postion(bottom textfield)  出现键盘将bottom顶上去，为何singleScroll没有顶上去

//Divider 使用

//StatefulBuilder setState的用法

//stful->stful    stful只initState一次      父类重建，怎么让子重建然后走init刷新从父类过来的数据

//ValueChanged及相关文件的监听事件

///软键盘弹出  onMetricschange  MediaQuery的viewInset没有改变   使用MediaQueryData.fromWindow(WidgetsBinding.instance.window);

///透明区域可点击
///HitTestBehavior.translucent
///
///
/// customScroller view     SliverList 分页构建    SliverToBoxAdapter 一次把item Builder全部加载出来
/// singlechildScroll  colunm  listview 不限制大小，一次性全部builder  BoxContrain,给listview进行限制

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

//todo SingleTickerProviderStateMixin 原理 与 controller的关系  controller内部实例化了ticker
//TickerMode 控制子树的动画

//todo ServicesBinding 中的BinaryMessenger 消息传递

//TODO 查看constranlayout源码进行改造
//https://blog.csdn.net/m0_37667770/article/details/100557072 动画 基础，一个view，两个view，多个view

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

//安装
//flutter_downloader: ^1.3.2
//install_plugin: ^2.0.0
// app查询版本
//http://itunes.apple.com/cn/lookup?id=APPID

///状态管理
/// 全局状态   永久不变/改变
///
/// 多页面状态  共享与销毁
///
/// 两个页面 共享对象可以直接修改   进入另一个页面，然后返回，返回的当前页面是否进入build方法，进入的话，build使用共享变量是否达到自动更新功能
///  进入build发生重绘？？
///
///
/// 网络接口   setsate  判断mounted
void main() {
  Visibility(
    child: LayoutBuilder(builder: null),
  );
  Colors.black.withOpacity(0.1);
}
