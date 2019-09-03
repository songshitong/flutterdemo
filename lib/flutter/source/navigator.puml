@startuml

class Navigator{
  final String initialRoute
  final RouteFactory onGenerateRoute
  static NavigatorState of(BuildContext context, {bool rootNavigator = false,bool nullOk = false,})
  NavigatorState createState() => NavigatorState()
}
'note right of Navigator{
'  WidgetApp的build方法使用了Navigator，所以以后的widget树可以直接使用Navigator.of(context)获取NavigatorState
'    从而控制路由stack的状态

'  Navigator.of(context).push 与overlayState.insert(overlayEntry) 区别
'   insert不指定位置，默认在最上面，使用的是_entries.insert
'   push 使用的是_history中的overlayEntries.last，overlayState中insert的不在navigator的_history中
'   会出现先overlayState.insert，后Navigator push,但是navigator push的页面在下面，因为push不是在最新页面上面插入页面
'    改变图层上下位置   1 先把overlayEntries.remove 然后重新插入
'    2 NavigatorObserver 兼容拿到当前route，拿到所有图层route.overlayEntries，调用OverlayState.rearrange 或改变顺序insertall

' 定义：一个小部件，用于管理具有堆栈规则的一组子小部件
' Popup routes
'   routes不必遮挡整个屏幕，[PopupRoute]用[ModalRoute.barrierColor]覆盖屏幕，该屏幕只能部分不透明以允许当前屏幕显示,
'   弹出路由是“模态modal”的，因为他们阻止输入到下面的小部件
'   有一些功能可以创建和显示弹出路径。示例：[showDialog]，[showMenu]和[showModalBottomSheet].这些函数返回推送路径的Future，如上所述
'     调用者可以等待弹出路由返回的值来执行操作，或者发现路由的值
'   还有一些小部件可以创建弹出路由，例如[PopupMenuButton]和[DropdownButton],这些小部件创建PopupRoute的内部子类并使用Navigator的push
'      和pop方法来显示和消除它们
' Custom routes
'   您可以创建自己的一个窗口小部件库路由类的子类,像[PopupRoute]，[ModalRoute]或[PageRoute]来控制转换动画用于显示route，route的颜色和行为
'    模态障碍，以及路线的其他方面
'   [PageRouteBuilder]类可以在回调方面定义自定义路由,可查看注释例子
' Nesting Navigators
'   一个应用程序可以使用多个导航器。在下面嵌套一个导航器，另一个导航器可用于创建“内部旅程”，例如选项卡式导航，用户注册，商店结账或其他独立旅程
'     代表整个应用程序的子部分
'
'}
class NavigatorState{
   final List<Route<dynamic>> _history
   final Set<Route<dynamic>> _poppedRoutes
   final List<OverlayEntry> _initialOverlayEntries

   Route<T> _routeNamed<T>(String name, { @required Object arguments, bool allowNull = false })
   Future<T> push<T extends Object>(Route<T> route)
   Widget build(BuildContext context)
}
'note right of NavigatorState{
'   _routeNamed 根据name生成route
'   push  将给定route推到navigator上
'
'   build 方法Listener--AbsorbPointer--FocusScope--Overlay
'   监听--指针事件--focus--overlay
'}

abstract class Route<T> {
  NavigatorState _navigator
  final RouteSettings settings
  void install(OverlayEntry insertionPoint)
  TickerFuture didPush()
  void didReplace(Route<dynamic> oldRoute)
  bool didPop(T result)
  void didComplete(T result)
  void didPopNext(Route<dynamic> nextRoute)
  void didChangeNext(Route<dynamic> nextRoute)
  void didChangePrevious(Route<dynamic> previousRoute)
  void changedInternalState()
  void changedExternalState()
  void dispose()
}
'note right of Route{
'  定义：由[Navigator]管理的条目的抽象
'  该类定义了导航器和被推入并从导航器中弹出的“路由”之间的抽象接口。大多数路线都有
'  视觉可供性，它们使用一个或更多[OverlayEntry]对象放置在导航器[Overlay]中
'
'   install 将route插入navigator时调用,使用它来填充[overlayEntries]并将它们添加到overlay（可以[Navigator.overlay]访问）
'     （[Route]负责这个而不是[Navigator]的原因是[Route]将负责_removing_条目，这样它对称。）
'      如果这是插入的第一个路由，`insertionPoint`参数将为null。否则，它指示立即放置在该route的第一个overlay下方的overlay entry
'
'}

