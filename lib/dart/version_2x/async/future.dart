import 'dart:async';

main() async {
  // Adds a task to the 先查看MicroTask queue.
  scheduleMicrotask(() {
// ...code goes here...
  });

  new Future.microtask(() {
// ...code goes here...
  });

  print("getLong1 ${await getLong()}");
  print("getShort1 ${await getShort()}");

  print("getLong2 ${getLong()}");
  print("getShort2 ${getShort()}");

//  print("getA ${await getA()}");
//
//  try {
//    print("getAValue ${await getAValue()}");
//  } catch (e) {
//    print("e ${e}");
//  }
  // try  catch可以 捕获 await/async的异常， 不能捕获Future.onerror 异常   推荐使用await for
  //todo try future.then

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

//  type '_TypeError' is not a subtype of type 'FutureOr<Null>'
  // return e的问题，exception不是future类型

  //onError 通常有两种形式
  // - (dynamic) -> FutureOr<T>
  // - (dynamic, StackTrace) -> FutureOr<T>
  Future(() {
    throw Exception("first error");
  }).then((data) {
    return "data is 12";
  }, onError: (e) {
    print("第一个onerror e=$e");
//    return e;
  }).then((s) {
    throw Exception("sceond error");
  }).catchError((e) {
    print("catch error e=$e");
//    return e;
  }, test: (error) {
    return true;
  });

  //将多个异步函数的返回汇总  如果其中一个函数抛错，进入catchError 流程   多个异步链式调用，一个异常，一个处理结果最后怎么返回
//  Future.wait([getA(), getB(), getAValue()]).then((data) {
//    print("wait data=$data");
//  }).catchError((e) {
//    print("wait e=$e");
//  });

  ///接口顺序请求，一个完成后请求另一个
  ///await a
  /// await b
  ///

  //同步任务
//  Future.sync(computation)

  ///FutureOr 代表future 和 T的两种情况
  ///
  ///
  /// if (result is Future<T>) {
  ///          return result;
  ///     } else {
  ///        return new _Future<T>.value(result);
  ///      }

  FutureOr a;

  ///future有关的函数最好声明类型
  /// type 'Future<dynamic>' is not a subtype of type 'FutureOr<String>'
  /// 多个future的调用，返回值与函数的声明要一致。
  ///
  /// Future<R> then<R>(FutureOr<R> onValue(T value), {Function onError});
  /// then里面如果有多个return，return的返回值要与函数声明的一致
  ///
  ///

  ///测试 await async 顺序
  ///getStr1
  ///getName2
  ///getName3
  ///getStr2
  ///getName1
  getName1();
  getName2();
  getName3();

  ///getStr1
  ///getStr2
  ///getName1
  ///getName2
  ///getName3
//  await getName1();
//  getName2();
//  getName3();

  ///测试for循环中使用future
  Future.forEach(
      List<int>.generate(10, (index) => index),
      (dynamic element) => Future.delayed(Duration(seconds: 1)).then(
          (value) => print("Future.forEach second ${DateTime.now().second}")));

  ///不行 执行时间取最长的
  future.then((value) => print("future 测试一个future 一个future的执行"));
  future.then((value) async {
    var a = await getA();
    print("future get a $a");
  });
  future.then((value) async {
    var b = await getB();
    print("future get b $b");
  });
  future.then((value) => print("future 结束"));

  ///可以
  future
      .then((value) => print("future1 测试一个future 一个future的执行"))
      .then((value) async {
    var a = await getA();
    print("future1 get a $a");
  }).then((value) async {
    var b = await getB();
    print("future1 get b $b");
  }).then(((value) => print("future1 结束")));

  ///自执行函数  保证执行顺序的,总共6秒
  await () async {
    print("start111111");
  }();
  await () async {
    await Future.delayed(Duration(seconds: 3))
        .then((value) => print("time3333"));
  }();
  await () async {
    await Future.delayed(Duration(seconds: 1))
        .then((value) => print("time1111"));
  }();
  await () async {
    await Future.delayed(Duration(seconds: 2))
        .then((value) => print("time2222"));
  }();
  await () async {
    print("end111111");
  }();
}

Future future = Future(() {});

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

Future<String> getLong() async {
  await Future.delayed(Duration(seconds: 3));
  return "long";
}

Future<String> getShort() async {
  await Future.delayed(Duration(seconds: 1));
  return "short";
}

getName1() async {
  await getStr1();
  await getStr2();
  print('getName1');
}

getStr1() {
  Future.delayed(Duration(seconds: 1), () {
    print('getStr1 delay');
    return Future.value();
  });
  print('getStr1');
}

getStr2() {
  print('getStr2');
}

getName2() {
  print('getName2');
}

getName3() {
  print('getName3');
}
