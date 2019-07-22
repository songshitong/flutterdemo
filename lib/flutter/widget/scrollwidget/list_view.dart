import 'package:flutter/material.dart';

///SingleChildScrollView 嵌套 ListView 或listView嵌套ListView 不滚动的问题，禁用内部listview的滚动/内部primary设为false(发生滚动的是外部，使用NotificationListener监听)
class ListViewPage extends StatefulWidget {
  @override
  ListViewPageState createState() {
    return ListViewPageState();
  }
}

class ListViewPageState extends State<ListViewPage> {
  List<ScrollPhysics> physics = [
    ///android 微光效果
    ClampingScrollPhysics(),

    ///ios 回弹
    BouncingScrollPhysics(),
    NeverScrollableScrollPhysics(),
    AlwaysScrollableScrollPhysics(),

    ///需要限制长度
    FixedExtentScrollPhysics(),
  ];

  int physicIndex = 0;

  @override
  Widget build(BuildContext context) {
//    itemExtent：该参数如果不为null，则会强制children的"长度"为itemExtent的值；这里的"长度"是指滚动方向上子widget的长度，
//       即如果滚动方向是垂直方向，则itemExtent代表子widget的高度，如果滚动方向为水平方向，则itemExtent代表子widget的长度。
//       在ListView中，指定itemExtent比让子widget自己决定自身长度会更高效，这是因为指定itemExtent后，滚动系统可以提前知道列表的长度，而不是总是动态去计算，尤其是在滚动位置频繁变化时（滚动系统需要频繁去计算列表高度）。
//    shrinkWrap：该属性表示是否根据子widget的总长度来设置ListView的长度，默认值为false 。
//         默认情况下，ListView的会在滚动方向尽可能多的占用空间。当ListView在一个无边界(滚动方向上)的容器中时，shrinkWrap必须为true。
//         (！！！比如在column放一个无限长度的list报错，column是有限的)
//    addAutomaticKeepAlives：该属性表示是否将列表项（子widget）包裹在AutomaticKeepAlive widget中；
//         典型地，在一个懒加载列表中，如果将列表项包裹在AutomaticKeepAlive中，在该列表项滑出视口时该列表项不会被GC，它会使用KeepAliveNotification来保存其状态。如果列表项自己维护其KeepAlive状态，那么此参数必须置为false。
//    addRepaintBoundaries：默认true 该属性表示是否将列表项（子widget）包裹在RepaintBoundary中。
//         当可滚动widget滚动时，将列表项包裹在RepaintBoundary中可以避免列表项重绘，但是当列表项重绘的开销非常小（如一个颜色块，或者一个较短的文本）时，不添加RepaintBoundary反而会更高效。和addAutomaticKeepAlive一样，如果列表项自己维护其KeepAlive状态，那么此参数必须置为false
    return Scaffold(
      appBar: AppBar(
        title: Text("ListViewPage"),
        actions: <Widget>[
          DropdownButton(
              hint: Text(physics[physicIndex].toString()),
              items: List<DropdownMenuItem>.generate(physics.length, (index) {
                return DropdownMenuItem(
                  child: Text(physics[index].toString()),
                  value: index,
                );
              }),
              onChanged: (value) {
                setState(() {
                  physicIndex = value;
                });
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 通过children直接设置，适用于少量item的情况
            ListView(
              itemExtent: 100, //指定子item的高度
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              primary: false,

              ///primary true list没有足够的item也可以滚动  父里面主要可滚动view ScrollView -- primary
              ///
              ///多个listview，其他不能展开
              children: <Widget>[
                Container(color: Colors.black12, child: Text("aaaa")),
                Checkbox(
                    value: true,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      print("onchaged1 $value");
                    }),
                Checkbox(
                    value: true,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      print("onchaged1 $value");
                    }),
                Checkbox(
                    value: true,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      print("onchaged1 $value");
                    }),
              ],
            ),

            //大量数据的
            SizedBox(
              height: 200,
              child: ListView.builder(
                  physics: physics[physicIndex],
                  itemCount: 15, //列表项的数量，如果为null，则为无限列表
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(color: Colors.black12, child: Text("$index"));
                  }),
            ),

            ///带分割线的
            SizedBox(
              height: 200,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(color: Colors.blueGrey, child: Text("$index"));
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      //分割线
                      color: Colors.black,
                    );
                  },
                  itemCount: 20),
            ),
            SizedBox(
              height: 100,
              child: ListWheelScrollView(
                  controller: FixedExtentScrollController(),
                  physics: FixedExtentScrollPhysics(),
                  itemExtent: 20,
                  children: [
                    Text("list wheel1"),
                    Text("list wheel1"),
                    Text("list wheel2"),
                    Text("list wheel2"),
                    Text("list wheel2"),
                    Text("list wheel3"),
                    Text("list wheel3"),
                  ]),
            )

            ///可以对实际不展示的item的估算算法进行控制
            /*ListView.custom(
              shrinkWrap: true,
              semanticChildCount: 10,
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                return Text("custom");
              }),
            )*/
          ],
        ),
      ),
    );
  }
}
