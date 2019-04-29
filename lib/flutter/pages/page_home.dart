import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/Style.dart';
import 'package:flutterdemo/flutter/packages/annotationroute/annotation_route.dart';
import 'package:flutterdemo/flutter/packages/fish_redux/fish_redux_page.dart';
import 'package:flutterdemo/flutter/pages/beautiful/bottom_appbar.dart';
import 'package:flutterdemo/flutter/pages/beautiful/fold_cell.dart';
import 'package:flutterdemo/flutter/pages/beautiful/test_one_line_layout.dart';
import 'package:flutterdemo/flutter/pages/nativ/native_chat.dart';
import 'package:flutterdemo/flutter/pages/nativ/native_view_to_widget.dart';
import 'package:flutterdemo/flutter/widget/CheckBox.dart';
import 'package:flutterdemo/flutter/widget/Image.dart';
import 'package:flutterdemo/flutter/widget/animation/custom_curve.dart';
import 'package:flutterdemo/flutter/widget/animation/hero.dart';
import 'package:flutterdemo/flutter/widget/animation/jiaocuo.dart';
import 'package:flutterdemo/flutter/widget/animation/physics_animation.dart';
import 'package:flutterdemo/flutter/widget/animation/route_animation.dart';
import 'package:flutterdemo/flutter/widget/button.dart';
import 'package:flutterdemo/flutter/widget/container/box.dart';
import 'package:flutterdemo/flutter/widget/container/container_widget.dart';
import 'package:flutterdemo/flutter/widget/container/decorated_box.dart';
import 'package:flutterdemo/flutter/widget/container/padding.dart';
import 'package:flutterdemo/flutter/widget/container/transformation_widget.dart';
import 'package:flutterdemo/flutter/widget/customwidget/CanvasWidget.dart';
import 'package:flutterdemo/flutter/widget/customwidget/buttom_btn.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/clip_widget.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/dismissible.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/futurebuilder.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/inherited_widget.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/safe_area.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/will_pop_scope.dart';
import 'package:flutterdemo/flutter/widget/layout/flex.dart';
import 'package:flutterdemo/flutter/widget/layout/indexed_stack.dart';
import 'package:flutterdemo/flutter/widget/layout/rowcolumn.dart';
import 'package:flutterdemo/flutter/widget/layout/stack.dart';
import 'package:flutterdemo/flutter/widget/layout/wrap_flow.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/customscrollview.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/grid_view.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/list_view.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/scroll_notification.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/single_childs_croll_view.dart';
import 'package:flutterdemo/flutter/widget/sliver/sliver_app_bar.dart';
import 'package:flutterdemo/flutter/widget/switch.dart';
import 'package:flutterdemo/flutter/widget/text.dart';
import 'package:flutterdemo/flutter/widget/textfield.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "flutter",
      color: MyColor.primarySwatch,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///使用pageview (Viewport 的cacheExtent为0不缓存？？) 每次点击BottomNavigationBar都会触发initstate
    ///body 可使用[IndexedStack] --A [Stack] that shows a single child from a list of children. 从list选取一个children展示的stack
    ///IndexedStack 只绘制要展示index的child paintStack
    ///也可以自定义stack布局，使用offstage     Visibility 控制显示，自己加入动画来切换页面
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.PRIMARYCOLOR,
        title: Text("flutter"),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.deepPurple,
          currentIndex: 0,
          onTap: (index) {
            setState(() {
              _current = index;
            });
            print(index);
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.add), title: buildText(0)),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: buildText(1)),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: buildText(2)),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: buildText(3)),
            BottomNavigationBarItem(icon: Icon(Icons.add), title: buildText(4)),
          ]),
      body: SingleChildScrollView(
        key: Key("long_list"),
        child: Column(
          children: <Widget>[
            FlatButton(
                key: Key("FlatButton"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TextPage();
                  }));
                },
                child: Text(
                  "text",
                  key: Key("FlatButtonChild"),
                )),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ButtonPage();
                  }));
                },
                child: Text("button")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImagePage();
                  }));
                },
                child: Text("image")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SwitchPage();
                  }));
                },
                child: Text("switch")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CheckBoxPage();
                  }));
                },
                child: Text("CheckBox")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TextfieldPage();
                  }));
                },
                child: Text("textfield 输入框")),
            Text("layout ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RowAndColumnPage();
                  }));
                },
                child: Text("row column")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FlexPage();
                  }));
                },
                child: Text("flex")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StackPage();
                  }));
                },
                child: Text("stack")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IndexedStackPage();
                  }));
                },
                child: Text("IndexedStack")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WrapAndFlowPage();
                  }));
                },
                child: Text("wrap and flow")),
            Text("scroll ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SingleChildScrollViewPage();
                  }));
                },
                child: Text("SingleChildScrollView")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ListViewPage();
                  }));
                },
                child: Text("ListView")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GridViewPage();
                  }));
                },
                child: Text("GridView")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CustomScrollViewPage();
                  }));
                },
                child: Text("CustomScrollView")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SliverAppBarPage();
                  }));
                },
                child: Text("SliverAppBar")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ScrollNotificationPage();
                  }));
                },
                child: Text("滚动监听及控制")),
            Text("container ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaddingWidget();
                  }));
                },
                child: Text("padding")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BoxPage();
                  }));
                },
                child: Text("Sizedbox--ConstrainedBox")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DecoratedBoxPage();
                  }));
                },
                child: Text("DecoratedBox")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TransformationPage();
                  }));
                },
                child: Text("Transformation")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ContainerPage();
                  }));
                },
                child: Text("Container")),
            Text("function flutter.widget ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FutureBuilderPage();
                  }));
                },
                child: Text("FutureBuilder")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WillPopScopePage();
                  }));
                },
                child: Text("返回拦截")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return InheritedWidgetPage();
                  }));
                },
                child: Text("widget数据共享")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DismissiblePage();
                  }));
                },
                child: Text("DismissiblePage")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ClipWidget();
                  }));
                },
                child: Text("Clip Widget")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SafeAreaPage();
                  }));
                },
                child: Text("SafeArea Page")),
            Text("动画animation ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HeroPage();
                  }));
                },
                child: Text("共享动画hero")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return StaggerDemo();
                  }));
                },
                child: Text("交错")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RouteAnimationPage();
                  }));
                },
                child: Text("路由动画")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CustomCurvePage();
                  }));
                },
                child: Text("Custom Curve")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Physics_Animation();
                  }));
                },
                child: Text("Physics Animation")),
            Text("Canvas ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CanvasPage();
                  }));
                },
                child: Text("Canvas")),
            Text("与原生通信 MethodChannel----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MethodChannelPage();
                  }));
                },
                child: Text("flutter调用原生")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NativeWidgetPage();
                  }));
                },
                child: Text("原生 view转为flutter flutter.widget")),
            Text("酷炫效果和自定义----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BottomAppBarPage();
                  }));
                },
                child: Text("底部menu凹陷")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TestOneLineLayoutWidget();
                  }));
                },
                child: Text("测试 one line layout")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BottomBtnPage();
                  }));
                },
                child: Text("BottomBtn 适配底部")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FoldCellPage();
                  }));
                },
                child: Text("FoldCell 折叠")),
            Text("测试第三方包 ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AnnotationRoutePage1("");
                  }));
                },
                child: Text("咸鱼 annotation route")),
            FlatButton(
                key: Key("list_last"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FishReduxPageWidget();
                  }));
                },
                child: Text("咸鱼 fish_redux", key: Key("list_last_text"))),
          ],
        ),
      ),
    );
  }

  Text buildText(int current) {
    if (current == _current) {
      return Text("推荐", style: TextStyle(color: MyColor.PRIMARYCOLOR));
    } else {
      return Text("推荐", style: TextStyle(color: Colors.black));
    }
  }
}
