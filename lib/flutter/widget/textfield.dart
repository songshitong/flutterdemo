import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextfieldPage extends StatefulWidget {
  @override
  _TextfieldPageState createState() => _TextfieldPageState();
}

//todo ToolbarOptions
///todo TextCapitalization
class _TextfieldPageState extends State<TextfieldPage> {
  FocusNode fn;
  TextEditingController controller;
  TextEditingController controllerFocus;

  @override
  void initState() {
    super.initState();
    fn = FocusNode();
    fn.addListener(() {
      //监听焦点的获得，失去
      print("fn hasfocus ${fn.hasFocus}");
    });
    controller = TextEditingController();
    controllerFocus = TextEditingController();
    controllerFocus.addListener(() {
      if (controllerFocus.text.length >= 5) {
        fn.unfocus();
      }
    });
    controller.addListener(() {
      print("textfield ${controller.text}");
    });
  }

  ///todo EditableTextState.requestKeyboard()
  ///todo RawKeyboardListener
  ///
  ///TODO 监听软键盘的完成后是否会造成自己代码的重绘，此时数据改变会自动重绘布局
  /// 重绘的话，build中的分页会重建？？
  ///
  ///
  /// 控件跟随软键盘上移，scorllview ，stack设置top而不是bottom
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("textfield 输入框"),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          TextField(
            decoration: InputDecoration.collapsed(hintText: "默认没有边框,内容边距为0"),
          ),
          TextField(
            obscureText: true, // 是否用点替代文字，密码隐藏
            keyboardType: TextInputType.number, //设置键盘类型  text等
            textInputAction: TextInputAction.search, //键盘enter键的类型
            controller: controller,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autocorrect: false, //是否自动更正 键盘上面的提示
              enabled: true, //是否可用
              onTap: () {
                print("ontap "); // 点一次就触发
              },
              onSubmitted: (str) {
                print('onsubmitted str $str');
              },
              onChanged: (str) {
                print('onchanged str $str');
              },
              style: TextStyle(color: Colors.purple), //字体样式
              textAlign: TextAlign.end, // 文字对齐 center  hinttext一样生效
              textDirection: TextDirection.rtl, //文字书写方向，从右到左
              maxLines: 3,
              decoration: InputDecoration(
                hintMaxLines: 3, //设置hint最大行数
                suffixText: "suffixtext", //右侧提醒文字
                suffixIcon: IconButton(
                    // 点击icon会自动激活输入框，目前没有办法拦截
                    icon: Icon(Icons.print),
                    onPressed: () {
                      print("suffixIcon click");
                    }),
                errorText: "error text", //标红，占据helpertext位置
                helperText: "helper",
                helperStyle: TextStyle(inherit: false, color: Colors.yellow),
                icon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      print("icon click");
                    }),
                labelText: "lable",
                hintText: "测试hint测试hint测试hint测试hint测试\n hint测试hint测试hint测试hint测试hint测试hint测试hint",
                hintStyle: TextStyle(inherit: false, color: Colors.green),
                prefixText: "frefix text", //内容前面
                prefixIcon: IconButton(
                    icon: Icon(Icons.hearing),
                    onPressed: () {
                      print("prefix click");
                    }),
                //内容为multiline多行时，居中对齐
                alignLabelWithHint: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "有边框",
                //border不生效，查看theme和border，enableborder，focusborder等 ,源码也有相关注释
                border: OutlineInputBorder(
                    gapPadding: 8,
                    borderSide: BorderSide(style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5))), //边框样式
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5, //输入框 maxlenth 后会出现计数，可以用inputFormatters来代替然后限制长度不占空间
              decoration: InputDecoration(
                  counterText: "counter：", //计数文字
                  //semanticCounterText If provided, this replaces the semantic label of the [counterText].
                  semanticCounterText: "semanticCounterText",
                  counterStyle: TextStyle(color: Colors.red),
                  contentPadding: EdgeInsets.all(10), // 内容边距
                  //用于控制TextField的外观显示，如提示文本、背景颜色、边框等
                  border: InputBorder.none, //去掉边框
                  fillColor: Colors.black26, //背景色
                  filled: true), //是否用颜色填充，false背景色不生效
              cursorColor: Colors.red,
              cursorWidth: 5,
              cursorRadius: Radius.circular(5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controllerFocus,
              focusNode: fn, //焦点
              autofocus: true,
              decoration: InputDecoration(hintText: "限制数字,大于5个失去焦点，键盘隐藏"),
              inputFormatters: [
                LengthLimitingTextInputFormatter(5), // 长度限制为5
                BlacklistingTextInputFormatter(RegExp("[0-9]")), //限制数字
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[\u4e00-\u9fa5]|[0-9]")) //字母 汉字，数字
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(hintText: "只有数字"),
              inputFormatters: [
                WhitelistingTextInputFormatter(RegExp("[0-9]")), //只有数字
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  ////减少按高度 当嵌入添加的容器中时，非常有用 , TODO 设置textfield高度，isDense的效果
                  isDense: true,
                  filled: true,
                  fillColor: Colors.black26,
                  hintText: "isDense"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(isDense: false, filled: true, fillColor: Colors.black26, hintText: "isDense"),
            ),
          ),
          //todo form 表单
          //todo 多行高度有问题，官网待修复    可以用 Container(
          //            constraints: BoxConstraints(maxHeight: 100)）来限制
          //TODO 键盘弹起页面滚动 EditableText  didChangeMetrics editableKey.currentContext.findRenderObject().showOnScreen
          //     scaffold 控制页面弹不弹起的原理 MediaQuery  MediaQueryData.removeViewInsets
          //     WidgetsApp 注册WidgetsBindingObserver，build使用MediaQuery，将window数据共享？？
        ]),
      ),
    );
  }
}
