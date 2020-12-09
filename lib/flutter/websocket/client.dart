import 'dart:io';

import 'package:flutter/material.dart';

class WebSocketClientPage extends StatefulWidget {
  @override
  _WebSocketClientPageState createState() => _WebSocketClientPageState();
}

class _WebSocketClientPageState extends State<WebSocketClientPage> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    ///链接socket server
    var socket = await WebSocket.connect('ws://10.24.61.65:4040/ws');
    socket.add('Hello, World!');
    socket.listen((event) {
      print("client receive Server: $event");
    });
    socket.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebSocketClientPage"),
      ),
    );
  }
}