class OverlayEntry {
   final WidgetBuilder builder
   bool _opaque
   bool _maintainState
   OverlayState _overlay
   void remove()
}
'note right of OverlayEntry{
'  定义：[Overlay]中可以包含小部件的位置
'  使[OverlayState.insert]或[OverlayState.insertAll]函数将overlay插入[Overlay],为找到给定[BuildContext]的最近封闭叠加层，
'   使用[Overlay.of]功能
'  overlay entry 一次最多只能在一个overlay里面,从其overlay删除条目调用overlay entry上的[remove]函数
'  因为[Overlay]使用[Stack]布局，所以overlay entry可以使用[Positioned]和[AnimatedPositioned]将自己定位在overlay
'
'  例如，[Draggable]使用[OverlayEntry]来显示拖动头像,拖动开始后跟随用户的手指穿过屏幕.使用overlay显示拖动头像让头像浮动到
'    应用程序中的其他小部件上面。当用户的手指移动时，Draggable的调用[markNeedsBuild]在overlay entry上使其重建.它的构建，
'     该条目包括一个[Positioned]，其顶部和左侧属性设置为将拖动化身放在用户手指附近.阻力结束时， [Draggable]从overlay中删除条目以删除
'     来自视图拖动头像
'  默认情况下，如果有一个完全[不透明opaque]条目，那么这个将不会包含在窗口小部件树中（特别是overlay entry中的有状态窗口小部件不会被实例化
'    确保你的覆盖条目仍然构建，即使它不可见，设置[maintainState]为真。这是更昂贵的，所以应该小心。特别是，如果覆盖条目中的小部件
'    [maintainState]重复设置为true调用[State.setState]，用户的电池将被不必要地耗尽
'
'    _opaque 此条目是否会遮盖整个overlay.如果条目声称是不透明的，那么，为了提高效率，叠加将跳过该条目下面的构建条目，
'      除非它们具有[maintainState]设置
'    _maintainState 即使在其上方有完整的[opaque]条目，此条目是否必须包含在树中.[Navigator]和[Route]对象使用它来确保即使在后台也保持路径，
'    以便后续路径中承诺的[Future]将在完成后正确处理. 一部分注释在上面的包括了
'
'}

class Overlay {
  List<OverlayEntry> initialEntries
  OverlayState of(BuildContext context, { Widget debugRequiredFor })
  OverlayState createState() => OverlayState()
}
'note right of Overlay{
'  可以独立管理的[堆栈]条目
'  Overlay让独立的子窗口小部件“浮动”视觉元素,通过将其插入到叠加层[Stack]中展示在其他小部件之上。Overlay使用[OverlayEntry]对象让
'  这些小部件中的每一个都管理它们在叠加层中的参与
'
'  虽然您可以直接创建[Overlay]，但最常见的是使用[WidgetsApp]或[MaterialApp]中[Navigator]创建的叠加层。
'  Navigator使用其overlay来管理其路线的视觉外观。
'}

class OverlayState{
 final List<OverlayEntry> _entries
 void insert(OverlayEntry entry, { OverlayEntry below, OverlayEntry above })
 void rearrange(Iterable<OverlayEntry> newEntries, { OverlayEntry below, OverlayEntry above })
 Widget build(BuildContext context)
}

'note right of OverlayState{
'   insert 将给的entry插入进overlay，below和above在哪个Entry的上面或下面，默认在最上面
'   rearrange 删除给定iterable中列出的所有entry，然后按给定顺序将它们重新插入到Overlay
'   build 返回stack包裹的多个_OverlayEntry  _OverlayEntry的build方法最终调用OverlayEntry的builder构建widget
'}

abstract class OverlayRoute<T>{
  bool  finishedWhenPopped
  List<OverlayEntry> _overlayEntries
  Iterable<OverlayEntry> createOverlayEntries()
}
'note right of OverlayRoute{
'  在[Navigator]的[Overlay]中展示widgets的route
'  finishedWhenPopped  控制[didPop]是否调用[NavigatorState.finalizeRoute]
'    true  此route在[didPop]期间删除其overlay entry
'    false 延时移除，比如页面动画结束
'}

