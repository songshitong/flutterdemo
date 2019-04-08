import 'package:test/test.dart';

void main() {
  //单元测试确保添加新功能或者已存在功能的正常
//单元测试可以方便地验证单个函数，方法或类的行为

//  1 添加依赖
//  dev_dependencies:
//  test: <latest_version>
  //  2 创建test文件   /test/unit_test.dart
  //3 编写测试用例
  //4 运行通过run按钮或者flutter test test/counter_test.dart
  Map<String, String> map1 = Map();
  map1["param"] = "param1";

  String str = "str";

  //将多个有关的test使用group进行组合  test可单独运行，group运行包含的test
  group("hhh", () {
    test('just a test', () {
      expect(printMap(map1), null);
      expect(printVar(str), str);

      expect(createTest("aaa"), TypeMatcher<Test>());
      expect("aa", isNotEmpty);
    });
  });

  //matcher
  //TypeMatcher  检查类型
  //isFalse      预期为false
  //isEmpty      预期为empty
  //isList       预期为list
}

printMap(Map<String, dynamic> map) {
  print("map ${map["param"]}");
}

printVar(dynamic va) {
  printStr(va);
  return va;
}

printStr(String str) {
  print("str $str");
}

createTest(dynamic name) {
  return Test(name);
}

class Test {
  String name;
  Test(this.name) {
    print("test create $name");
  }
}
