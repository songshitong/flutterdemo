//所有Material 库中的按钮都有如下相同点：
//1按下时都会有“水波动画”。
//2有一个onPressed属性来设置点击回调，当按钮按下时会执行该回调，如果不提供该回调则按钮会处于禁用状态，禁用状态不响应用户点击。
import 'package:flutter/material.dart';

//Material widget库中提供了多种按钮Widget如RaisedButton、FlatButton、OutlineButton等，
//它们都是直接或间接对RawMaterialButton的包装定制，所以他们大多数属性都和RawMaterialButton一样
//所有Material 库中的按钮都有如下相同点：
//按下时都会有“水波动画”。
//有一个onPressed属性来设置点击回调，当按钮按下时会执行该回调，如果不提供该回调则按钮会处于禁用状态，禁用状态不响应用户点击。

//TODO material button最小边距  修改主题或自定义按钮
class ButtonPage extends StatefulWidget {
  @override
  ButtonPageState createState() {
    return new ButtonPageState();
  }
}

class ButtonPageState extends State<ButtonPage> {
  bool _isClickable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("button"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              _isClickable = !_isClickable;
              setState(() {});
            },
            child: Text(_isClickable ? "按钮可以点击" : "按钮不可以点击"),
          ),

          ///RaisedButton 即"漂浮"按钮，它默认带有阴影和灰色背景。按下后，阴影会变大
          RaisedButton(
            onPressed: () {},
            child: Text("RaisedButton"),
            elevation: 5,
            highlightElevation: 25,
            animationDuration: Duration(milliseconds: 10000),

            ///Defines the duration of animated changes for [shape] and [elevation].
          ),

          ///FlatButton即扁平按钮，默认背景透明并不带阴影。按下后，会有背景色
          FlatButton(onPressed: () {}, child: Text("FlatButton")),

          ///OutlineButton默认有一个边框，不带阴影且背景透明。按下后，边框颜色会变亮、同时出现背景和阴影(较弱)
          ///todo 改变样式
          OutlineButton(
            onPressed: _isClickable ? () {} : null,
            child: Text("OutlineButton"),
            disabledBorderColor: Colors.red, //禁用状态边框颜色
            highlightedBorderColor: Colors.greenAccent, //按下时边框颜色
            clipBehavior: Clip.antiAlias,
            borderSide: BorderSide(color: Colors.black, width: 2.0, style: BorderStyle.solid), //边框样式
          ),

          ///IconButton是一个可点击的Icon，不包括文字，默认没有背景，点击后会出现背景：
          IconButton(icon: Icon(Icons.add), onPressed: () {}),

          ///设置其他属性
          FlatButton(
            onPressed: _isClickable ? () {} : null,
            child: Text(
              "custom style",
//              style: TextStyle(color: Colors.yellow),
            ),
            color: Colors.black12,
            textColor: Colors.green, //设置文字颜色,可以和textstyle同时设置，textstyle颜色生效，水波纹颜色接近textcolor
            highlightColor: Colors.amberAccent, //按钮按下时的颜色
            splashColor: Colors.greenAccent, //水波动画颜色
            colorBrightness: Brightness.dark, //按钮主题，默认是浅色主题 ，其他深色主题
            disabledTextColor: Colors.purple, //不可点击文字颜色, 设置textstyle后该属性不生效
            disabledColor: Colors.brown, //不可点击时背景色
            padding: EdgeInsets.only(left: 5, top: 10, right: 15, bottom: 20), //设置按钮填充即内边距
            shape: RoundedRectangleBorder(
                // 设置背景形状 todo ShapeBorder
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(20))),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text("elevation"),
            elevation: 5, // 正常状态下阴影
            disabledElevation: 10, //不可点击状态下阴影
            highlightElevation: 15, //按下时阴影
          ),
          Text("改变material默认的padding ----------------------------"),
          //1 customize ButtonTheme for ButtonBar
          //2 use Row instead of ButtonBar    整体没变？？
          //3 implement your own button via InkWell     material中InkWell让材料产生水波纹效果
          //etc
          new ButtonTheme(
            minWidth: 44.0,
            padding: new EdgeInsets.all(0.0),
            child: new ButtonBar(children: <Widget>[
              new FlatButton(
                child: new Text("Button 1"),
                onPressed: () => debugPrint("Button 1"),
              ),
              new FlatButton(
                child: new Text("Button 2"),
                onPressed: () => debugPrint("Button 2"),
              ),
            ]),
          ),
          new Row(
            children: <Widget>[
              new FlatButton(
                color: Colors.red,
                padding: EdgeInsets.all(0),
                child: new Text("Button 1"),
                onPressed: () => debugPrint("Button 1"),
              ),
              new FlatButton(
                child: new Text("Button 2"),
                onPressed: () => debugPrint("Button 2"),
              ),
            ],
          ),
          new Row(
            children: <Widget>[
              new InkWell(
                child: new Text("Button 1"),
                onTap: () => debugPrint("Button 1"),
              ),
              new InkWell(
                child: new Text("Button 2"),
                onTap: () => debugPrint("Button 2"),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {},
            child: Text("float"),
            //设置FloatingActionButton的形状
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          DropdownButton(
            hint: Text("DropdownButton"),
            onChanged: (index) {},
            items: <DropdownMenuItem<int>>[
              DropdownMenuItem(child: Text("DropdownButton1"), value: 1),
              DropdownMenuItem(child: Text("DropdownButton2"), value: 2),
            ],
          )
        ],
      ),
    );
  }
}
