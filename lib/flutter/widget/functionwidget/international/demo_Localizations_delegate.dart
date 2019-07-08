//Locale代理类
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'demo_localizations.dart';

//Delegate类的职责是在Locale改变时加载新的Locale资源，所以它有一个load方法，Delegate类需要继承自LocalizationsDelegate类，实现相应的接口
class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  //是否支持某个Local
  @override
  bool isSupported(Locale locale) => ['en', 'zh'].contains(locale.languageCode);

  // Flutter会调用此类加载相应的Locale资源类
  @override
  Future<DemoLocalizations> load(Locale locale) {
    print("xxxx$locale");
    return SynchronousFuture<DemoLocalizations>(DemoLocalizations(locale.languageCode == "zh"));
  }

//  shouldReload的返回值决定当Localizations Widget重新build时，是否调用load方法重新加载Locale资源。
//  一般情况下，Locale资源只应该在Locale切换时加载一次，不需要每次在Localizations 重新build时都加载，所以返回false即可。
//  可能有些人会担心返回false的话在APP启动后用户再改变系统语言时load方法将不会被调用，所以Locale资源将不会被加载。
//  事实上，每当Locale改变时Flutter都会再调用load方法加载新的Locale，无论shouldReload返回true还是false
  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
