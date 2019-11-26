import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/flutter/widget/scrollwidget/list_view.dart';

class LoadMorePage extends StatefulWidget {
  @override
  _LoadMorePageState createState() => _LoadMorePageState();
}

class _LoadMorePageState extends State<LoadMorePage> {
  int maxCount = 100;
  List<String> _words = [];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoadMore Page"),
      ),
      body: LoadMoreNotification(
          maxCount: maxCount,
          itemCount: _words.length,
          loadingWidget: CupertinoActivityIndicator(),
          endWidget: Text("end"),
          listChild: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _words.length,
                itemBuilder: (context, index) {
                  return Text("$index");
                }),
          ),
          loadData: () {
            return _retrieveData();
          }),
    );
  }

  Future _retrieveData() {
    Future future = Future.delayed(Duration(seconds: 4)).then((e) {
      _words.addAll(
          //每次生成20个单词
          List.generate(20, (index) {
        return "index $index";
      }));
      setState(() {
        //重新构建列表
      });
    });
    return future;
  }
}

///缺点必须滚动才能监听到
///使用controller相同，基本上要求初始屏超过viewport，一般超过一屏发生滚动才可以
/// _scrollController.position.pixels ==
//        _scrollController.position.maxScrollExtent

class LoadMoreNotification extends StatefulWidget {
  int maxCount;
  int itemCount;
  Widget listChild;
  Widget loadingWidget;
  Widget endWidget;
  ValueGetter<Future> loadData;

  LoadMoreNotification(
      {@required this.maxCount,
      @required this.itemCount,
      @required this.listChild,
      this.loadingWidget,
      this.endWidget,
      @required this.loadData});

  @override
  _LoadMoreNotificationState createState() => _LoadMoreNotificationState();
}

class _LoadMoreNotificationState extends State<LoadMoreNotification> {
  bool contentVisible = true;
  bool loadVisible = false;
  bool endVisible = false;
  bool isStartListen = true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollEndNotification>(
        onNotification: (t) {
          print("scroll end ==== ");
          if (widget.itemCount == widget.maxCount) {
            endVisible = true;
            contentVisible = true;
            loadVisible = false;
          } else if (widget.itemCount < widget.maxCount) {
            if (!isStartListen) return true;
            endVisible = false;
            contentVisible = true;
            loadVisible = true;
            isStartListen = false;
            widget?.loadData().then((_) {
              isStartListen = true;
              endVisible = false;
              contentVisible = true;
              loadVisible = false;
            });
          }

          setState(() {});
          return true;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ///列表
            Visibility(visible: contentVisible, child: widget.listChild),

            ///loading
            Visibility(visible: loadVisible, child: widget.loadingWidget ?? LoadDefaultIndicator()),

            ///endWidget
            Visibility(visible: endVisible, child: widget.endWidget ?? DefaultEndWidget())
          ],
        ));
  }
}

class DefaultEndWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("end");
  }
}
