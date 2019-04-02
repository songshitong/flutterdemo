import 'package:flutter/material.dart';
//Animation 它用于保存动画的插值和状态
//addListener()可以给Animation添加帧监听器，在每一帧都会被调用
//addStatusListener()可以给Animation添加“动画状态改变”监听器；动画开始、结束、正向或反向（见AnimationStatus定义）时会调用StatusListener
//dismissed	动画在起始点停止   forward	动画正在正向执行   reverse	动画正在反向执行  completed	动画在终点停止

//Curve 动画曲线，类似于Android插值器，控制动画变化的速度，系统提供类curves

//AnimationController 控制动画的开始结束
// AnimationController会在动画的每一帧，就会生成一个新的值。默认情况下，AnimationController在给定的时间段内线性的生成从0.0到1.0（默认区间）的数字
//AnimationController生成数字的区间可以通过lowerBound和upperBound来指定
//Animation对象的当前值可以通过value()方法取到
//forward 正向执行
//repeat()重复方法，调用前必须设置duration ，与forward选一个
//AnimationController.vaue = [0,1] 0到1
//todo 测试   animateto  animatewith
// todo 自定义curve

//      _btnController.forward().whenComplete(() {
//        _btnController.forward();
//      });

//Ticker  SingleTickerProviderStateMixin添加到State的定义中，然后将State对象作为vsync的值
//使用Ticker(而不是Timer)来驱动动画会防止屏幕外动画（动画的UI不在当前屏幕时，如锁屏时）消耗不必要的资源，
// 因为Flutter中屏幕刷新时会通知到绑定的SchedulerBinding，而Ticker是受SchedulerBinding驱动的，由于锁屏后屏幕会停止刷新，所以Ticker就不会再触发。

//Tween
//默认情况下，AnimationController对象值的范围是0.0到1.0。如果我们需要不同的范围或不同的数据类型，则可以使用Tween来配置动画以生成不同的范围或数据类型的值
//Tween对象不存储任何状态，相反，它提供了evaluate(Animation<double> animation)方法，它可以获取动画当前值
//要使用Tween对象，需要调用其animate()方法，然后传入一个控制器对象
//animation.vaue 定义的tween的区间

//flutter 提供FadeTransition、ScaleTransition、SizeTransition、FractionalTranslation
//通过AnimatedBuilder和AnimatedWidget实现的复用
