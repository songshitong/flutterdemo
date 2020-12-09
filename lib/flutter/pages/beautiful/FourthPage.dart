import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FourthPageState();
  }
}

class FourthPageState extends State<FourthPage> {
  Widget header() {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.only(top: 2, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("名次")],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("会员号/姓名")],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.pink,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("特征/环号")],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("空距/分速")],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("归巢时间")],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("关赛名次")],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.red,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("关赛名称")],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemList() {
    return Container(
      child: Column(
        children: <Widget>[row1()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.horizontal,
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            width: 682,
            child: ListView.builder(
                cacheExtent: 2000,
                itemCount: 50,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return header();
                  } else {
                    return RepaintBoundary(child: itemList());
                  }
                }),
          ),
        )
      ],
    );
  }
}

class row1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            width: 97,
            child: Column(
              children: [
                Container(
                  child: Text("12344",
                      style: TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis),
                  margin: EdgeInsets.only(top: 10),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 7),
                  child: Text("毕天笑",
                      style: TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                )
              ],
            ),
          ),
          Column(
            children: <Widget>[
              row2(),
              row2(),
            ],
          )
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 1), //边框
      ),
    );
  }
}

class row2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 97,
          child: Column(
            children: [
              Container(
                child: Text("12344",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                margin: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 7),
                child: Text("毕天笑",
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[
            row3(),
            row3(),
            row3(),
            row3(),
            row3(),
          ],
        )
      ],
    );
  }
}

class row3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 97,
          child: Column(
            children: [
              Container(
                child: Text("12344",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                margin: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 7),
                child: Text("毕天笑",
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[
            row4(),
          ],
        )
      ],
    );
  }
}

class row4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 97,
          child: Column(
            children: [
              Container(
                child: Text("12344",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                margin: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 7),
                child: Text("毕天笑",
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[row5()],
        )
      ],
    );
  }
}

class row5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 97,
          child: Column(
            children: [
              Container(
                child: Text("12344",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                margin: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 7),
                child: Text("毕天笑",
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[row6()],
        )
      ],
    );
  }
}

class row6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 97,
          child: Column(
            children: [
              Container(
                child: Text("12344",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                margin: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 7),
                child: Text("毕天笑",
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[row7(), row7()],
        )
      ],
    );
  }
}

class row7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 97,
          child: Column(
            children: [
              Container(
                child: Text("12344",
                    style: TextStyle(fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                margin: EdgeInsets.only(top: 10),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 7),
                child: Text("毕天笑",
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis),
              )
            ],
          ),
        ),
        Column(
          children: <Widget>[],
        )
      ],
    );
  }
}
