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
//  btn._btn;
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
}