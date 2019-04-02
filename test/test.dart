import 'dart:collection';

void main() {
  Map<String, String> map1 = Map();
  map1["param"] = "param1";
  printMap(map1);
  String str = "str";
  printVar(str);

  createTest("aaa");
}

printMap(Map<String, dynamic> map) {
  print("map ${map["param"]}");
}

printVar(dynamic va) {
//  print("var $va");
  printStr(va);
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
