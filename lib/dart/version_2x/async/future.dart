import 'dart:async';

main() async {
  // Adds a task to the 先查看MicroTask queue.
  scheduleMicrotask(() {
// ...code goes here...
  });

  new Future.microtask(() {
// ...code goes here...
  });

//  print("getA ${await getA()}");
//
//  try {
//    print("getAValue ${await getAValue()}");
//  } catch (e) {
//    print("e ${e}");
//  }
  // try  catch可以 捕获 await/async的异常， 不能捕获Future.onerror 异常   推荐使用await for

  //创建Future
  var start = DateTime.now().millisecondsSinceEpoch;
  Future(() {
    return "this is data";
  }).then((data) {
    //耗时25ms
    print("data $data time ${DateTime.now().millisecondsSinceEpoch - start}");
  });

  //处理Future中的异常
  //
  //catchError future出错先走test，test为false，错误不被catchError处理，test为true，错误被catchError处理，test省略时，默认为true
  //onError和catchError 没有return，继续执行没有result（null），有return后，result是return的值
  Future(() {
    throw Exception("first error");
  }).then((data) {
    return "data is 12";
  }, onError: (e) {
    print("第一个onerror e=$e");
    return e;
  }).then((s) {
//    throw Exception("sceond error");
  }).catchError((e) {
    print("catch error e=$e");
    return e;
  }, test: (error) {
    return true;
  });

  //将多个异步函数的返回汇总  如果其中一个函数抛错，进入catchError 流程
//  Future.wait([getA(), getB(), getAValue()]).then((data) {
//    print("wait data=$data");
//  }).catchError((e) {
//    print("wait e=$e");
//  });

  ///接口顺序请求，一个完成后请求另一个
  ///await a
  /// await b
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
