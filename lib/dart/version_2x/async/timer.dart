import 'dart:async';

void main() {
  Timer? outTimer;
  outTimer = Timer.periodic(Duration(seconds: 5), (_timer) {
    print("${outTimer == _timer}  outTimer.hashCode  ${outTimer.hashCode} _timer.hashCode ${_timer.hashCode}");
    outTimer = _timer;
  });

  StreamController<int> controller = StreamController();
  Timer timer;
  timer = Timer.periodic(Duration(milliseconds: 16), (_timer) {
    print("readFirstStream  sink ========== ");
    controller.sink.add(1);
  });
  controller.stream.listen((data) {
    print("data $data");
  });
//  timer.cancel();
//  controller.close();
}
