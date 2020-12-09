import 'dart:convert';

void main() {
  Map? a;
  try {
    a = json.decode("aa");
  } catch (e) {
    a = {"a": "aaaa"};
    throw Exception("catch exception");
  } finally {
    print("this is finally a $a");
  }

  /// finally 什么情况下执行     不管是否异常都执行
  ///catch中出错 finally执行吗   答案：执行
}
