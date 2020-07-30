import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutterdemo/flutter/common/SingleLonData.dart';
import 'package:flutterdemo/flutter/common/Style.dart';
import 'package:flutterdemo/flutter/native_plugin/ffmpeg/ffmpeg_page.dart';
import 'package:flutterdemo/flutter/native_plugin/ffmpeg/movie_audio_replace.dart';
import 'package:flutterdemo/flutter/native_plugin/share/share_sdk.dart';
import 'package:flutterdemo/flutter/native_plugin/video/video_player.dart';
import 'package:flutterdemo/flutter/native_plugin/webview_page.dart';
import 'package:flutterdemo/flutter/packages/annotationroute/annotation_route.dart';
import 'package:flutterdemo/flutter/packages/provider/providertest.dart';
import 'package:flutterdemo/flutter/pages/beautiful/ali_pay_anim.dart';
import 'package:flutterdemo/flutter/pages/beautiful/bottom_appbar.dart';
import 'package:flutterdemo/flutter/pages/beautiful/fold_cell.dart';
import 'package:flutterdemo/flutter/pages/beautiful/gallery/sliver_section.dart';
import 'package:flutterdemo/flutter/pages/beautiful/pageview_page.dart';
import 'package:flutterdemo/flutter/pages/beautiful/test_one_line_layout.dart';
import 'package:flutterdemo/flutter/services/system_chrome.dart';
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
import 'package:flutterdemo/flutter/widget/customwidget/GifFileImg.dart';
import 'package:flutterdemo/flutter/widget/customwidget/buttom_btn.dart';
import 'package:flutterdemo/flutter/widget/customwidget/capture_screen.dart';
import 'package:flutterdemo/flutter/widget/customwidget/path.dart';
import 'package:flutterdemo/flutter/widget/customwidget/proxy_render_obj.dart';
import 'package:flutterdemo/flutter/widget/customwidget/scroll_physics.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/appbar_test.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/blur.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/borders_about.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/bottom_navigator.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/clip_widget.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/dismissible.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/draggable_page.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/drawer_page.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/event_dispatch/gesure_detector_listener.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/event_dispatch/notification.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/event_dispatch/pointer_listener.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/futurebuilder.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/inherited_widget.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/international/intl_page.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/refresh_indicator.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/safe_area.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/table_cell.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/theme_demo.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/visibility_test.dart';
import 'package:flutterdemo/flutter/widget/functionwidget/will_pop_scope.dart';
import 'package:flutterdemo/flutter/widget/layout/flex.dart';
import 'package:flutterdemo/flutter/widget/layout/indexed_stack.dart';
import 'package:flutterdemo/flutter/widget/layout/rowcolumn.dart';
import 'package:flutterdemo/flutter/widget/layout/stack.dart';
import 'package:flutterdemo/flutter/widget/layout/wrap_flow.dart';
import 'package:flutterdemo/flutter/widget/nativ/native_chat.dart';
import 'package:flutterdemo/flutter/widget/nativ/native_view_to_widget.dart';
import 'package:flutterdemo/flutter/widget/radio_page.dart';
import 'package:flutterdemo/flutter/widget/route/routepage.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/customscrollview.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/grid_view.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/list_view.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/listview_memory.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/scroll_notification.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/single_childs_croll_view.dart';
import 'package:flutterdemo/flutter/widget/sliver/custom_sliver_list.dart';
import 'package:flutterdemo/flutter/widget/sliver/nested_scroll_view_page.dart';
import 'package:flutterdemo/flutter/widget/sliver/sliver_app_bar.dart';
import 'package:flutterdemo/flutter/widget/switch.dart';
import 'package:flutterdemo/flutter/widget/text.dart';
import 'package:flutterdemo/flutter/widget/textfield.dart';
import 'package:path_provider/path_provider.dart';

