import 'package:async/async.dart';

void main() {
  ///    async/async包提供的方法

  ///多个任务完成后，再进行某个处理     可以加入flutter下compute isolate运行 或者纯isolate代码，
  ///  可以先在isolate执行耗时操作，后在主isolate中执行future，最后监听执行结果
  FutureGroup fg = FutureGroup();
  fg.add(getA());
  fg.add(getB());
  //加入完成，开始任务
  print("fg close");
  fg.close();
  //所有任务完成后
  fg.future.then((List result) {
    print("list result $result");
  });

  //FutureGroup  某个future异常时，可以catchError，其他future继续进行，then不进行      如果对异常future捕获异常，可以正常运行
  FutureGroup fgException = FutureGroup();
  fgException.add(getA());
  fgException.add(
    getException().catchError((e) {}),
  );
  fgException.add(getB());
  fgException.close();
  fgException.future.then((result) {
    print("fgException result is $result");
  }).catchError((e) {
    print("fgException catchError $e");
  });
}

Future<String> getA() async {
  await Future.delayed(Duration(seconds: 3));
  print("task getA ===");
  return "a";
}

Future<String> getB() async {
  await Future.delayed(Duration(seconds: 3));
  print("task getB ===");
  return "b";
}

Future<String> getException() async {
  print("task getException ===");

  throw Exception("an error");
}
