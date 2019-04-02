//一个普普通通的Flutter应用的入口
//main函数这里有async关键字，是因为创建的isolate是异步的
import 'dart:isolate';

void main() async {
  //asyncFibonacci函数里会创建一个isolate，并返回运行结果
  print(await asyncFibonacci(20));
}

//这里以计算斐波那契数列为例，返回的值是Future，因为是异步的
Future<dynamic> asyncFibonacci(int n) async {
  //首先创建一个ReceivePort，为什么要创建这个？
  //因为创建isolate所需的参数，必须要有SendPort，SendPort需要ReceivePort来创建
  final response = new ReceivePort();
  //开始创建isolate,Isolate.spawn函数是isolate.dart里的代码,_isolate是我们自己实现的函数
  //_isolate是创建isolate必须要的参数。
  await Isolate.spawn(_isolate, response.sendPort);
  //获取sendPort来发送数据
  final sendPort = await response.first as SendPort;
  //接收消息的ReceivePort
  final answer = new ReceivePort();
  //发送数据
  sendPort.send([n, answer.sendPort]);
  //获得数据并返回
  return answer.first;
}

//创建isolate必须要的参数
void _isolate(SendPort initialReplyTo) {
  final port = new ReceivePort();
  //绑定
  initialReplyTo.send(port.sendPort);
  //监听
  port.listen((message) {
    //获取数据并解析
    final data = message[0] as int;
    final send = message[1] as SendPort;
    //返回结果
    send.send(syncFibonacci(data));
  });
}

int syncFibonacci(int n) {
  return n < 2 ? n : syncFibonacci(n - 2) + syncFibonacci(n - 1);
}
