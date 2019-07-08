import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/pages/page_home.dart';

//Material Design 设计规范中有些是不能自定义的，如导航栏高度，ThemeData只包含了可自定义部分。
//ThemeData({
//Brightness brightness, //深色还是浅色
//MaterialColor primarySwatch, //主题颜色样本，见下面介绍
//Color primaryColor, //主色，决定导航栏颜色
//Color accentColor, //次级色，决定大多数Widget的颜色，如进度条、开关等。
//Color cardColor, //卡片颜色
//Color dividerColor, //分割线颜色
//ButtonThemeData buttonTheme, //按钮主题
//Color cursorColor, //输入框光标颜色
//Color dialogBackgroundColor,//对话框背景颜色
//String fontFamily, //文字字体
//TextTheme textTheme,// 字体主题，包括标题、body等文字样式
//IconThemeData iconTheme, // Icon的默认样式
//TargetPlatform platform, //指定平台，应用特定平台控件风格
//})

//可以通过局部主题覆盖全局主题，正如代码中通过Theme为第二行图标指定固定颜色（黑色）一样，这是一种常用的技巧，
//Flutter中会经常使用这种方法来自定义子树主题。
//那么为什么局部主题可以覆盖全局主题？这主要是因为Widget中使用主题样式时是通过Theme.of(BuildContext context)来获取的，我们看看其简化后的代码：
//
//static ThemeData of(BuildContext context, { bool shadowThemeOnly = false }) {
//// 简化代码，并非源码
//return context.inheritFromWidgetOfExactType(_InheritedTheme)
//}
//context.inheritFromWidgetOfExactType 会在widget树中从当前位置向上查找第一个类型为_InheritedTheme的Widget。
//所以当局部使用Theme后，其子树中Theme.of()找到的第一个_InheritedTheme便是该Theme的

///模拟换色   全句换色查看[HomePage]，修改MaterialApp的theme属性
class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  Color _themeColor; //当前路由主题色
  bool firstBuild = false;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    if (!firstBuild) {
      _themeColor = themeData.primaryColor;
      firstBuild = true;
    }
//    print("themeData $themeData");
    return Theme(
      data: ThemeData(
          primarySwatch: _themeColor, //用于导航栏、FloatingActionButton的背景色等
          iconTheme: IconThemeData(color: _themeColor) //用于Icon颜色
          ),
      child: Scaffold(
        appBar: AppBar(title: Text("主题测试")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //第一行Icon使用主题中的iconTheme
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Icon(Icons.favorite), Icon(Icons.airport_shuttle), Text("  颜色跟随主题")]),
            //为第二行Icon自定义颜色（固定为黑色)
            Theme(
              data: themeData.copyWith(
                iconTheme: themeData.iconTheme.copyWith(color: Colors.black),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.favorite), Icon(Icons.airport_shuttle), Text("  颜色固定黑色")]),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => //切换主题
                setState(() => _themeColor = _themeColor == Colors.teal ? Colors.blue : Colors.teal),
            child: Icon(Icons.palette)),
      ),
    );
  }
}
