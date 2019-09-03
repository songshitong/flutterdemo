import 'dart:async';

main() async {
  ///  Stream    A source of asynchronous data events      异步数据事件源
  ///周期性任务 take流出数量控制
  Stream.periodic(Duration(seconds: 1), (int) {
    return "count $int";
  }).take(2).listen((data) {
    print("1s after $data");
  }).onDone(() {
    print("done");
  });

  // .stream 当前输出流  StreamSubscription监听流返回对象
  StreamSubscription ss = controller.stream.listen((data) {
    print("ss $data");
  }, onDone: () {});

  ss.onDone(() {
    print("ss listen on done ");
  });
  //sink 投入  入口数据投入
  controller.sink.add("this is data");
  //关闭流 会出发onDone事件
  controller.close();

  ///  转化成为一条新的流
  //where 过滤 return true 返回该数据，false不返回，最终结果会返回一条新的流
  _steam3.where((num) {
//    if (num == 1) {
//      return false;
//    }
//    return true;
    return num == 1; //返回 num ==1 的情况
  }).listen((data) {
    print("_steam3 $data");
  });

  //take  控制这个流最多能传多少个东西   当传输次数达到这个数字时，这个流将会关闭，无法再传输，结果返回新的流
  Stream<int> _steam4 = Stream.fromIterable([5, 6, 7])
    ..take(2).listen((num) {
      print("_steam4 $num");
    });

  //transform 流转换   StreamTransformer 转换器   范型 s 就收数据类型，t 输出数据类型
  var transformer = StreamTransformer<int, String>.fromHandlers(handleData: (int value, EventSink<String> sink) {
//    handleData接收一个value并创建一条新的流并暴露sink，我们可以在这里对流进行转化
    if (value == 1) {
      return sink.add("这是 1");
    } else if (value == -1) {
      return sink.addError("error 结果是-1");
    } else {
      return sink.add("value 是 $value");
    }
  });

  /// .stream 每次返回一个新的stream，这些stream相等但不同
  intController.stream.transform(transformer).listen((data) {
    print("intController $data");
  }, onError: (e) {
    print("intController error $e");
  });
  intController.sink..add(0)..add(1)..add(-1);

//  流有两种
//  "Single-subscription" streams 单订阅流
//  "broadcast" streams 多订阅流

//  单个订阅流在流的整个生命周期内仅允许有一个listener。它在有收听者之前不会生成事件，并且在取消收听时它会停止发送事件，即使你仍然在Sink.add更多事件。
//  即使在第一个订阅被取消后，也不允许在单个订阅流上进行两次侦听。
//  单订阅流通常用于流式传输更大的连续数据块，如文件I / O.

  ///  广播流允许任意数量的收听者，且无论是否有收听者，他都能产生事件。所以中途进来的收听者将不会收到之前的消息!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!。
//  如果多个收听者想要收听单个订阅流，请使用asBroadcastStream在非广播流之上创建广播流。
//  如果在触发事件时将收听者添加到广播流，则该侦听器将不会接收当前正在触发的事件。如果取消收听，收听者会立即停止接收事件。
//  一般的流都是单订阅流。从Stream继承的广播流必须重写isBroadcast 才能返回true
  StreamController<int> broadcastStream = StreamController();
  Stream bcStream = broadcastStream.stream.asBroadcastStream()
      /*..listen((num) {
      print("listen1 $num");
    })
    ..listen((num) {
      print("listen2 $num");
    })*/
      ;
  broadcastStream.sink.add(13579);
  print("bcStream isBroadcast ${bcStream.isBroadcast}");

  ///first 第一个  last 最后一个  取到第一个或最后一个停止监听，单订阅流会关闭    用于多次点击只取一次/取尾或头   返回future，源码用到了listen 注意是单订阅流还是多订阅流
  Stream<int> _steamFirst = Stream.fromIterable([1, 2, 3]);
  print("_steamFirst ${await _steamFirst.first}  ");
  Stream<int> _steamLast = Stream.fromIterable([1, 2, 3]);
  print("_steamLast ${await _steamLast.last}  ");

  /// await for
  Stream<int> _steamAwaitFor = Stream.fromIterable([1, 2, 3]);
  print("await sumNum ${await sumNum(_steamAwaitFor)}");

  ///生成器   当你需要延迟产生一系列值，使用生成器  使用迭代方法时，yield*可提高性能
  ///同步生成器  返回Iterable 方法标记为sync* 使用yield发送数据
  ///异步生成器  返回Stream   方法标记为async* 使用yield发送数据
  //countStream 异步生成
  print("await sumNum from countStream ${await sumNum(countStream(2))}");

  print("await sumNum from iterrable ${await sumNum(Stream.fromIterable(countIterable(2)))}");

  //future转stream
  Future(count).asStream();
}

Future<int> count() async {
  return 1 + 1;
}

Iterable<int> countIterable(int to) sync* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

Future<int> sumNum(Stream<int> _steamAwaitFor) async {
  int sum = 0;
  await for (int value in _steamAwaitFor) {
    // Executes each time the stream emits a value
    print("await for bcStream $value");
    sum += value;
  }
  //等待for执行完后返回值
  return sum;
}

//steam 创建
//1 构造函数
//从Future创建新的单订阅流,当future完成时将触发一个data或者error，然后使用Down事件关闭这个流
Stream _stream1 = Stream.fromFuture(Future(() {}));
//从一组Future创建一个单订阅流，每个future都有自己的data或者error事件，当整个Futures完成后，流将会关闭。如果Futures为空，流将会立刻关闭
Stream _stream2 = Stream.fromFutures([Future(() {})]);
//Stream.fromIterable:创建从一个集合中获取其数据的单订阅流
Stream<int> _steam3 = Stream.fromIterable([1, 2, 3]);
//2   StreamController
//任意类型的流
StreamController controller = StreamController();
//特定类型的流
StreamController<int> intController = StreamController();
//3 io 流
///4  async（调用） 和 await for 异步循环   不要await for ui 事件监听，应为UI框架会发送无止境的事件
//await for (varOrType identifier in expression) {
// Executes each time the stream emits a value.
//}

//监听Stream的方法
//监听一个流最常见的方法就是listen。当有事件发出时，流将会通知listener。Listen方法提供了这几种触发事件：

//onData(必填)：收到数据时触发
//onError：收到Error时触发
//onDone：结束时触发
//unsubscribeOnError：遇到第一个Error时是否取消订阅，默认为false
