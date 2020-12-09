import 'dart:io';

///启动 dart  lib/flutter/websocket/server.dart
void main() async {
  try {
    var server = await HttpServer.bind(InternetAddress.anyIPv4, 4040);
    await for (HttpRequest req in server) {
      if (req.uri.path == '/ws') {
        // 将一个HttpRequest提升为WebSocket连接
        var socket = await WebSocketTransformer.upgrade(req);
        socket.listen((event) {
          print(
              "接收到来自 ${req.connectionInfo!.remoteAddress.address}:${req.connectionInfo!.remotePort} 的消息：${event}");

          socket.add("数据已接收！");
        });
      }
    }
  } catch (e) {
    print(e);
  }
}