import 'beautiful/change_overlay.dart';
import 'beautiful/circle_to_rectangle.dart';
import 'beautiful/drops.dart';
import 'beautiful/image_preview.dart';
import 'beautiful/model3d/3d_widget.dart';
import 'beautiful/reorder_list.dart';
import 'beautiful/shimmer_wiget.dart';
import 'custom_popup_page.dart';
import 'principle/widget_update.dart';

//todo 重构路由 支持搜索（大小写模糊），支持滚动到底部，滚动到顶部
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//extension WidgetPadding on Widget {
//  Widget paddingAll(double padding) => Padding(padding: EdgeInsets.all(padding), child: this);
//}

class _HomePageState extends State<HomePage> {
  ///切换主题
  bool isDark = false;
  final locals = [
    const Locale('zh', 'CN'),
    const Locale('en', 'US'), // 美国英语
  ];
  var localeIndex = 0;

  ///切换颜色
  Color color = Colors.amber;
  @override
  void initState() {
    getTemporaryDirectory().then((tempPath) {
      SingleLonData().tempPath = tempPath.path;
      print("tempPath.path ${tempPath.path}");
    });
    getApplicationDocumentsDirectory().then((appDocDir) {
      SingleLonData().appDocDir = appDocDir.path;
      print("appDocDir.path ${appDocDir.path}");
    });
    print("language ${WidgetsBinding.instance.window.locales} ====");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ///自定义errwidget,测试时在测试widget抛出异常就可以 throw Exception("error");
    ///判断是否是release mode
    if (kReleaseMode) {
      ErrorWidget.builder = (context) {
        return SizedBox.shrink();
      };
    }

    var defaultPlatform = defaultTargetPlatform;
    var androidTheme = ThemeData.light();

    //https://www.w3schools.com/colors/colors_picker.asp 根据主色自动生成色系
    ///Android变色
    if (defaultPlatform == TargetPlatform.android) {
      androidTheme = ThemeData(
          primaryColor: color,
          //设置长按提示 设置位置，文字设置重写CustomLocalizations,showDuration长按结束停留的时间，消失？设置位移遮挡吧
          tooltipTheme: TooltipThemeData(showDuration: Duration.zero),
          brightness: isDark ? Brightness.dark : Brightness.light,
          //设置全局的页面切换效果 ios 左右  Android默认上下
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          }));
    }
    return RawGestureDetector(
      gestures: <Type, GestureRecognizerFactory>{
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          () => TapGestureRecognizer(),
          (TapGestureRecognizer instance) {
            instance
              ..onTapDown = (TapDownDetails details) {}
              ..onTapUp = (TapUpDetails details) {}
              ..onTap = () {
                ///监听不到，
                print("全局点击事件=======  onTap");
              }
              ..onTapCancel = () {};
          },
        ),
      },
      child: Listener(
        onPointerMove: (e) {
//          setState(() {});
        },
        onPointerDown: (PointerDownEvent e) {
          print("全局点击事件============  down position ${e.position}");
        },
        onPointerUp: (PointerUpEvent e) {
          print("全局点击事件============  up position ${e.position}");
        },
        child: MaterialApp(
//           禁用系统的字体缩放
            builder: (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child,
              );
            },
            title: "flutter",
            theme: androidTheme,

            ///设置支持的语言 只有设置支持的语言才会初始化[CustomLocalizations] load传入对应的语言，默认local是英文
            ///ios 需要在project->info->localizations 增加支持的语言才起作用
            supportedLocales: locals,
            //手动指定locale
            locale: locals[localeIndex],
            localizationsDelegates: <LocalizationsDelegate>[
              // 本地化的代理类
              ///Material 风格组件的国际化
              GlobalMaterialLocalizations.delegate,

              ///Cupertino风格组件的国际化
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              CustomLocalizations.delegate
            ],
            localeListResolutionCallback: (locales, supportedLocales) {
              //监听语言改变https://flutter.github.io/assets-for-api-docs/assets/widgets/form.png
              print(
                  "localeListResolutionCallback locales $locales supportedLocales $supportedLocales");
            },
            localeResolutionCallback: (locale, supportedLocales) {
              //监听语言改变
//        如果locale为null，则表示Flutter未能获取到设备的Locale信息，所以我们在使用locale之前一定要先判空
              print(
                  "localeResolutionCallback locale $locale supportedLocales $supportedLocales");
            },

            ///todo 配置路由名字
//            routes: ,
            darkTheme: androidTheme,
            themeMode: ThemeMode.dark,
            navigatorObservers: [MNavigatorObserber()],
//            onGenerateRoute: (RouteSettings settings) {
//                可以对路由拦截处理
//              WidgetBuilder builder;
//              if (settings.name == '/') {
//                builder = (BuildContext context) => new ArticleListScreen();
//              } else {
//                String param = settings.name.split('/')[2];
//                builder = (BuildContext context) => new NewArticle(param);
//              }
//
//              return new MaterialPageRoute(builder: builder, settings: settings);
//            },
            home: RepaintBoundary(
              child: Home(
                change: () {
                  color = Colors.green;
                  setState(() {});
                },
                reset: () {
                  color = Colors.amber;
                  setState(() {});
                },
                themeChange: () {
                  setState(() {
                    isDark = !isDark;
                  });
                },
                localeChange: () {
                  setState(() {
                    localeIndex = localeIndex == 0 ? 1 : 0;
                  });
                },
              ),
            )),
      ),
    );
  }
}

