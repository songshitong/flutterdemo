import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

void main() {
  //代码来自
//  https://blog.happyyun.com/2019/05/26/flutter-%e5%a4%9a%e7%ba%bf%e7%a8%8b%e5%92%8c%e5%bc%82%e6%ad%a5%e4%bb%bb%e5%8a%a1%e5%ae%9e%e8%b7%b5/

  ///flutter提供的库，将任务添加到一个队列，然后根据优先级，在渲染的帧间执行。每个任务的执行耗时应控制在1毫秒以内
  ///
  /// 优先级说明
  ///touch: 在有用户交互时依然执行的任务。最高优先级
  ///animation: 在执行动画时依然执行的任务。优先级不如touch
  ///idle: 在没有动画，以及其他更高优先级任务在执行时，才执行。最低优先级
  ///
  ///在flutter应用内运行，单独运行出错
  if (null != SchedulerBinding.instance) {
    //instance可能为null
    SchedulerBinding.instance.scheduleTask(() {
      return "结果";
    }, Priority.idle).then((result) {
      print("task result $result");
    });
  }

  //compute方法会 spawn 一个 isolate, 并在 isolate 中运行callback对应的方法。可传递一个泛型参数。最后返回一个 Future 对象，该对象可获取线程执行的结果。
  ///flutter 提供简化isolate的方法，运行在flutter引用
  compute(syncFibonacci, 20).then((result) {
    print("rsult $result");
  });

  var start = DateTime.now().millisecondsSinceEpoch;
  compute(getNum, 0).then((result) {
    //时间在110ms左右
    print("getNum time ${DateTime.now().millisecondsSinceEpoch - start}");
  });
}

int syncFibonacci(int n) {
  return n < 2 ? n : syncFibonacci(n - 2) + syncFibonacci(n - 1);
}

int getNum(int num) {
  return num;
}
