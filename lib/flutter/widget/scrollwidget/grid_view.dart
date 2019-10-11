import 'package:flutter/material.dart';

class GridViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GriedViewPage"),
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          children: <Widget>[
            //GridView.count构造函数内部使用了SliverGridDelegateWithFixedCrossAxisCount，
            //我们通过它可以快速的创建横轴固定数量子元素的GridView
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,

              ///横轴个数
              crossAxisCount: 3,

              ///主轴item间距
              mainAxisSpacing: 10,
              crossAxisSpacing: 20,

              /// item 横轴/纵轴  的比例  crossAxisCount确定后就可以确定item横轴大小，根据比例可以得到纵轴大小
              childAspectRatio: 2,
              children: <Widget>[
                buildContainer("text1"),
                buildContainer("text2"),
                buildContainer("text3"),
                buildContainer("text4"),
                buildContainer("text5"),
                buildContainer("text6"),
              ],
            ),
//          GridView.extent构造函数内部使用了SliverGridDelegateWithMaxCrossAxisExtent，
//          我们通过它可以快速的创建纵轴子元素为固定最大长度的的GridView
//          maxCrossAxisExtent为子元素在横轴上的最大长度，之所以是“最大”长度，是因为横轴方向每个子元素的长度仍然是等分的，
//          举个例子，如果ViewPort的横轴长度是450，那么当maxCrossAxisExtent的值在区间(450/4，450/3]内的话，子元素最终实际长度都为150
            GridView.extent(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),

              maxCrossAxisExtent: 180,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,

              /// item 横轴/纵轴  的比例  crossAxisCount确定后就可以确定item横轴大小，根据比例可以得到纵轴大小
              childAspectRatio: 2,
              children: <Widget>[
                buildContainer("text1"),
                buildContainer("text2"),
                buildContainer("text3"),
                buildContainer("text4"),
                buildContainer("text5"),
                buildContainer("text6"),
                buildContainer("text7"),
                buildContainer("text8"),
                buildContainer("text9"),
                buildContainer("text10"),
                buildContainer("text11"),
                buildContainer("text12"),
              ],
            ),

            ///大量数据
            GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return buildContainer("text$index");
                })
          ],
        ),
      ),
    );
  }

  Container buildContainer(String txt) => Container(color: Colors.black12, child: Text(txt));
}
