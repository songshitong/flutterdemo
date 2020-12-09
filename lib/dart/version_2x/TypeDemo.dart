import 'dart:convert';

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
  int? value;
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

  ///String 转utf8    TODO 中文在utf8或utf16分别占几个字节，表情等怎么表示
  ///utf8 中文3字节，英文1字节
  /// String foo = 'Hello world';
  //List<int> bytes = utf8.encode(foo);

  ///utf8转String
  ///String bar = utf8.decode(bytes);

//  https://asecuritysite.com/coding/asc2
  ///String 转utf16  改字符在utf16的index
  /// String foo = 'Hello world';
  //List<int> bytes = foo.codeUnits;
  //给定位置的16-bit UTF-16 code unit
//  foo.codeUnitAt(int index);

  ///String 转Unicode code-points   在Unicode第几位
  String foo = 'Hello world';
  //// Runes runes = foo.runes;
  //// or
  Iterable<int> bytes = foo.runes;
  print("hello world  unicode points $bytes");

  ///url URL转义   转义#或特殊字符
  print("${Uri.encodeComponent("www.baidu.com?#aaa")}");
  print("${Uri.encodeFull("https://www.baidu.com?aaa='会话'")}");

  List<int> hBytes = utf8.encode("hello");
  print("hBytes ${hBytes.length} $hBytes");
  List<int> niBytes = utf8.encode("你好");
  print("niBytes ${niBytes.length} $niBytes");

  List<int> h16Bytes = "hello".codeUnits;
  print("h16Bytes ${h16Bytes.length} $h16Bytes");
  List<int> ni16Bytes = "你好".codeUnits;
  print("ni16Bytes ${ni16Bytes.length} $ni16Bytes");
  //todo 测试表情的字符数

  Map map = {"a": "a", "b": "b", "c": "c"};
//  json格式化
  var encoder = JsonEncoder.withIndent("   ");
  print("json  ${json.encode(map)}");
  print("json pretty ${encoder.convert(map)}");

  ///正则 匹配数字和符号，只保留数字
  var title = "1,2 3.4 5，6";
  title = title.replaceAllMapped(RegExp(r'''(\d)([,，.])(\d)'''), (match) {
    return "${match.group(1)}${match.group(3)}";
  });
  print("title $title");
}
