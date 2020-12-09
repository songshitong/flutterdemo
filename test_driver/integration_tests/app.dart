import 'package:flutter_driver/driver_extension.dart';
import 'package:flutterdemo/main.dart' as app;

///flutter drive 图片不展示
///https://github.com/flutter/flutter/issues/30641
void main() {
  //集成测试   单元测试和widget测试只能测试单个类，集成测试可以运行在设备上测试各个部件作为整体，或者捕获运行的性能
  //测试步骤
  //
  //1 在dev_dependencies中添加 flutter_driver 和test
//  dev_dependencies:
//  flutter_driver:
//  sdk: flutter
//  test: any

  //2 在给要测试的widget添加key    key: Key('increment')
  //3 创建2个文件app.dart   app_test.dart     确保目录在test_driver下面 测试根据app.dart路径查找app_test

  //4 在app_test编写测试用例

  //5 运行 flutter drive --target=test_driver/app.dart
  //这行命令会运行app在设备或模拟器上，然后运行测试套件

  // This line enables the extension
  enableFlutterDriverExtension();

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  app.main();
}
