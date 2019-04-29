//Animation 它用于保存动画的插值和状态
//addListener()可以给Animation添加帧监听器，在每一帧都会被调用
//addStatusListener()可以给Animation添加“动画状态改变”监听器；动画开始、结束、正向或反向（见AnimationStatus定义）时会调用StatusListener

//Curve 动画曲线，类似于Android插值器，控制动画变化的速度，系统提供类curves 曲线的值开始为0，结束为1

//AnimationController 控制动画的开始结束  controller可以线性生成0，1或其他值，如果控制多个或使用曲线生成值使用tween或CruveTween等
// AnimationController会在动画的每一帧，就会生成一个新的值。默认情况下，AnimationController在给定的时间段内线性的生成从0.0到1.0（默认区间）的数字
//AnimationController生成数字的区间可以通过lowerBound和upperBound来指定
//Animation对象的当前值可以通过value()方法取到
//repeat()重复方法，调用前必须设置duration ，与forward选一个
//AnimationController.vaue = [0,1] 0到1
//   animateto    将动画从其当前值驱动到目标值
//   animatewith  根据给定的模拟驱动动画
//   fling 它主要用于具有lowerBound和upperBound的AnimationControllers，以像素为单位，而不是超过0.0 ... 1.0的默认范围
//        fling使用带有默认参数的SpringSimulation，其中一个是弹簧常量。即使从速度零开始，弹簧也会以弹簧常数确定的速度弹簧
//        如果想让他慢一点可以用animatewith代替,   模拟一个减速到0的自然运动，类似惯性运动

//      _btnController.forward().whenComplete(() {
//        _btnController.forward();
//      });
//dismissed	动画在起始点停止   forward	动画正在正向执行   reverse	动画正在反向执行  completed	动画在终点停止
//forward方法 会出发forward和complete状态
//reset       会触发dismissed状态，动画回到初始状态
//reverse     触发reverse和dismissed状态
// 一个controller控制无限连续状态 1 repeat方法 2 forward和reverse/reset组合使用

//Ticker  SingleTickerProviderStateMixin添加到State的定义中，然后将State对象作为vsync的值
//使用Ticker(而不是Timer)来驱动动画会防止屏幕外动画（动画的UI不在当前屏幕时，如锁屏时）消耗不必要的资源，
// 因为Flutter中屏幕刷新时会通知到绑定的SchedulerBinding，而Ticker是受SchedulerBinding驱动的，由于锁屏后屏幕会停止刷新，所以Ticker就不会再触发。

//Tween  开始值和结束值之间的线性插值
//如果要在范围内插值，[Tween]非常有用
//您可以使用[chain]方法将[Tween]对象链接在一起，以便单个[Animation]对象由连续调用的多个[Tween]对象配置.这与调用[animate]方法两次不同，
/////导致两个单独的[Animation]对象，每个对象配置一个单[Tween]
//默认情况下，AnimationController对象值的范围是0.0到1.0。如果我们需要不同的范围或不同的数据类型，则可以使用Tween来配置动画以生成不同的范围或数据类型的值
//Tween对象不存储任何状态，相反，它提供了evaluate(Animation<double> animation)方法，它可以获取动画当前值
//要使用Tween对象，需要调用其animate()方法，然后传入一个控制器对象
//性能优化
//Tweens是可变的;具体来说，它们的[begin]和[end]值可以在运行时更改。使用[Animation.drive]创建的对象使用[Tween]将立即兑现对底层[Tween]的更改（尽管如此）
//侦听器只有在[动画]正在动画时才会被触发。这可以用来动态地改变动画而不必重新创建链中的所有对象，从[AnimationController]到final [Tween]

//如果永远不会更改[Tween]的值，则可以进一步优化应用：对象可以存储在`static final`变量中，以便只要需要[Tween]，就会使用完全相同的实例。
//这是比每次调用[State.build]重新创建一个相同的[Tween]要好
//有特殊考虑的类型
//ColorTween  SizeTween  FractionalOffsetTween   AlignmentTween   MaterialPointArcTween

//flutter 提供FadeTransition、ScaleTransition、SizeTransition、FractionalTranslation
//todo PositionedTransition实现
//通过AnimatedBuilder和AnimatedWidget实现的复用
//todo AnimatedBuilder child 参数，可方便将state的widget.child设为child

/// 例子查看custom_curve.dart
