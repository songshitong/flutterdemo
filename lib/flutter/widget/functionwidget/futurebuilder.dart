//todo FutureBuilder  避免重绘https://blog.csdn.net/u011272795/article/details/83010974
import 'package:flutter/material.dart';

//https://book.flutterchina.club/chapter7/futurebuilder_and_streambuilder.html
//streambuilder
class FutureBuilderPage extends StatefulWidget {
  @override
  _FutureBuilderPageState createState() => _FutureBuilderPageState();
}

class _FutureBuilderPageState extends State<FutureBuilderPage> {
  late Future<String> _future;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("futrue builder"),
      ),
      body: Column(
        children: <Widget>[
          new FutureBuilder<String>(
            initialData: "init data",
            future: _future, // 用户定义的需要异步执行的代码，类型为Future<String>或者null的变量或函数
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              //snapshot就是_calculation在时间轴上执行过程的状态快照
              print("snapshot.connectionState ${snapshot.connectionState}");
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return new Text(
                      'Press button to start   data = ${snapshot.data}  error = ${snapshot.error}'); //如果_calculation未执行则提示：请点击开始
                case ConnectionState.waiting:
                  return new Text(
                      'Awaiting result...    data  = ${snapshot.data} error = ${snapshot.error}'); //如果_calculation正在执行则提示：加载中
                default: //如果_calculation执行完毕
                  if (snapshot.hasError) //若_calculation执行出现异常
                    return new Text('Error: ${snapshot.error} data = ${snapshot.data}');
                  else //若_calculation执行正常完成
                    return NormalState(snapshot);
              }
            },
          ),
          FlatButton(
            onPressed: () {
              start();
            },
            child: Text("开始"),
          )
        ],
      ),
    );
  }

  void start() {
    setState(() {
      _future = Future.delayed(Duration(seconds: 3), () {
        return "3 秒后";
      });
    });
  }
}

class NormalState extends StatefulWidget {
  AsyncSnapshot snapshot;

  NormalState(this.snapshot);

  @override
  _NormalStateState createState() => _NormalStateState();
}

class _NormalStateState extends State<NormalState> {
  @override
  void initState() {
    print("_NormalStateState initState  ===========");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Text('Result: ${widget.snapshot.data} error = ${widget.snapshot.error}');
  }
}