abstract class TransitionRoute<T>{
   bool  opaque
   bool canTransitionTo(TransitionRoute<dynamic> nextRoute)
    bool canTransitionFrom(TransitionRoute<dynamic> previousRoute)
}


'note right of TransitionRoute{
'  带入口和出口过渡的route
'  opaque transition完成后route是否会遮盖以前的route
'  canTransitionTo  true 此路由支持一个过渡动画，该动画在[nextRoute]被推到它上面或当[nextRoute]从它上面弹出时运行
'}

abstract class ModalRoute<T>{
  bool  barrierDismissible
  bool  offstage
  bool  maintainState
  Color barrierColor
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation)
  Widget buildTransitions(BuildContext context,Animation<double> animation,Animation<double> secondaryAnimation,Widget child,)
}

'note right of ModalRoute{
'  阻止与先前路由交互的路由
'  [ModalRoute]覆盖整个[Navigator]。然而他们不一定[opaque];例如，弹出菜单仅使用[ModalRoute]在与前一个route重叠的小方框中显示菜单
'  barrierDismissible  是否可以通过点击模态障碍来解除route
'   true 如果[barrierDismissible]为true，则点击此屏障将导致当前路径被弹出（参见[Navigator.pop]），其值为null
'  offstage 这条路线目前是否在后台 如果[offstage]为真，则不会呈现modal barrier（如果有）
'    在route入口过渡的第一帧上，路线使用1.0的动画进度构建[Offstage]。该路径是不可见的非交互式，但每个小部件都有其最终大小和位置。
'    这个机制让[HeroController]确定任何hero的最终本地小部件被动画化为过渡的一部分
'  maintainState 路由在处于非活动状态时是否应保留在内存中
'  barrierColor  用于模态屏障的颜色。如果这是null，屏障将是透明的
'     当[offstage]为true时，颜色被忽略，屏障变得不可见
'     如果此getter将开始返回不同的颜色，则应调用[changedInternalState]以使更改可以采取效果
'}

abstract class PopupRoute<T>{
  bool get opaque => false;
  bool get maintainState => true;
}
'note right of PopupRoute{
'  在当前路由上覆盖窗口小部件的模式route
'}

class _DialogRoute<T>{

}

class PageRoute<T>{
  bool get opaque
  bool get barrierDismissible
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute)
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute)
}
'note right of PageRoute{
'  替换整个屏幕的modal route
'}

class PageRouteBuilder<T>{
    Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation)
    Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child)
}
'note right of PageRouteBuilder{
'  用于根据回调定义一次性页面路由的实用程序类
'  调用者必须定义创建route 主要内容的[pageBuilder]函数.要添加过渡，请定义[transitionsBuilder]功能
'}

class MaterialPageRoute<T>{

}
'note right of MaterialPageRoute{
'  对于Android，页面的入口转换会向上滑动页面并将其淡入。退出转换是相同的，但相反
'}

class CupertinoPageRoute<T>{

}

'note right of CupertinoPageRoute{
'  页面从右侧滑入，然后反向退出。它也向左视差运动移动,当另一页进入以覆盖它时
'}
abstract class TransitionRoute<T>
StatefulWidget <|-- Navigator
State          <|-- NavigatorState
Navigator      <.. NavigatorState
NavigatorState <.. Route
Route          <.. OverlayEntry
Route          <|-- OverlayRoute
OverlayRoute   <|-- TransitionRoute
TransitionRoute<|-- ModalRoute
ModalRoute     <|-- PopupRoute
StatefulWidget <|-- Overlay
Overlay        <.. OverlayEntry
State          <|-- OverlayState
Overlay        <..  OverlayState
OverlayEntry   <..  OverlayState
PopupRoute     <|--  _DialogRoute
ModalRoute     <|--  PageRoute
PageRoute      <|-- PageRouteBuilder
PageRoute      <|-- MaterialPageRoute
PageRoute      <|-- CupertinoPageRoute

@enduml