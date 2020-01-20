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
///使用controller相同，基本上要求初始屏超过viewport，一般超过一屏发生滚动才可以  是不是初始化，可以加载全部，如果listview没有限制怎么办？？
/// _scrollController.position.pixels ==
//        _scrollController.position.maxScrollExtent

/// list的itemcount>0 自动build,分页自动获取接口数据，数据更新，自动刷新页面
/// itemcount=0, 初次加载没有build，手动调用接口，数据更新，刷新页面

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

///改良版   +通过list的itemcount设置，不操作list数据源，减少对后续数据源操作的影响
///      是否加载更多通过监听滚动进度完成，而不是靠每次build触发，通过分页限制每次同时item build的数量
class LoadMoreListWidget extends StatefulWidget {
  int maxCount;
  int itemCount;
  Widget loadingWidget;
  Widget endWidget;
  ValueGetter<Future> loadData;
  bool isInitData;
  ScrollController loadListenController;
  ScrollController listController;

  VoidCallback onEnd;
  VoidCallback onLoading;
  bool isShowLoading;
  Axis scrollDirection;
  bool shrinkWrap;
  ScrollPhysics physics;
  IndexedWidgetBuilder itemBuilder;
  bool isShowEndWidget;
  LoadMoreListWidget(
      {@required this.maxCount,
      @required this.itemCount,
      this.loadingWidget,
      this.endWidget,
      @required this.loadData,
      this.isInitData = true,
      @required this.loadListenController,
      this.listController,
      this.onEnd,
      this.onLoading,
      this.isShowLoading = true,
      this.scrollDirection = Axis.vertical,
      this.shrinkWrap = true,
      this.physics = const AlwaysScrollableScrollPhysics(),
      @required this.itemBuilder,
      this.isShowEndWidget = true})
      : assert(null != isShowLoading);

  @override
  _LoadMoreListWidgetState createState() => _LoadMoreListWidgetState();
}

class _LoadMoreListWidgetState extends State<LoadMoreListWidget> {
  ///只有一个？
  bool isStartListen = true;

  @override
  void initState() {
    super.initState();
    if (widget.isInitData) {
      widget?.loadData();
    }
    if (null != widget.loadListenController && widget.loadListenController.hasClients) {
      widget.loadListenController.addListener(() {
        if (widget.loadListenController.position.pixels == widget.loadListenController.position.maxScrollExtent) {
          print(
              "widget.itemCount == widget.maxCount ${widget.itemCount} ${widget.maxCount} isStartListen $isStartListen");
          if (widget.itemCount == widget.maxCount) {
            //结束
            if (null != widget.onEnd) {
              widget.onEnd();
            }
            print("scorll on End ====");
          } else if (widget.itemCount < widget.maxCount) {
            if (!isStartListen) return;
            if (null != widget?.onLoading) {
              widget.onLoading();
            }
            isStartListen = false;
            print("scorll on loading ====");
            widget?.loadData().then((_) {
              print("scorll on end ====");
              //结束
              isStartListen = true;
              if (null != widget?.onLoading) {
                widget.onLoading();
              }
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.itemCount > 0 ? widget.itemCount + 1 : 0,
        scrollDirection: widget.scrollDirection,
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        controller: widget.listController,
        itemBuilder: (context, index) {
          if (index != widget.maxCount) {
            if (index == widget.itemCount) {
              //最后一个
              return Visibility(visible: widget.isShowLoading, child: widget.loadingWidget ?? LoadDefaultIndicator());
            } else {
              return widget.itemBuilder(context, index);
            }
          } else {
            ///endWidget
            return Visibility(
                visible: widget.isShowEndWidget,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: widget.endWidget ?? DefaultLoadMoreEndWidget(),
                ));
          }
        });
  }
}

class DefaultLoadMoreEndWidget extends StatelessWidget {
  ScrollController controller;

  ///监听滚动，小于一屏不展示
  bool isShowOnOverScreen;
  DefaultLoadMoreEndWidget({this.controller, this.isShowOnOverScreen = true});

  @override
  Widget build(BuildContext context) {
    var visible = true;
    if (null != controller && isShowOnOverScreen && controller.position.pixels < MediaQuery.of(context).size.height) {
      visible = false;
    }
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                width: 200,
                child: Divider(
                  height: 9,
                  color: Colors.black54,
                )),
            Text(
              "    end    ",
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(
                width: 200,
                child: Divider(
                  height: 9,
                  color: Colors.black87,
                ))
          ],
        )),
      ),
    );
  }
}
