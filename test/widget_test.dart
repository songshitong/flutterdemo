import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //1  添加依赖
//  dev_dependencies:
//  flutter_test:
//  sdk: flutter
  //2 创建用来测试widget   为widget提供运行上下文
  //3 使用testWidgets来测试widget   testWidgets提供WidgetTester来创建widget
  //4 通过WidgetTester调用pumpWidget来创建和绘制widget  调用后上一次创建的就失效了
  //5 通过finder来查找widget     通过find.text来创建finder
  //6 通过Matcher来验证widget工作，
  testWidgets("test btn", (WidgetTester tester) async {
    await tester.pumpWidget(MyWidget(title: "title", message: "msg"));

    //使用StatefulWidget或动画时，通过tester.pump() 和tester.pumpAndSettle()来重建widget
    //tester.pump   给定时间后重建widget
    // tester.pumpAndSettle   在给定的持续时间内反复调用pump，直到不再安排任何帧。这基本上等待所有动画完成

    //找到显示文字是title的widget
    final titleFinder = find.text('title');
    Text title = tester.firstWidget(titleFinder);

    ///widget的显示
    title.data;
    expect(titleFinder, findsOneWidget);
    //找到指定key的widget
    final centerFinder = find.byKey(Key("center"));
    expect(centerFinder, findsOneWidget);

    //查找特定的widget实例
    final childWidget = Padding(padding: EdgeInsets.zero);
    // Provide our childWidget to the Container    tester.pumpWidget绘制给定的widget
    await tester.pumpWidget(Container(child: childWidget));
    expect(find.byWidget(childWidget), findsOneWidget);

    //查找特定类型的widget
    await tester.pumpWidget(MyWidget(title: "title", message: "msg"));
    final typeFinder = find.byType(AppBar);
    expect(typeFinder, findsOneWidget);

    expect(titleFinder, isNotInCard);

    //测试tap
    final btnFinder = find.byType(FlatButton);
    await tester.tap(btnFinder);
    //点击后触发重建
    await tester.pump();
    expect(find.text("m"), findsOneWidget);

    //测试EnterText
    final textFieldFinder = find.byType(TextField);
    await tester.enterText(textFieldFinder, "textField");
    await tester.pump();
    expect(find.text("textField"), findsOneWidget);

    //测试drag
    final dismissFinder = find.byType(Dismissible);
    await tester.drag(dismissFinder, Offset(5000.0, 0.0));
    await tester.pumpAndSettle();
    expect(find.text("this is dismissble"), findsNothing);

    //matcher
//    findsOneWidget    该widget只出现一次
    //  findsNothing     没有widget出现
    //findsWidgets      一个或多个widget出现
    //findsNWidgets     具体几个widget出现
    //isNotInCard       widget没有card祖先
  });
}

class MyWidget extends StatefulWidget {
  final String title;
  String message;

  MyWidget({
    Key? key,
    this.title = "",
    this.message = "",
  }) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Center(
              key: Key("center"),
              child: Text(widget.message),
            ),
            FlatButton(
                onPressed: () {
                  setState(() {
                    widget.message = "m";
                  });
                },
                child: Text(
                  "change message to m",
                  key: Key("message"),
                )),
            TextField(),
            Dismissible(
                key: Key("dismissble"), child: Text("this is dismissble")),
          ],
        ),
      ),
    );
  }
}