///使用定义的语言 MaterialLocalizations.of(context).backButtonTooltip
class CustomLocalizations extends DefaultMaterialLocalizations {
  CustomLocalizations(this.locale) {
    print("CustomLocalizations init locale ${locale.toString()}");
  }
  Locale locale;
  @override
  String get backButtonTooltip =>
      locale.languageCode == "zh" ? "我是返回键" : "i am back";

  static final LocalizationsDelegate<CustomLocalizations> delegate =
      _MaterialLocalizationsDelegate("");
  static Future<CustomLocalizations> load(Locale locale) {
    return SynchronousFuture<CustomLocalizations>(CustomLocalizations(locale));
  }
}

class _MaterialLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {
  static const locals = ['en', 'zh'];
  String jsonData;
  _MaterialLocalizationsDelegate(this.jsonData);

  @override
  bool isSupported(Locale locale) {
    final isSupport = locals.contains(locale.languageCode);
    print("_MaterialLocalizationsDelegate isSupported $isSupport");
    return isSupport;
  }

  @override
  Future<CustomLocalizations> load(Locale locale) =>
      CustomLocalizations.load(locale);

  @override
  bool shouldReload(_MaterialLocalizationsDelegate old) => false;

  @override
  String toString() => 'DefaultMaterialLocalizations.delegate(en_US)';
}

///监听页面进入，离开
class MNavigatorObserber extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print(
        "MNavigatorObserber   route.overlayEntries ${route.overlayEntries.toString()}");

    ///只监听页面route
    if (route is PageRoute && previousRoute is PageRoute) {
      print(
          "HomePage MNavigatorObserber  didPush current ${route?.settings}  previousRoute ${previousRoute?.settings}");
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
//    ModalRoute.of().isCurrent; 最上层的route
    ///只监听页面route
    if (route is PageRoute && previousRoute is PageRoute) {
      print(
          "HomePage MNavigatorObserber  didPop current ${route?.settings}  previousRoute ${previousRoute?.settings}");
    }
  }
}

