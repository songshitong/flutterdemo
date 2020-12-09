import 'dart:async';

main() async {
  print('main #1 of 2');
  scheduleMicrotask(() => print('microtask #1 of 3'));

  new Future.delayed(
      new Duration(seconds: 1), () => print('future #1 (delayed)'));

  new Future(() => print('future #2 of 4'))
      .then((_) => print('future #2a'))
      .then((_) {
    print('future #2b');

    scheduleMicrotask(() => print('microtask #0 (from future #2b)'));
  }).then((_) => print('future #2c'));

  scheduleMicrotask(() => print('microtask #2 of 3'));

  new Future(() => print('future #3 of 4'))
      .then((_) => new Future(() => print('future #3a (a new future)')))
      .then((_) => print('future #3b'));

  new Future(() => print('future #4 of 4'));

  scheduleMicrotask(() => print('microtask #3 of 3'));
  print('main #2 of 2');

  testFuture();
}

///1 new Future 会创建一个新的event task
///  future #3 of 4 执行完时，then创建新的task，此时future #4 of 4已经进入队列，
///  因此先执行future #4 of 4  后执行future #3a (a new future)
///
/// 2 scheduleMicrotask 会创建一个新的micro task
/// future #2b 执行后创建新的micro task，继续执行future #2 of 4 task的future #2c
/// 该task完成后，执行micro task   microtask #0 (from future #2b)

///执行结果     scheduleMicrotask创建一个新的micro task
///main #1 of 2
// main #2 of 2
// microtask #1 of 3
// microtask #2 of 3
// microtask #3 of 3
// future #2 of 4
// future #2a
// future #2b
// future #2c
// microtask #0 (from future #2b)
// future #3 of 4
// future #4 of 4
// future #3a (a new future)
// future #3b
// future #1 (delayed)

void testFuture() async {
  Future f = new Future(() => print('f1'));
  Future f1 = new Future(() => null);
  Future f2 = new Future(() => null);
  Future f3 = new Future(() => null);
  f3.then((_) => print('f2'));
  f2.then((_) {
    print('f3');
    new Future(() => print('f4'));
    f1.then((_) {
      print('f5');
    });
  });
  f1.then((m) {
    print('f6');
  });
  print('f7');
}

///执行结果
// f7
// f1
// f6
// f3
// f5
// f2
// f4
