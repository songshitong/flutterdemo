import 'package:flutter/material.dart';

class FlexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flex"),
      ),
      body: Column(
        children: <Widget>[
          //flex弹性布局允许子widget按照一定比例来分配父容器空间
          //expand  按比例“扩伸”Row、Column和Flex子widget所占用的主轴空间,
          // flex为弹性系数，如果为0或null，则child是没有弹性的，即不会被扩伸占用的空间
          // 如果大于0，所有的Expanded按照其flex的比例来分割主轴的全部空闲空间
          //spacer 对Expanded的包装，实际是个空盒子

          //Flexible 让子child充满flex的主轴，text可以自动换行
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Container(
                color: Colors.red,
                child: Text("1111"),
              ),
              Spacer(flex: 1),
              Container(
                color: Colors.green,
                child: Text("22222222"),
              )
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.red,
                  child: Text("1111"),
                ),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.green,
                  child: Text("22222222"),
                ),
              )
            ],
          ),
          Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.red,
                  child: Text("1111"),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Colors.green,
                  child: Text("22222222"),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Flexible(child: Text('afafafdasfdadfafdadfafajdf;alsjfda;ksfjda;sdfjas')),
            ],
          ),
          Row(
            children: <Widget>[
              /// 让flex系列的cild可以占满主轴,非强制的，text充满后自动换行
              Flexible(child: Text('afafafdasfdadfafdadfafajdf;alsjfda;ksfjda;sdfjas;kfdjaafasfasfasfdafa')),
            ],
          )
        ],
      ),
    );
  }
}
