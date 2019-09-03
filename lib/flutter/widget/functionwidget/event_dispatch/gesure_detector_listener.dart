import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

///[GestureDetector]是一个用于手势识别的功能性Widget，我们通过它可以来识别各种手势，它是指针事件的语义化封装
///
///
/// 当同时监听onTap和onDoubleTap事件时，当用户触发tap事件时，会有200毫秒左右的延时，这是因为当用户点击完之后很可能会再次点击以触发双击事件，
/// 所以GestureDetector会等一段时间来确定是否为双击事件。如果用户只监听了onTap（没有监听onDoubleTap）事件时，则没有延时
///
///
/// GestureDetector 内部是GestureRecognizer的子类实现的，GestureRecognizer的作用就是通过Listener来将原始指针事件转换为语义手势，
/// GestureDetector直接可以接收一个子Widget。GestureRecognizer是一个抽象类，一种手势的识别器对应一个GestureRecognizer的子类
///
/// GestureRecognizer集成自[GestureArenaMember]表示参与竞技场的对象,用来解决手势竞争谁胜出
///
/// 调用完调用onScaleEnd后会调用onScaleStart,然后调用onScaleUpdate，并且ScaleUpdateDetails.scale变为1  scale开始，scale更新，scale结束，move开始，move更新，move结束
/// 调整scale的速率  //变化太快，变为原来的1、40    每次变化与1的差距，除以40
/// double orginScale = 1 + (ScaleUpdateDetails.scale - 1) / 40;
///
/// pan移动监听是scale监听的子集，ScaleUpdateDetails.scale为1.0是移动，不是1.0是scale
///
/// TODO 子组件实现GestureDetector后，父组件无法继续监听？？？
///
class GesureDetectorPage extends StatefulWidget {
  @override
  _GesureDetectorPageState createState() => _GesureDetectorPageState();
}

class _GesureDetectorPageState extends State<GesureDetectorPage> {
  String _operation = "No Gesture detected!"; //保存事件名
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0; //距左边的偏移
  double _top1 = 0.0; //距顶部的偏移
  double _left1 = 0.0; //距左边的偏移
  double _left2 = 0.0;
  double _left3 = 0.0;

  double _width = 200.0; //通过修改图片宽度来达到缩放效果
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  bool _toggle = false; //变色开关
  @override
  void dispose() {
    super.dispose();
    _tapGestureRecognizer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gesure Detector Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //点击，双击，长按
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                color: Colors.blue,
                width: 200.0,
                height: 100.0,
                child: Text(
                  _operation,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onTap: () => updateText("Tap"), //点击
              onDoubleTap: () => updateText("DoubleTap"), //双击
              onLongPress: () => updateText("LongPress"), //长按
            ),
            //
            // 拖动
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    left: _left,
                    top: _top,
                    child: GestureDetector(
                      child: CircleAvatar(child: Text("拖动")),
                      //手指按下时会触发此回调
                      onPanDown: (DragDownDetails e) {
                        //打印手指按下的位置(相对于屏幕)
                        print("用户手指按下：${e.globalPosition}");
                      },
                      //手指滑动时会触发此回调
                      onPanUpdate: (DragUpdateDetails e) {
                        //用户手指滑动时，更新偏移，重新构建
                        setState(() {
                          _left += e.delta.dx;
                          _top += e.delta.dy;
                        });
                      },
                      onPanEnd: (DragEndDetails e) {
                        //打印滑动结束时在x、y轴上的速度
                        print(e.velocity);
                      },
                      //监听竖直方向
                      onVerticalDragUpdate: (details) {
                        print(details.toString());
                      },
                    ),
                  ),
                ],
              ),
            ),
            //监听缩放
            GestureDetector(
              //指定宽度，高度自适应
              child: Image.asset(MyImgs.JINX, width: _width),
              onScaleUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  //缩放倍数在0.8到10倍之间
                  _width = 200 * details.scale.clamp(.8, 10.0);
                });
              },
            ),

            //测试GestureRecognizer
            Text.rich(TextSpan(children: [
              TextSpan(text: "你好世界"),
              TextSpan(
                text: "点我变色",
                style: TextStyle(fontSize: 30.0, color: _toggle ? Colors.blue : Colors.red),
                recognizer: _tapGestureRecognizer
                  ..onTap = () {
                    setState(() {
                      _toggle = !_toggle;
                    });
                  },
              ),
              TextSpan(text: "你好世界"),
            ])),

            //手势竞争
            //同时识别水平和垂直方向的拖动手势，当用户按下手指时就会触发竞争（水平方向和垂直方向），一旦某个方向“获胜”，则直到当次拖动手势结束都会沿着该方向移动
            //竞争发生在手指按下后首次移动（move）时，此例中具体的“获胜”条件是：首次移动时的位移在水平和垂直方向上的分量大的一个获胜
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    left: _left1,
                    top: _top1,
                    child: GestureDetector(
                      child: CircleAvatar(child: Text("拖动")),
                      //垂直方向拖动事件
                      onVerticalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          _top1 += details.delta.dy;
                        });
                      },
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          _left1 += details.delta.dx;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            //手势冲突
            //手势冲突只是手势级别的，而手势是对原始指针的语义化的识别，所以在遇到复杂的冲突场景时，都可以通过Listener直接识别原始指针事件来解决冲突

            //onTapUp和onHorizontalDragEnd发生冲突
            //在拖动时，刚开始按下手指时在没有移动时，拖动手势还没有完整的语义，此时TapDown手势胜出(win)，此时打印"down"，
            // 而拖动时，拖动手势会胜出，当手指抬起时，onHorizontalDragEnd 和 onTapUp发生了冲突，但是因为是在拖动的语义中，
            // 所以onHorizontalDragEnd胜出，所以就会打印 “onHorizontalDragEnd”
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    left: _left2,
                    top: 0,
                    child: GestureDetector(
                      child: CircleAvatar(child: Text("手势冲突拖动")),
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        setState(() {
                          _left2 += details.delta.dx;
                        });
                      },
                      onHorizontalDragEnd: (details) {
                        print("onHorizontalDragEnd");
                      },
                      onHorizontalDragStart: (e) {
                        print("onHorizontalDragStart");
                      },
                      onTapDown: (details) {
                        print("down");
                      },
                      onTapUp: (details) {
                        print("up");
                      },
                    ),
                  ),
                ],
              ),
            ),

            //如果我们的代码逻辑中，对于手指按下和抬起是强依赖的，比如在一个轮播图组件中，我们希望手指按下时，暂停轮播，而抬起时恢复轮播，
            // 但是由于轮播图组件中本身可能已经处理了拖动手势（支持手动滑动切换），甚至可能也支持了缩放手势，
            // 这时我们如果在外部再用onTapDown、onTapUp来监听的话是不行的。这时我们应该怎么做？其实很简单，通过Listener监听原始指针事件就行
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    left: _left3,
                    top: 0,
                    child: Listener(
                      onPointerDown: (e) {
                        print("onPointerDown");
                      },
                      onPointerUp: (e) {
                        print("onPointerUp");
                      },
                      child: GestureDetector(
                        child: CircleAvatar(child: Text("手势冲突拖动")),
                        onHorizontalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            _left3 += details.delta.dx;
                          });
                        },
                        onHorizontalDragEnd: (details) {
                          print("onHorizontalDragEnd");
                        },
                        onHorizontalDragStart: (e) {
                          print("onHorizontalDragStart");
                        },
                        onTapDown: (details) {
                          print("down");
                        },
                        onTapUp: (details) {
                          print("up");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateText(String text) {
    //更新显示的事件名
    setState(() {
      _operation = text;
    });
  }
}
