import 'package:stack_trace/stack_trace.dart';

void main() {
  StudentInfo studentInfo = StudentInfo()..name = "小李";

  ///打印类名
  print("class name ${studentInfo.runtimeType}");
  studentInfo.sayHello();
  print("current trace ${StackTrace.current}");
}

class StudentInfo {
  String? name;
  void sayHello() {
    print(
        "method name ${Trace.current().frames[0].member} location  ${Trace.current().frames[0].location}");
    print("hello");
    print("frames[1] name ${Trace.current().frames[1].member}");
    print("hello ----- end");
  }
}
