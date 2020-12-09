void main() {
  String? a;
  print("${a?.substring(0, 2)}");

  //报错日志 NoSuchMethodError: The method 'substring' was called on null.
}
