import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'demo_Localizations_delegate.dart';
import 'demo_localizations.dart';
import 'i10n/localization_intl.dart';

//以MaterialApp类为入口的应用来说明如何支持国际化
//大多数应用程序都是通过MaterialApp为入口，但根据低级别的WidgetsApp类为入口编写的应用程序也可以使用相同的类和逻辑进行国际化。
//MaterialApp实际上也是WidgetsApp的一个包装
class IntlPage extends StatefulWidget {
  @override
  _IntlPageState createState() => _IntlPageState();
}

class _IntlPageState extends State<IntlPage> {
  var locals = [
    const Locale('zh', 'CN'),
    const Locale('en', 'US'), // 美国英语
  ];
  var localIndex = 0;
  @override
  Widget build(BuildContext context) {
//    localizationsDelegates列表中的元素是生成本地化值集合的工厂。
//    GlobalMaterialLocalizations.delegate 为Material 组件库提供的本地化的字符串和其他值，它可以使Material Widget支持多语言。
//      非material的不添加
//    GlobalWidgetsLocalizations.delegate定义widget默认的文本方向，从左到右或从右到左，这是因为有些语言的阅读习惯并不是从左到右，比如如阿拉伯语就是从右向左的

//    我们始终可以通过以下方式来获取应用的当前区域Locale：
//    Locale myLocale = Localizations.localeOf(context);
//    Localizations Widget一般位于Widget树中其它业务组件的顶部，它的作用是定义区域Locale以及设置子树依赖的本地化资源。
//    如果系统的语言环境发生变化，WidgetsApp将创建一个新的Localizations Widget并重建它，这样子树中通过Localizations.localeOf(context) 获取的Locale就会更新

//    为了尽可能小而且简单，flutter软件包中仅提供美国英语值的MaterialLocalizations和WidgetsLocalizations接口的实现。
//    这些实现类分别称为DefaultMaterialLocalizations和DefaultWidgetsLocalizations。
//    flutter_localizations Package包含GlobalMaterialLocalizations和GlobalWidgetsLocalizations的本地化接口的多语言实现，
//    国际化的应用程序必须按照本节开头说明的那样为这些类指定本地化Delegate。
//    上述的GlobalMaterialLocalizations和GlobalWidgetsLocalizations只是Material组件库的本地化实现，
//    如果我们要让自己的布局支持多语言，那么就需要实现在即的Localizations

    //查找上一级context的语言环境   不手动指定定locale，默认为en，但在WidgetsApp的_WidgetsAppState的initState时会获取WidgetsBinding.instance.window.locales
//     然后回掉给localeResolutionCallback,同时Localizations.localeOf使用正确的context可以获得正确的locale
    Locale myLocale = Localizations.localeOf(context);
    print("IntlPage myLocale $myLocale");
    print("window binding locale  ${WidgetsBinding.instance.window.locales}");
    return MaterialApp(
      localizationsDelegates: [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate,
        // 注册我们的Delegate
        DemoLocalizationsDelegate(),
        IntlLocalizationsDelegate()
      ],
      //设置支持的语言
      supportedLocales: locals,
      //手动指定locale
      locale: locals[localIndex],

      localeListResolutionCallback: (locales, supportedLocales) {
        //监听语言改变
        print("localeListResolutionCallback locales $locales supportedLocales $supportedLocales");
      },
      localeResolutionCallback: (locale, supportedLocales) {
        //监听语言改变
//        如果locale为null，则表示Flutter未能获取到设备的Locale信息，所以我们在使用locale之前一定要先判空
        print("localeResolutionCallback locale $locale supportedLocales $supportedLocales");
      },
      home: ContentBody(() {
        print("点击");
        setState(() {
          localIndex = localIndex == 0 ? 1 : 0;
        });
      }),
    );
  }
}

class ContentBody extends StatelessWidget {
  final VoidCallback callback;

  const ContentBody(this.callback);

  @override
  Widget build(BuildContext context) {
    //查找当前的语言环境
    Locale myLocale = Localizations.localeOf(context);
    print("ContentBody myLocale $myLocale");
    return Scaffold(
      appBar: AppBar(
        //使用Locale title
        title: Text(DemoLocalizations.of(context).title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(/*"使用intl包改变标题：${}"*/ IntlLocalizations.of(context).title),
            RaisedButton(
              onPressed: callback,
              child: Text("改变标题语言"),
            ),
          ],
        ),
      ),
    );
  }
}
