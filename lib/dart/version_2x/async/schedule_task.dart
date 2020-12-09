import 'dart:async';

///future和scheduleMicrotask的区别
///The Future class, which adds an item to the end of the event queue.
/// The top-level scheduleMicrotask() function, which adds an item to the end of the microtask queue.

// Runs a function asynchronously.
// *
// * Callbacks registered through this function are always executed in order and
// * are guaranteed to run before other asynchronous events (like [Timer] events,
// * or DOM events).
// *
// * **Warning:** it is possible to starve the DOM by registering asynchronous
// * callbacks through this method. For example the following program runs
// * the callbacks without ever giving the Timer callback a chance to execute:
void main() {
  ///timer.run 尽可能快的执行异步任务
  Timer.run(() {
    print("executed");
  }); // Will never be executed.
  foo() {
    ///打印后一直执行print
    // print("start scheduleMicrotask foo");
    scheduleMicrotask(foo); // Schedules [foo] in front of other events.
  }

  ///循环执行foo 导致timer.run无法执行
  // foo();
  Future(() {
    print("this is future");
  });
  scheduleMicrotask(() {
    print("scheduleMicrotask will execute before future");
  });
}
