// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:gwadarpro/common/assets.dart';
// import 'package:gwadarpro/common/functions.dart';
// import 'package:gwadarpro/model/point_ball.dart';
// import 'package:gwadarpro/model/sapling_model.dart';
// import 'package:gwadarpro/util/http/http_util.dart';
// import 'package:gwadarpro/util/log_util.dart';
// import 'package:gwadarpro/util/time_util.dart';
// import 'package:gwadarpro/widget/image_builder.dart';
// import 'package:quiver/strings.dart';
//
// import 'green_bought_page.dart';
//
// //// todo flutter/source/key.puml key  重建
// class GreenPage extends StatefulWidget {
//   @override
//   _GreenPageState createState() => _GreenPageState();
// }
//
// class _GreenPageState extends State<GreenPage> {
//   int userPoints = 0;
//   List<PointBall> pointBallsList = [];
//   List<PointBall> pointTransList = [];
//
//   ///已购树苗
//   SaplingModel saplingModel;
//   List<Future> collectPointBallList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     getUserPoints();
//
//     ///todo 积分球查询实时
//     getUserBalls();
//     getBoughtSaplings();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: <Widget>[
//             ///背景
//             ImageBuilder.buildImage(
//               AllAssets.green_home_background,
//               width: MediaQuery.of(context).size.width,
//               height: hs(1800),
//             ),
//             Positioned(
//                 top: hs(170),
//                 left: ws(170),
//                 child: Visibility(
//                     visible: null == saplingModel && pointBallsList.length == 0,
//                     child: ImageBuilder.buildImage(AllAssets.green_home_title, width: ws(740), height: hs(390)))),
//
//             ///种树按钮
//             Positioned(
//               bottom: hs(90),
//               child: Visibility(
//                 visible: null == saplingModel,
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(bottom: hs(25)),
//                       child: Stack(
//                         children: <Widget>[
//                           ImageBuilder.buildImage(AllAssets.green_home_plant_title_bg, width: ws(823), height: hs(189)),
//                           Padding(
//                             padding: EdgeInsets.only(top: hs(35), left: ws(40)),
//                             child: Text(
//                               "You haven`t planted trees yet.\nPlease select the saplings you want to plant.",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(fontSize: ss(37)),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Center(
//                         child: Material(
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(hs(56)))),
//                           child: InkWell(
//                             onTap: () {
//                               jump2BoughtSaplings(context);
//                             },
//                             child: Ink.image(
//                               image: AssetImage(
//                                 AllAssets.green_home_plant_btn,
//                               ),
//                               fit: BoxFit.fill,
//                               width: ws(358),
//                               height: hs(116),
//                               child: Center(
//                                   child: Text(
//                                 "plant trees",
//                                 style: TextStyle(color: Color(0xffff6106), fontSize: ss(50)),
//                               )),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             ///积分 头像 买树
//             Positioned(
//               top: hs(35),
//               right: 0,
//               child: Container(
//                 height: hs(112),
//                 decoration: BoxDecoration(
//                     color: Color(0xff9ecdfc),
//                     borderRadius:
//                         BorderRadius.only(topLeft: Radius.circular(hs(110)), bottomLeft: Radius.circular(hs(110)))),
//                 child: Row(
//                   children: <Widget>[
//                     Padding(
//                       padding: EdgeInsets.only(left: ws(14)),
//                       child: ImageBuilder.buildCircleImage("", errImg: AllAssets.placeholder_square, radius: ws(96)),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: ws(20)),
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: <Widget>[
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Text("POINTS",
//                                   style: TextStyle(
//                                       color: Color(0xff087af9), fontSize: ss(27), fontWeight: FontWeight.w300)),
//                               Text("$userPoints", style: TextStyle(fontSize: ss(40), color: Color(0xff087af9)))
//                             ],
//                           ),
//
//                           ///积分增加动画
//                           Center(
//                             child: Builder(builder: (context) {
//                               var children = <Widget>[];
//                               pointTransList.forEach((ball) {
//                                 children.add(AddPointsTransition(
//                                   "+${ball.pointValue}",
//                                   onComplete: () {
//                                     pointTransList.remove(ball);
//                                     LogUtil.debug("AddPointsTransition onComplete $ball");
//                                   },
//                                   key: ValueKey(ball),
//                                 ));
//                               });
//                               LogUtil.debug("pointTransList $pointTransList children $children");
//                               return Column(
//                                 children: children,
//                               );
//                             }),
//                           )
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: ws(35), right: ws(20)),
//                       child: InkWell(
//                           onTap: () {
//                             jump2BoughtSaplings(context);
//                           },
//                           child: ImageBuilder.buildImage(AllAssets.green_home_icon_sapling,
//                               width: ws(97), height: ws(97))),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//
//             ///success  暂时没有捐赠
//             Positioned(
//               top: hs(170),
//               right: ws(20),
//               child: Visibility(visible: false, child: ImageBuilder.buildImage(AllAssets.green_home_icon_success)),
//               width: ws(97),
//               height: ws(97),
//             ),
//
//             ///小树苗
//             Positioned(
//                 bottom: hs(270),
//                 child: Visibility(
//                     visible: null != saplingModel,
//                     child: SizedBox(
//                         width: MediaQuery.of(context).size.width,
//                         child: Center(
//                             child: ImageBuilder.buildImage(AllAssets.green_home_sapling_little,
//                                 width: ws(160), height: hs(195)))))),
//
//             ///进度条
//             Positioned(
//                 bottom: hs(100),
//                 child: Visibility(
//                   visible: null != saplingModel && false,
//                   child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Center(
//                           child: ProgressBar(
//                         currentProgress: saplingModel?.consumeTotalPoints ?? 0,
//                         maxProgress: saplingModel?.growupRequiredPoints ?? 0,
//                       ))),
//                 )),
//
//             ///积分球
//             Positioned(
//               left: 0.0,
//               width: MediaQuery.of(context).size.width,
//               top: 0.0,
//               height: hs(950),
//               child: Visibility(
//                   visible: pointBallsList.length > 0,
//                   child: pointBallsList.length > 0
//                       ? LayoutBuilder(builder: (context, constraints) {
//                           return PointBallLayout(
//                             constraints: constraints,
//                             pointBallsList: pointBallsList,
//                             onTap: (pointBall) async {
//                               ///顺序调用收取积分球接口和刷新积分接口
//                               await collectPointBall(pointBall.behavior);
//                               await getUserPoints();
//                               setState(() {
//                                 pointTransList.add(pointBall);
//                               });
//                             },
//                           );
//                         })
//                       : Container()),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void jump2BoughtSaplings(BuildContext context) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context) {
//       return GreenBoughtPage(
//         userPoints: userPoints,
//         saplingModel: saplingModel,
//       );
//     })).then((sapling) {
//       LogUtil.debug("jump2BoughtSaplings sapling $sapling");
//       if (null != sapling) {
//         //买树成功
//         setState(() {
//           saplingModel = sapling;
//         });
//       }
//     });
//   }
//
//   Future collectPointBall(String behavior) async {
//     Future future = await HttpUtil().collectPointsBall(behavior).then((result) {});
//
//     return future;
//   }
//
//   Future getUserPoints() {
//     return HttpUtil().getUserPoints().then((result) {
//       final data = result.data;
//       if (null != data && mounted) {
//         setState(() {
//           userPoints = data["totalPoints"];
//         });
//       }
//     });
//   }
//
//   void getUserBalls() {
//     HttpUtil().getPointsBall().then((result) {
//       final data = result.data;
//       if (null != data && data is Iterable && data.length > 0) {
//         for (dynamic item in data) {
//           pointBallsList.add(PointBall.fromJson(item));
//         }
//         if (mounted) {
//           setState(() {});
//         }
//       }
//     });
//   }
//
//   void getBoughtSaplings() {
//     HttpUtil().getSaplingsBought().then((result) {
//       final data = result.data;
//       if (null != data && data.length > 0 && mounted) {
//         setState(() {
//           saplingModel = SaplingModel.fromJson(data);
//         });
//       }
//       LogUtil.debug("getBoughtSaplings saplingModel $saplingModel");
//     });
//   }
// }
//
// class ProgressBar extends StatelessWidget {
//   var radius = BorderRadius.all(Radius.circular(hs(8)));
//   int currentProgress;
//   int maxProgress;
//   ProgressBar({this.currentProgress = 0, this.maxProgress = 0});
//
//   @override
//   Widget build(BuildContext context) {
//     double progress;
//
//     if (0 == maxProgress) {
//       progress = 0.0;
//     } else {
//       progress = currentProgress / maxProgress;
//     }
//
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           right: ws(5),
//           child: Text(
//             "$currentProgress/$maxProgress",
//             style: TextStyle(color: Colors.white, fontSize: ss(25)),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.only(top: hs(30)),
//           child: Container(
//             width: ws(600),
//             height: hs(15),
//             decoration: BoxDecoration(color: Color(0xff395c2d), borderRadius: radius),
//           ),
//         ),
//         Padding(
//           padding: EdgeInsets.only(top: hs(30)),
//           child: Container(
//             width: ws(600) * progress,
//             height: hs(15),
//             decoration: BoxDecoration(color: Color(0xff86fd00), borderRadius: radius),
//           ),
//         )
//       ],
//     );
//   }
// }
//
// class PointBallLayout extends StatefulWidget {
//   BoxConstraints constraints;
//   ValueChanged<PointBall> onTap;
//   List<PointBall> pointBallsList;
//   PointBallLayout({@required this.constraints, this.onTap, @required this.pointBallsList});
//
//   @override
//   _PointBallLayoutState createState() => _PointBallLayoutState();
// }
//
// class _PointBallLayoutState extends State<PointBallLayout> {
//   List<Widget> children;
//   Map<String, List<PointBall>> ballsMap = new Map();
//
//   ///能量球的位置固定
//   List<Offset> pointBallOffsets = [Offset(ws(340), hs(340)), Offset(ws(550), hs(440)), Offset(ws(730), hs(490))];
//   @override
//   void initState() {
//     final constraints = widget.constraints;
//     LogUtil.debug("_GreenPageState constraints $constraints");
//     widget.pointBallsList.forEach((ball) {
//       var behavior = ball.behavior;
//       if (ballsMap.containsKey(behavior)) {
//         ballsMap.update(behavior, (lastBalls) {
//           return lastBalls..add(ball);
//         });
//       } else {
//         ballsMap.putIfAbsent(behavior, () {
//           return [ball];
//         });
//       }
//     });
//     LogUtil.debug("_PointBallLayoutState length ${ballsMap?.length} ");
//     super.initState();
//   }
//
//   void buildChildren() {
//     children = <Widget>[];
//     var count = 0;
//     ballsMap.forEach((key, value) {
//       value.forEach((ball) {
//         var index = value.indexOf(ball);
//         Offset offset = pointBallOffsets[count];
//         var child;
//         child = Positioned(
//             top: offset.dy,
//             left: offset.dx,
//             child: PointBollWidget(
//               ball,
//               onTap: () {
//                 if (null != widget.onTap) {
//                   widget.onTap(ball);
//                 }
//               },
//               onTapDismiss: () {
//                 ballsMap.update(key, (listValue) {
//                   listValue.remove(ball);
//                   return listValue;
//                 });
//                 widget.pointBallsList.remove(ball);
//                 children.remove(ball);
//                 LogUtil.debug("ondismiss  ball $ball");
//
//                 setState(() {});
//               },
//               visible: 0 == index,
//             ));
//         children.add(child);
//       });
//       count++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     buildChildren();
//     LogUtil.debug("children $children");
//     return Stack(
//       children: children,
//     );
//   }
// }
//
// class PointBollWidget extends StatefulWidget {
//   PointBall pointBall;
//   VoidCallback onTap;
//   VoidCallback onTapDismiss;
//   bool visible;
//   PointBollWidget(this.pointBall, {this.onTap, this.onTapDismiss, Key key, this.visible = true}) : super(key: key);
//
//   @override
//   _PointBollWidgetState createState() => _PointBollWidgetState();
// }
//
// final pointBallWidth = ws(245);
// final pointBallFloatY = hs(50);
//
// class _PointBollWidgetState extends State<PointBollWidget> with TickerProviderStateMixin {
//   ///浮动
//   AnimationController _floatController;
//   CurveTween _tween;
//
//   ///点击
//   AnimationController onTapController;
//
//   ///出现
//   AnimationController _occurController;
//   CurveTween _occurTween;
//
//   @override
//   void initState() {
//     init();
//     super.initState();
//   }
//
//   void init() {
//     final value = Random.secure().nextDouble();
//     LogUtil.debug("_PointBollWidgetState initState value $value ball ${widget.pointBall}");
//     _floatController = AnimationController(vsync: this, duration: Duration(milliseconds: 2000), value: value);
//     _tween = CurveTween(curve: Curves.easeInOut);
//     _tween.animate(_floatController);
//     _floatController.addListener(() {
//       setState(() {});
//     });
//     _floatController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _floatController.reverse();
//       } else if (status == AnimationStatus.dismissed) {
//         _floatController.forward();
//       }
//     });
//     onTapController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
//     onTapController.addListener(() {
//       setState(() {});
//     });
//     onTapController.addStatusListener((status) {
//       if (status == AnimationStatus.completed && null != widget.onTapDismiss) {
//         widget.onTapDismiss();
//       }
//     });
//
//     _occurController = AnimationController(vsync: this, duration: Duration(milliseconds: 800));
//     _occurTween = CurveTween(curve: Curves.bounceOut);
//     _occurTween.animate(_occurController);
//     _occurController.addListener(() {
//       setState(() {});
//     });
//     _occurController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         startFloatAnimation(value);
//       }
//     });
//     _occurController.forward();
//   }
//
//   void startFloatAnimation(double value) {
//     if (value > 0.5) {
//       _floatController.forward();
//     } else {
//       _floatController.reverse();
//     }
//   }
//
//   @override
//   void didUpdateWidget(PointBollWidget oldWidget) {
//     LogUtil.debug("_PointBollWidgetState didUpdateWidget ==== ball ${widget.pointBall}");
//     LogUtil.debug(
//         "onTapController.value ${onTapController.value} _occurController ${_occurController.value} _floatController ${_floatController.value}");
//     if (onTapController.value == 1.0) {
//       onTapController.reset();
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void dispose() {
//     disposeAll();
//     super.dispose();
//   }
//
//   void disposeAll() {
//     _floatController.dispose();
//     onTapController.dispose();
//     _occurController.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var behavior = widget?.pointBall?.behavior;
//     var iconUrl = "";
//     switch (behavior) {
//       case PointBall.login:
//         //todo 第一期没有登录注册的积分
//         break;
//       case PointBall.like:
//         iconUrl = AllAssets.green_point_ball_like;
//         break;
//       case PointBall.browse_news:
//         iconUrl = AllAssets.green_point_ball_news;
//
//         break;
//       case PointBall.comment:
//         iconUrl = AllAssets.green_point_ball_comments;
//
//         break;
//       case PointBall.register:
//         break;
//       default:
//         LogUtil.warn("_PointBollWidgetState 没有该类型的积分球 pointBall ${widget?.pointBall}");
//         break;
//     }
//     LogUtil.debug(
//         "build  onTapController.value ${onTapController.value} widget.visible ${widget.visible} ball ${widget.pointBall}");
//     return Visibility(
//       visible: widget.visible,
//       child: GestureDetector(
//         onTap: () {
//           if (null != widget.onTap) {
//             widget.onTap();
//           }
//           _floatController.stop();
//           onTapController.forward();
//         },
//
//         ///出现时动画
//         child: Opacity(
//           opacity: _occurController.value,
//
//           ///消失位移
//           child: Opacity(
//             opacity: 1 - onTapController.value,
//             child: Transform.translate(
//               offset: Offset(0, -hs(200) * onTapController.value),
//
//               ///浮动位移
//               child: Transform.translate(
//                 offset: Offset(0, pointBallFloatY * _floatController.value),
//                 child: Stack(
//                   children: <Widget>[
//                     Container(
//                       width: pointBallWidth,
//                       height: pointBallWidth,
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(image: AssetImage(AllAssets.green_point_ball_bg), fit: BoxFit.fill)),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ImageBuilder.buildImage(iconUrl, width: ws(62), height: ws(55)),
//                           Padding(
//                             padding: EdgeInsets.symmetric(vertical: hs(3)),
//                             child: SizedBox(
//                               width: ws(95),
//                               height: hs(3),
//                               child: Divider(
//                                 color: Color(0xff47810b),
//                               ),
//                             ),
//                           ),
//                           Text(
//                             "${widget?.pointBall?.pointValue ?? 0}",
//                             style: TextStyle(color: Color(0xff47810b), fontSize: ss(31)),
//                           )
//                         ],
//                       ),
//                     ),
//                     Positioned.fill(
//                         child: Container(
//                       alignment: Alignment.bottomCenter,
//                       child: Text(
//                         "${formatDownTime()}",
//                         style: TextStyle(color: Color(0xff47810b), fontSize: ss(31)),
//                       ),
//                     ))
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   String formatDownTime() {
//     var result;
//     if (isEmpty(widget?.pointBall?.validMinutes)) {
//       result = "";
//     } else {
//       var time = int.parse(widget.pointBall.validMinutes);
//       var day = time ~/ Duration.minutesPerDay;
//       if (day == 2) {
//         result = "2 days";
//       } else if (3 == day) {
//         result = "3 days";
//       } else {
//         var lastMinutes = time - Duration.minutesPerDay * day;
//         var hour = lastMinutes ~/ Duration.minutesPerHour;
//         var minutes = lastMinutes % Duration.minutesPerHour;
//         result = "${TimeUtil.checkNum(hour)}:${TimeUtil.checkNum(minutes)}";
//       }
//     }
//     return result;
//   }
// }
//
// class AddPointsTransition extends StatefulWidget {
//   String points;
//   VoidCallback onComplete;
//
//   AddPointsTransition(this.points, {this.onComplete, Key key}) : super(key: key);
//
//   @override
//   _AddPointsTransitionState createState() => _AddPointsTransitionState();
// }
//
// class _AddPointsTransitionState extends State<AddPointsTransition> with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   static final transY = hs(40);
//   @override
//   void initState() {
//     _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
//     _controller.addListener(() {
//       setState(() {});
//     });
//     _controller.forward();
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed && null != widget.onComplete) {
//         widget.onComplete();
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: _controller.value < 1,
//       child: Transform.translate(
//         offset: Offset(0, -transY * _controller.value),
//         child: Opacity(
//           opacity: 1 - _controller.value,
//           child: Text(
//             "${widget.points ?? ""}",
//             style: TextStyle(color: Color(0xff087af9), fontSize: ss(35), fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// ///todo 关键修改  数组型layout 增加个数和更改某个依赖的数据更新情况---stless和stful的
// //@override
// //void didUpdateWidget(PointBollWidget oldWidget) {
// //  super.didUpdateWidget(oldWidget);
// //  LogUtil.debug(
// //      "_PointBollWidgetState didUpdateWidget oldWidget.visible ${oldWidget.visible}  widget.visible ${widget.visible}");
// //  if (!oldWidget.visible && widget.visible) {
// //    _occurController.reset();
// //    _occurController.forward();
// //  }
// //}
