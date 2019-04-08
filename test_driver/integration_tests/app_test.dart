import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  //编写测试
//
//  创建 SeralizableFinders来定位到具体的widget   通过find.byValueKey创建finders
//  在测试运行在setUpAll函数前连接app    通过FlutterDriver连接app
//  测试重要的场景
//  测试完成后运行teardownAll来断开与app的连接

// 根widget的title
  group("flutter", () {
    //创建finder
    final flatButtonFinder = find.byValueKey("FlatButton");
    final textFinder = find.byValueKey("FlatButtonChild");
    final textPageFinder = find.byValueKey("TextPageTitle");
    final backFinder = find.byValueKey("BackBtn");
    final listFinder = find.byValueKey("long_list");
    //建立连接
    FlutterDriver flutterDriver;
    setUpAll(() async {
      flutterDriver = await FlutterDriver.connect();
    });

    //测试完成断开连接
    tearDownAll(() async {
      if (null != flutterDriver) {
        flutterDriver.close();
      }
    });

    //测试text的初始值是否是text
    test("test text init ", () async {
      expect(await flutterDriver.getText(textFinder), "text");
    });
    test("jump to TextPage ", () async {
      //按钮点击,页面跳转
      await flutterDriver.tap(flatButtonFinder);
      //验证标题是否是text
      expect(await flutterDriver.getText(textPageFinder), "text");
    });

//    性能测试    为了保证大型app能在大量设备流畅运行而不用手动测试     通过traceAction记录timeline，里面有详细的性能信息
    //返回首页
    test("back to Home ", () async {
      await flutterDriver.tap(backFinder);
      expect(await flutterDriver.getText(textFinder), "text");
    });

//    flutterDriver提供三个滚动方法，scrollUntilVisible用的最多
    test("验证list最后一个", () async {
      final listLastFinder = find.byValueKey("list_last");
      //记录time line
      final timeLine = await flutterDriver.traceAction(() async {
        //滚动需要提供一个负值的dyScroll，这是一个可以滚动的最小值,a确保不会滚动超过
        await flutterDriver.scrollUntilVisible(listFinder, listLastFinder, dyScroll: -50);
      });
      final listLastTextFinder = find.byValueKey("list_last_text");
      expect(await flutterDriver.getText(listLastTextFinder), "咸鱼 fish_redux");

      //将time line转为TimelineSummary 方便阅读       1可以通过chrome://tracing打开 2可以写到硬盘 默认路径是工程/build目录
      final summary = new TimelineSummary.summarize(timeLine);
      summary.writeSummaryToFile('scrolling_summary', pretty: true);
      //可通过Chrome打开
      summary.writeTimelineToFile('scrolling_timeline', pretty: true);
    });
  });
}
