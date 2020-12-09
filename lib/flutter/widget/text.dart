import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextPage extends StatelessWidget {
  static const routeName = "TextPage";
  TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () => print('TapGestureRecognizer onTap');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "text",
          key: Key("TextPageTitle"),
        ),
        automaticallyImplyLeading: false,
        leading: BackButton(
          key: Key("BackBtn"),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///todo 通过constrainBox 限制text的展示区域   maxheight double.infinity
            ///
            /// DefaultTextStyle 控制字体
            Text(
              " text " * 14, textAlign: TextAlign.right,
              //在text内，文字的对齐,只有Text宽度大于文本内容长度时指定此属性才有意义,小于一行时，text和内容宽度相等
              style: TextStyle(shadows: [
                Shadow(color: Colors.blue, blurRadius: 2, offset: Offset(5, 5))
                //设置阴影 蓝色， blurRadius模糊度，值越大越模糊，offfset阴影的偏移位置
              ]),
            ),
            Text(
              " text " * 14,
              maxLines: 1, // 设置显示的最大行数  指定文本显示的最大行数，默认情况下，文本是自动折行的
              overflow: TextOverflow.ellipsis, // 超出用...
            ),
            Text(
              " text " * 14, maxLines: 1, // 设置显示的最大行数
              overflow: TextOverflow.clip, // 超出截断
            ),
            Text(
              " text " * 14, maxLines: 1, // 设置显示的最大行数
              overflow: TextOverflow.fade, // 超出隐藏效果
            ),
            Text(
              " text ", textScaleFactor: 1.5, //缩放
            ),
            Text(
              " text &nbsp text2" * 5,
              softWrap:
                  false, //关闭自动换行，满一行后截断    软换行处中断，flase 文本中的符号将被定位为没有限制的水平空间
            ),
            Text(r'$$', semanticsLabel: 'Double dollars'),
            //文本的另一种语义标签,这对于将缩写词或短词替换为全词很有用
            Text('hhhhhhhhhhh China',
                style: TextStyle(
                  inherit: true,
                  color: Colors.blue,
                  //颜色   和foreground只能设置一个
                  fontSize: 18.0,
                  //字体大小
                  height: 1.2,
                  //该属性用于指定行高，但它并不是一个绝对值，而是一个因子，具体的行高等于fontSize*height,行高，行间距
                  fontFamily: "Courier",
                  //字体集
                  background: new Paint()..color = Colors.yellow,
                  //背景
                  decoration: TextDecoration.underline,
                  //下划线
                  decorationStyle: TextDecorationStyle.dashed,
                  // 虚线
                  fontStyle: FontStyle.italic,
                  //斜体
                  fontWeight: FontWeight.w800,
                  // 加粗
                  letterSpacing: 5,
                  // 字母间距
                  wordSpacing: 10,
                  //单词间距
                  textBaseline: TextBaseline
                      .ideographic, //ideographic表意，alphabetic按字母顺序 应在此文本范围与其之间对齐的公共基线父文本span，或者，对于根文本span，使用行框
                )),
            Text('hhhhhhhhhhh',
                style: TextStyle(
                  decoration: TextDecoration.overline, //上划线
                  decorationStyle: TextDecorationStyle.dotted, //虚点
                )),
            Text('hhhhhhhhhhh',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough, //删除线
                  decorationStyle: TextDecorationStyle.wavy, //波浪线
                )),
            Text('hhhhhhhhhhh',
                style: TextStyle(
                  decoration: TextDecoration.underline, //删除线
                  decorationStyle: TextDecorationStyle.double, //双线
                )),
            Text('hhhhhhhhhhh',
                style: TextStyle(
                  decoration: TextDecoration.underline, //删除线
                  decorationStyle: TextDecorationStyle.solid, //实现
                )),
            Text.rich(
              //一段文字，多种格式
              TextSpan(
                text: 'Hello', // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: ' beautiful ',
                      style: TextStyle(
                          color: Colors.blue, fontStyle: FontStyle.italic)),
                  TextSpan(
                    text: 'world',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),

            ///RichText 默认不使用theme的主题，最好使用DefaultTextStyle.of(context).style来集成默认样式
            ///Text.rich() 默认使用theme主题
            RichText(
              // 富文本
              text: TextSpan(
                text: 'Hello ',
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: 'bold',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: ' world!',
                      //事件由RichText的RenderParagraph的handleEvent分发事件,直接使用canvas没有事件分发，recognizer不会响应事件
                      //InlineSpan也不管理recognizer的声明周期，InlineSpan不使用后必须调用GestureRecognizer.dispose
                      recognizer: _recognizer),
                ],
              ),
            ),
            //在widget树中，文本的样式默认是可以被继承的，因此，如果在widget树的某一个节点处设置一个默认的文本样式，那么该节点的子树中所有文本都会默认使用这个样式，而DefaultTextStyle正是用于设置默认文本样式的
//        //inherit: false 不继承默认样式
            RichText(
              // 富文本
              text: TextSpan(
                text: 'Hello ',
                style: TextStyle(
                    inherit: false,
                    fontWeight: FontWeight.w500,
                    color: Colors.red),
                children: <TextSpan>[
                  TextSpan(
                      text: 'bold',
                      style: TextStyle(
                          inherit: false,
                          fontWeight: FontWeight.w500,
                          color: Colors.red)),
                  TextSpan(text: ' world!'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                "select 11111111",
                onTap: () {
                  print("SelectableText tap ==== ");
                },
                toolbarOptions: ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                "select 2222222",
                toolbarOptions: ToolbarOptions(
                    copy: true, cut: true, paste: true, selectAll: true),
              ),
            ),
            Text(
              "测试空格(flutter在空格处换行):  asfafdasdfasdfasdfasdfasdfadfasfa;fsja;dfja;fdjakd;fadafdfdafsd",
              maxLines: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "测试空格:  asfafdasdfasdfasdfasdfasdfadfasfa;fsja;dfja;fdjakd;fadafdfdafsd",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Row(
              children: <Widget>[
                Text("测试空格:"),
                SizedBox(
                  width: 200,
                  child: Text(
                    "asfafdasdfasdfasdfasdfasdfadfasfa;fsja;dfja;fdjakd;fadafdfdafsd",
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                print("GestureDetector->SelectableText tap");
              },
              child: SelectableText.rich(
                TextSpan(
                    text: "span SelectableText ",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        print("SelectableText->TextSpan tap");
                      },
                    children: <InlineSpan>[
                      TextSpan(
                          text: "11111 ",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("1 tap");
                            },
                          children: <InlineSpan>[
                            TextSpan(
                                text: "22222 ",
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print("2 tap");
                                  },
                                children: <InlineSpan>[
                                  TextSpan(text: "", children: <InlineSpan>[
                                    TextSpan(
                                        text: "4444",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            print("4 tap");
                                          })
                                  ]),
                                  TextSpan(
                                      text: "3333",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          print("3 tap");
                                        })
                                ])
                          ])
                    ]),
                onTap: () {
                  print("SelectableText tap");
                },
              ),
            ),
            Tooltip(
                message: "This is a ToolTip!!!",
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text("ToolTip"))),
          ],
        ),
      ),
    );
  }
}
