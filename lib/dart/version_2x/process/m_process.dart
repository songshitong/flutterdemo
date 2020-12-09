import 'dart:io';

void main() {
  ///在命令行terminal,cmd中执行ls并将结果打印
  Process.run("ls", []).then((value) {
    print(value.stdout);
    print(value.stderr);
  }).catchError((e) {
    print(e?.toString());
  });
}

///当前路径
String getCurrentFile() {
  return Directory.current.path;
}

///文件分隔符
String getFileSeparator() {
  return Platform.pathSeparator;
}
