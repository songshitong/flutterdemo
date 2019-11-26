import 'package:flutterdemo/dart/version_2x/Btn.dart';

const a = "a";
final b = getB();

getA() {
  return "A";
}

getB() {
  return "B";
}

void main() {
  ///默认值是null
  int value;
  print("value 结果是 ");
  print(value);

//  value = 2;
//  print("\nvalue 结果是 ");
//  print(value);

  ///  _私有
  Button btn = new Button();
  btn.btn = "change btn";
  btn.text;
  btn.color;

  /// 高效的字符串拼接 StringBuffer   write方法写入    toString 拼接并输出
  StringBuffer sb = StringBuffer();
  sb.write("hhhh");
  print("sb ${sb.toString()}");

  //num 常用方法
  //比大小   大返回>0的数字 小返回<0的数字
  int a = 1;
  int b = 2;
  print("a b compare ${a.compareTo(b)}");

  //string 常用方法
  String strA = "a";
  String strB = "b";
  print("strA strB compare  ${strB.compareTo(strA)}");

  //string multiply number
  //string重写了*操作符  "0"*5 = "00000"
  String a5 = "a" * 5;
  print("a5 is $a5");
  //string 重写了[]操作符，可以直接取
  String a5str = a5[4];
  print("a5str is $a5str");

  //正则匹配  不建议用正则匹配HTML，使用htmlparser
  var videoRegExp = RegExp(r'''<video[^>]+src="([^">]+)"''');
  for (var match in videoRegExp.allMatches("ssssssadfasfdafasfdaf")) {
    print(" match ${match.group(0)}");
  }

  ///引用传递 指向实际内容的地址
  String aTest = "i am a";
  String bTest = aTest;
  aTest = "a change to b";
  print("bTest $bTest"); //bTest 指向的地址不变

  double db = 0.0;
  print("db==0 ${db == 0}");

  bool flagA = false;
  bool flagB = false;
  print("flase&&flase ${flagA && flagB}");
}