class Home extends StatefulWidget {
  VoidCallback change;
  VoidCallback reset;
  VoidCallback themeChange;
  VoidCallback localeChange;
  Home({this.change, this.reset, this.themeChange, this.localeChange});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  CustomPopup customPopup;
  int _current;
  double popupX = 100.0;
  double popupY = 100.0;
  double preX;
  double preY;
  double cancelPartWidth = 300;
  double cancelPartHeight = 300;
  var radius = 25;
  AnimationController _controller;
  Animation<double> clampAnimation;
  final strChangeLocale = "改变语言";
  final strResetColor = "颜色reset";
  final strChangeColor = "换色";
  final strChangeTheme = "主题切换";

  final strLocale = "改变语言";

  var menuType = "改变语言";
//  int count = 0;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    clampAnimation = CurveTween(curve: Curves.linear).animate(_controller)
      ..addListener(() {
        overlayState.setState(() {
          print("clampAnimation.value ${clampAnimation.value}");
          popupX =
              MediaQuery.of(context).size.width * clampAnimation.value - radius;
          //贴边 而不是进入屏幕一部分
          popupX =
              popupX.clamp(0.0, MediaQuery.of(context).size.width - radius * 2);
        });
      });

    customPopup = CustomPopup();
  }

  OverlayEntry overlayEntry;

  var overlayState;
  bool showCancelPart = false;
  void createApplicationPopup() {
    if (null != overlayEntry) {
      overlayEntry.remove();
      overlayEntry = null;
    }
    overlayState = Overlay.of(context);
    overlayEntry = new OverlayEntry(
        builder: (context) {
          return buildApplicationPopup();
        },
        opaque: false,
        maintainState: true);
    overlayState.insert(overlayEntry);
  }

  Widget buildApplicationPopup() {
    return Stack(
      children: <Widget>[
        Positioned(
            right: -150,
            bottom: -150,
            width: cancelPartWidth,
            height: cancelPartHeight,
            child: Visibility(
              visible: showCancelPart,
              child: ClipOval(
                child: Material(
                  child: Container(
                      alignment: Alignment(-0.5, -0.5),
                      decoration: BoxDecoration(color: Colors.red)),
                ),
              ),
            )),
        Positioned(
          right: 20,
          bottom: 40,
          child: Visibility(
            visible: showCancelPart,
            child: Material(
              child: Container(
                decoration: BoxDecoration(color: Colors.red),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[Icon(Icons.cancel), Text("取消悬浮窗")],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: popupX,
          top: popupY,
          width: 50,
          height: 50,
          child: GestureDetector(
            onTap: () {
              print("application on tap");
            },
            onPanStart: (dragStartDetails) {
              print(
                  "ApplicationPopup onPanStart ${dragStartDetails.globalPosition.dx} ${dragStartDetails.globalPosition.dy}");
              preX = dragStartDetails.globalPosition.dx;
              preY = dragStartDetails.globalPosition.dy;
            },
            onPanUpdate: (dragUpdateDetails) {
              showCancelPart = true;
              print("ApplicationPopup onPanUpdate $dragUpdateDetails");
              var currentX = dragUpdateDetails.globalPosition.dx;
              var currentY = dragUpdateDetails.globalPosition.dy;
              popupX = popupX + currentX - preX;
              popupY = popupY + currentY - preY;
              popupX = popupX.clamp(
                  0.0, MediaQuery.of(context).size.width - radius * 2);
              popupY = popupY.clamp(
                  0.0, MediaQuery.of(context).size.height - radius * 2);
              preX = currentX;
              preY = currentY;
              print("popupX $popupX  popupY $popupY ");
              //TODO 判断一点是否在园内  移动球的圆心进入取消区域园
              double dis = math.sqrt(math.pow(
                      MediaQuery.of(context).size.width - (popupX + radius),
                      2) +
                  math.pow(
                      MediaQuery.of(context).size.height - (popupY + radius),
                      2));
              print("dis $dis");
              if (dis <= 150) {
                //相交时 取消区域增大
                cancelPartWidth = 300.0 + 20;
                cancelPartHeight = 300.0 + 20;
              } else {
                cancelPartWidth = 300.0;
                cancelPartHeight = 300.0;
              }
              overlayState.setState(() {});
            },
            onPanEnd: (dragEndDetails) {
              showCancelPart = false;
              if (cancelPartWidth > 300) {
                cancelPartWidth = 300;
                cancelPartHeight = 300;
                //取消全局浮窗
                overlayEntry.remove();
                overlayEntry = null;
                //重置位置
                popupX = 100.0;
                popupY = 100.0;
                overlayState.setState(() {});
                //退出该事件
                return;
              }
              //移动结束时，悬浮窗靠边
              print(
                  "popupX $popupX popupY $popupY radius $radius MediaQuery.of(context).size.width ${MediaQuery.of(context).size.width}  ${(popupX + radius) / MediaQuery.of(context).size.width}");
              if (popupX + radius >= MediaQuery.of(context).size.width / 2) {
//                popupX = MediaQuery.of(context).size.width - radius * 2;
                _controller.forward(
                    from:
                        (popupX + radius) / MediaQuery.of(context).size.width);
              } else {
//                popupX = 0;
                _controller.reverse(
                    from:
                        (popupX + radius) / MediaQuery.of(context).size.width);
              }
            },
            child: ClipOval(
              child: Material(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.purple),
                  child: Text("悬浮窗"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
//        title: Text("flutter"),
        actions: <Widget>[
          DropdownButton(
              hint: Text(menuType),
              items: [
                DropdownMenuItem(
                    child: Text(strChangeLocale), value: strChangeLocale),
                DropdownMenuItem(
                    child: Text(strChangeColor), value: strChangeColor),
                DropdownMenuItem(
                    child: Text(strResetColor), value: strResetColor),
                DropdownMenuItem(
                    child: Text(strChangeTheme), value: strChangeTheme)
              ],
              onChanged: (value) {
                setState(() {
                  menuType = value;
                });
                if (value == strChangeLocale) {
                  widget.localeChange();
                } else if (value == strChangeColor) {
                  widget.change();
                } else if (value == strResetColor) {
                  widget.reset();
                } else if (value == strChangeTheme) {
                  widget.themeChange();
                }
              }),
          FlatButton(
              onPressed: () {
                showMenu(context: context, position: RelativeRect.fill, items: [
                  PopupMenuItem(
                    value: "androidpopup",
                    child: Text("androidpopup 仿微信"),
                  ),
                  PopupMenuItem(
                    value: "custompopup",
                    child: Text("custompopup"),
                  )
                ]).then((result) {
                  if (result == "androidpopup") {
                    createApplicationPopup();
                  } else if (result == "custompopup") {
//                    count++;
//                    if (count > 5) {
//                      showDialog(
//                          context: context,
//                          builder: (context) {
//                            return SimpleDialog(
//                              title: Text("最多支持5个"),
//                              children: <Widget>[
//                                SimpleDialogOption(
//                                  onPressed: () {
//                                    Navigator.of(context).pop();
//                                  },
//                                  child: Text("确定"),
//                                )
//                              ],
//                            );
//                          });
//                      return;
//                    }
                    customPopup.countAdd();
                    customPopup.popup(context);
                  }
                });
              },
              child: Text("全局浮窗"))
        ],
      ),
      //selectstyle 在ontap设置后生效
      //padding是计算字体和icon知道的
      //替换为cupertino或自己写
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
//            Text("dart extension").paddingAll(20),
            Text("${MaterialLocalizations.of(context).backButtonTooltip}"),
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
            Text("路由 ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RouterPage();
                  }));
                },
                child: Text("路由")),
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
                    return CustomScrollPhysicsPage();
                  }));
                },
                child: Text("Custom  ScrollPhysics ")),
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
                    return CustomSliverPage();
                  }));
                },
                child: Text("自定义sliver")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NestedPage();
                  }));
                },
                child: Text("NestedPage")),
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
                    return DraggablePage();
                  }));
                },
                child: Text("Draggable 拖动到目标widget")),
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
                    return SafeAreaAndMediaQueryPage();
                  }));
                },
                child: Text("SafeArea MediaQuery")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ThemePage();
                  }));
                },
                child: Text("theme Page")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return IntlPage();
                  }));
                },
                child: Text("国际化")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GifTestPage();
                  }));
                },
                child: Text("gif test ")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BlurPage();
                  }));
                },
                child: Text("blur ")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DrawerPage();
                  }));
                },
                child: Text("Drawer 侧边栏 ")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VisibilityTestPage();
                  }));
                },
                child: Text("visibility")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AppbarPage();
                  }));
                },
                child: Text("AppbarPage")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DecorationAndBorders();
                  }));
                },
                child: Text("各种decoration和borders")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TablePage();
                  }));
                },
                child: Text("Table 表格")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return BottomNavigatorTest();
                  }));
                },
                child: Text("bottom naviagtor")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RadioPage();
                  }));
                },
                child: Text("radio page")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return RefreshPage();
                  }));
                },
                child: Text("refresh page")),
            Text("事件处理---------------"),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PointerListener();
                  }));
                },
                child: Text("pointer listener")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return GesureDetectorPage();
                  }));
                },
                child: Text("Gesure Detector")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NotificationPage();
                  }));
                },
                child: Text("Notification Page")),
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
            Text("Services ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SystemChromePage();
                  }));
                },
                child: Text("System Chrome page")),
            Text("Canvas ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CanvasPage();
                  }));
                },
                child: Text("Canvas")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PathPage();
                  }));
                },
                child: Text("path page")),
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
            Text("原生插件 native plugin----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WebviewPage();
                  }));
                },
                child: Text("网页 webview")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return VideoPlayerPage();
                  }));
                },
                child: Text("VideoPlayer播放视频")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FFmpegPage();
                  }));
                },
                child: Text("测试FFmpeg")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MovieAudioReplace();
                  }));
                },
                child: Text("电影音频替换")),
            Text("原理认证  ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WidgetUpdate();
                  }));
                },
                child: Text("widget 更新")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ListViewMemoryPage();
                  }));
                },
                child: Text("list view 内存")),
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
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return SliverSectionOrganizer();
                  }));
                },
                child: Text("官方Gallery Sliver SectionOrganizer Animation")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ImagePreviewPage();
                  }));
                },
                child: Text("图片预览 imgage preview")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CaptureScreenPage();
                  }));
                },
                child: Text("截图和涂鸦 RepaintBoundary")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PageViewPage();
                  }));
                },
                child: Text("PageView")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ShimmerWidget();
                  }));
                },
                child: Text("Shimmer Widget")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Circle2Rectangle();
                  }));
                },
                child: Text("Circle2Rectangle 圆变为方")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ReorderListPage();
                  }));
                },
                child: Text("reorderList 重排序列表")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return DropsPage();
                  }));
                },
                child: Text("仿drops应用")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Model3DPage();
                  }));
                },
                child: Text("加载3D模型")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OverlayChangePage();
                  }));
                },
                child: Text("Overlay Change Page")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ApiPayAnim();
                  }));
                },
                child: Text("ali pay anim")),
            FlatButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return ProxyRenderPage();
                  }));
                },
                child: Text('ProxyRenderPage')),
            Text("测试第三方包 ----------------------- "),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AnnotationRoutePage1("");
                  }));
                },
                child: Text("咸鱼 annotation route")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ShareSDKPage();
                  }));
                },
                child: Text("ShareSDK分享")),
            FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProviderTest();
                  }));
                },
                child: Text("provider 测试")),
//            FlatButton(
//                key: Key("list_last"),
//                onPressed: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context) {
//                    return FishReduxPageWidget();
//                  }));
//                },
//                child: Text("咸鱼 fish_redux", key: Key("list_last_text"))),
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
