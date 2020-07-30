import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';

///1 进入退出页面 查看图片内容是否回收
class ListViewMemoryPage extends StatefulWidget {
  @override
  _ListViewMemoryPageState createState() => _ListViewMemoryPageState();
}

///滑动不加载
class _ListViewMemoryPageState extends State<ListViewMemoryPage> {
  bool isScrolling = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ListViewMemoryPage"),
      ),
      body: NotificationListener<ScrollStartNotification>(
        onNotification: (ScrollStartNotification startNotification) {
          print("startNotification ====");
          isScrolling = true;
          return false;
        },
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification endNotification) {
            print("endNotification ====");
            isScrolling = false;
            setState(() {});
            return false;
          },
          child: ListView.builder(
              itemCount: 1000,
              cacheExtent: 500,
              itemBuilder: (context, index) {
                return ListItem(index, isScrolling);
              }),
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  int index;
  bool isScrolling;
  ListItem(this.index, this.isScrolling);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  List<String> imgs = [
    MyImgs.JINX,
    MyImgs.water_container,
    MyImgs.EARRINGS,
    MyImgs.SUNNIES,
    MyImgs.SANTAIZI,
    MyImgs.HAT,
    MyImgs.midouzi
  ];
  @override
  void initState() {
    print("item init state ${widget.index}");
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("item didChangeDependencies ${widget.index}");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(ListItem oldWidget) {
    print("item didUpdateWidget ${widget.index}");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    print("item dispose  ${widget.index}");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isScrolling
        ? Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: Colors.grey),
          )
        : Stack(
            children: <Widget>[
              Image.asset(
                imgs[widget.index % imgs.length],
                width: 50,
                height: 50,
              ),
              Text("${widget.index}")
            ],
          );
  }
}
