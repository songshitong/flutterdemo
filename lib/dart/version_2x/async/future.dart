import 'dart:async';

main() async {
  // Adds a task to the 先查看MicroTask queue.
  scheduleMicrotask(() {
// ...code goes here...
  });

  new Future.microtask(() {
// ...code goes here...
  });

  print("getA ${await getA()}");

  try {
    print("getAValue ${await getAValue()}");
  } catch (e) {
    print("e ${e}");
  }
  // try  catch可以 捕获 await/async的异常， 不能捕获Future.onerror 异常   推荐使用await for

  //创建Future
  Future(() {
    return "this is data";
  }).then((data) {
    print("data $data");
  });

  //处理Future中的异常
  Future(() {
    throw Exception("first error");
  }).then((data) {
    return "data is 12";
  }, onError: (e) {
    print("第一个onerror e=$e");
  }).then((s) {
    throw Exception("sceond error");
  }).catchError((e) {
    print("catch error e=$e");
  });

  //将多个异步函数的返回汇总  如果其中一个函数抛错，进入catchError 流程
  Future.wait([getA(), getB(), getAValue()]).then((data) {
    print("wait data=$data");
  }).catchError((e) {
    print("wait e=$e");
  });
}

Future<String> getA() async {
  await Future.delayed(Duration(seconds: 3));
  return "a";
}

Future<String> getB() async {
  await Future.delayed(Duration(seconds: 3));
  return "b";
}

Future<String> getAValue() async {
  throw Exception("getAValue there is an error throw");
  return await getA();
}
