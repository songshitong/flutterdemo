import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart'; //1

class IntlLocalizations {
  static Future<IntlLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    //2
    return initializeMessages(localeName).then((b) {
      Intl.defaultLocale = localeName;
      print("IntlLocalizations  CurrentLocale ${Intl.getCurrentLocale()}");
      return new IntlLocalizations();
    });
  }

  static IntlLocalizations of(BuildContext context) {
    return Localizations.of<IntlLocalizations>(context, IntlLocalizations);
  }

  String get title {
    return Intl.message('Flutter APP',
        name: 'title', desc: 'Title for the Demo application', locale: Intl.getCurrentLocale());
  }
}

//Locale代理类
class IntlLocalizationsDelegate extends LocalizationsDelegate<IntlLocalizations> {
  const IntlLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<IntlLocalizations> load(Locale locale) {
    //3
    return IntlLocalizations.load(locale);
  }

  // 当Localizations Widget重新build时，是否调用load重新加载Locale资源.
  @override
  bool shouldReload(IntlLocalizationsDelegate old) => false;
}

// 使用intl包   arb文件中"@@locale":"zh_CN"要和dart代码声明的locale完全一致，不然找不到对应的locale
//        dartPath = lib/flutter/widget/functionwidget/international/i10n/
//        arbPath = /Users/issmac/FlutterWorkspace/flutterdemo/lib/flutter/widget/functionwidget/international/i10n_arb
//1  根据localization_intl.dart 生成intl_messages.arb，手工复制intl_messages.arb，并修改为需要翻译的中文
//     命令是：flutter pub run intl_translation:extract_to_arb --output-dir=arbPath \dartPath/localization_intl.dart
//2  根据多个arb文件在生成对应的dart文件进行引用

//     命令是：flutter pub run intl_translation:generate_from_arb --output-dir=dartPath --no-use-deferred-loading \dartPath/localization_intl.dart arbPath/intl_*.arb
