import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdemo/flutter/pages/beautiful/reorder_list.dart';

import '../CheckBox.dart';
import 'load_more.dart';

///SingleChildScrollView 嵌套 ListView 或listView嵌套ListView 不滚动的问题，禁用内部listview的滚动/内部primary设为false(发生滚动的是外部，使用NotificationListener监听)
class ListViewPage extends StatefulWidget {
  @override
  ListViewPageState createState() {
    return ListViewPageState();
  }
}

class ListViewPageState extends State<ListViewPage> {
  GlobalKey keyBBB = GlobalKey();
  GlobalKey centerItemKey = GlobalKey();
  GlobalKey infoKey = GlobalKey();
  double offsetYAAA = 0.0;
  ScrollController _controller = ScrollController();
  ScrollController centerController = ScrollController();
  List<ScrollPhysics> physics = [
    ///android 微光效果
    ClampingScrollPhysics(),

    ///ios 回弹
    BouncingScrollPhysics(),
    NeverScrollableScrollPhysics(),
    AlwaysScrollableScrollPhysics(),

    ///需要限制长度
    FixedExtentScrollPhysics(),
    ScrollPhysics()
  ];

  int physicIndex = 0;

  static const loadingTag = "##loading##"; //表尾标记
//  var _words = <String>[loadingTag];
  var _words = <String>[];

  bool isShowIndicatorFirstTime = false;

  @override
  void initState() {
    _words.insert(0, loadingTag);
    _retrieveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //TODO AnimatedList
//    itemExtent：该参数如果不为null，则会强制children的"长度"为itemExtent的值；这里的"长度"是指滚动方向上子widget的长度，
//       即如果滚动方向是垂直方向，则itemExtent代表子widget的高度，如果滚动方向为水平方向，则itemExtent代表子widget的长度。
//       在ListView中，指定itemExtent比让子widget自己决定自身长度会更高效，这是因为指定itemExtent后，滚动系统可以提前知道列表的长度，而不是总是动态去计算，尤其是在滚动位置频繁变化时（滚动系统需要频繁去计算列表高度）。
//    shrinkWrap：该属性表示是否根据子widget的总长度来设置ListView的长度，默认值为false 。
//         默认情况下，ListView的会在滚动方向尽可能多的占用空间。当ListView在一个无边界(滚动方向上)的容器中时，shrinkWrap必须为true。
//         (！！！比如在column放一个无限长度的list报错，column是有限的)
//    addAutomaticKeepAlives：该属性表示是否将列表项（子widget）包裹在AutomaticKeepAlive widget中；
//         典型地，在一个懒加载列表中，如果将列表项包裹在AutomaticKeepAlive中，在该列表项滑出视口时该列表项不会被GC，它会使用KeepAliveNotification来保存其状态。如果列表项自己维护其KeepAlive状态，那么此参数必须置为false。
//           在确定不需要listview维持状态或者由其它维持状态时，关闭此选项可以提高性能
//           子item要实现AutomaticKeepAliveClientMixin，来通知触发

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
              }),
          RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return LoadMorePage();
                }));
              },
              child: Text("loadMore"))
        ],
      ),
      //TODO listview 缓存策略
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // 通过children直接设置，适用于少量item的情况
            ListView(
              controller: _controller,
              itemExtent: 100, //指定子item的高度
              shrinkWrap: true,
              addAutomaticKeepAlives: true,
              primary: false,

              ///primary true list没有足够的item也可以滚动  父里面主要可滚动view ScrollView -- primary
              ///
              ///多个listview，其他不能展开
              children: <Widget>[
                Transform(
                    transform: Matrix4.identity()..translate(0.0, offsetYAAA),
                    child: Container(color: Colors.black12, child: Text("aaaa"))),
                GestureDetector(
                    key: keyBBB,
                    onTap: () {
                      RenderBox rb = keyBBB.currentContext.findRenderObject();

                      setState(() {
                        print("rb.paintBounds ${rb.paintBounds}");
                        Offset localOffset = rb.paintBounds.topLeft;
                        offsetYAAA =
                            rb.localToGlobal(localOffset).dy - MediaQuery.of(context).padding.top - kToolbarHeight;
                        print("offsetYAAA  ===  $offsetYAAA  localOffset $localOffset");
                      });
                    },
                    //
                    // 另一种思路 交换位置，将交换位置暂存，刷新页面时 build将交换位置放为空白块，打开PopupRoute，此时可以使用context.findRenderObject
                    // 获取已渲染list的size（网络过慢时要不要判空？list没有渲染完成），执行动画(在popup中绘制相同的内容然后动画)，结束后监听Navigator.of(context).push.then();
                    // 返回到list页面，将空白位置重新替换为原内容，

                    // todo  各种key使用的总结
                    /// [ReorderListPage]  不使用popup，不使用globalkey 直接使用context+widgetsbings.addpostframecallback 获取渲染后的尺寸，做动画
                    /// 调用对外暴露的自定义的indexChange回调
                    child: Container(color: Colors.black12, child: Text("bbbb 点击b移动A到B的位置"))),
                Checkbox(
                    value: true,
                    activeColor: Colors.red,
                    onChanged: (value) {
                      //todo 自定义ScrollConfiguration ScrollBehavior 去掉蓝色回弹https://www.jianshu.com/p/b9e92c37f4ec
                      ///与[CustomScrollPhysics]去掉TODO
                      ScrollConfiguration(behavior: null, child: null);
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
            SizedBox(
              height: 50,
              child: CustomScrollView(scrollDirection: Axis.horizontal, controller: centerController, slivers: [
                SliverList(
                    key: centerItemKey,
                    delegate: SliverChildListDelegate(List.generate(20, (index) {
                      return GestureDetector(
                        onTap: () {
                          final paintExtent = getAllPaintExtentToIndex(centerItemKey, index);
                          var offset = paintExtent -
                              getPaintExtentOfIndex(centerItemKey, index) / 2 -
                              MediaQuery.of(context).size.width / 2;
                          print("center === offset $offset");
                          centerController.animateTo(offset,
                              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(color: Colors.amberAccent),
                          child: Text("$index"),
                        ),
                      );
                    })))
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  key: infoKey,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        var listRenderObj = infoKey.currentContext.findRenderObject();
//                        print("listRenderObj $listRenderObj");
//                        var renderObj1 = listRenderObj.child as RenderCustomPaint;
//                        print("renderObj1 $renderObj1");
                        var childSemantics = await callbackHellVisitChildrenSemantics(listRenderObj);
                        var visitChildrenSemanticsCount = 0;
                        while (null != (childSemantics = await callbackHellVisitChildrenSemantics(childSemantics))) {
                          print("child $childSemantics");
                          visitChildrenSemanticsCount++;
                          if (childSemantics is RenderSliverMultiBoxAdaptor) {
                            print("Semantics i found you visitChildrenSemanticsCount $visitChildrenSemanticsCount");
                            break;
                          }
                          print("break ? ======");
                        }

                        var visitChildrenCount = 0;
                        var child = await callbackHellVisitChildren(listRenderObj);
                        while (null != (child = await callbackHellVisitChildren(child))) {
                          visitChildrenCount++;
                          print("child $child");
                          if (child is RenderSliverMultiBoxAdaptor) {
                            print("VisitChildren i found you visitChildrenCount $visitChildrenCount");
                            break;
                          }
                          print("break ? ======");
                        }
                        listRenderObj.visitChildren((render) {
                          print("render is $render");
                          if (render is RenderSliverMultiBoxAdaptor) {
                            print("render $render");
                          }
                          render.visitChildren((render1) {
                            print("render1 $render1");
                            render1.visitChildren((render2) {
                              print("render2 $render2");
                              render2.visitChildren((render3) {
                                print("render3 $render3");
                                render3.visitChildren((render4) {
                                  print("render4 $render4");
                                  render4.visitChildren((render5) {
                                    print("render5 $render5");
                                    render5.visitChildren((render6) {
                                      print("render6 $render6");
                                      render6.visitChildren((render7) {
                                        print("render7 $render7");
                                        render7.visitChildren((render8) {
                                          print("render8 $render8");
                                          render8.visitChildren((render9) {
                                            print("render9 $render9");
                                            render9.visitChildren((render10) {
                                              print("render10 $render10");
                                              if (render10 is RenderSliverMultiBoxAdaptor) {
                                                print("callback hell i found you =====");
                                              }
                                            });
                                          });
                                        });
                                      });
                                    });
                                  });
                                });
                              });
                            });
                          });
                        });

//                        var child = listRenderObj.firstChild as RenderObject;
//                        var childParentData = child.parentData as ContainerBoxParentData;
//                        while (null != (child = childParentData.nextSibling)) {
//                          if (child is RenderSliverMultiBoxAdaptor) {
//                            print("get RenderSliverMultiBoxAdaptor === ");
//                            break;
//                          }
//                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(color: Colors.amberAccent),
                        child: Text("$index"),
                      ),
                    );
                  },
                  itemCount: 20,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            //大量数据的
            SizedBox(
              height: 200,
              child: ListView.builder(
                  physics: physics[physicIndex],
                  itemCount: 15, //列表项的数量，如果为null，则为无限列表
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {}, child: Container(color: Colors.black12, child: Text("$index")));
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
            ),

//            ///可以对实际不展示的item的估算算法进行控制
            ListView.custom(
              shrinkWrap: true,
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                return Text("custom");
              }, childCount: 10),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 20,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (context, index) {
                    return AliveListItem();
                  }),
            ),
            SizedBox(
              height: 500,
              child: ListView.builder(
                  itemCount: _words.length,
                  itemBuilder: (context, index) {
//                    return IndicatorLoadMore(
//                      isShowIndicator: isShowIndicatorFirstTime,
//                      loadData: () {
//                        _retrieveData();
//                      },
//                      maxCount: 100,
//                      endWidget: Container(
//                          alignment: Alignment.center,
//                          padding: EdgeInsets.all(16.0),
//                          child: Text(
//                            "没有更多了",
//                            style: TextStyle(color: Colors.grey),
//                          )),
//                      child: ListTile(title: Text(_words[index])),
//                      isLoadMore: () {
//                        return _words[index] == loadingTag;
//                      },
//                      isReachEnd: () {
//                        return _words.length - 1 < 100;
//                      },
//                    );

                    return IndicatorLoadMore2(
                      data: _words,
                      index: index,
                      loadTag: loadingTag,
                      isShowIndicator: isShowIndicatorFirstTime,
                      loadData: () {
                        _retrieveData();
                      },
                      maxCount: 100,
                      endWidget: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            "没有更多了",
                            style: TextStyle(color: Colors.grey),
                          )),
                      child: ListTile(title: Text(_words[index])),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 4)).then((e) {
      _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          List.generate(20, (index) {
            return "index $index";
          }));
      setState(() {
        //重新构建列表
        isShowIndicatorFirstTime = true;
      });
    });
  }

  //解决回调地狱
  Future<RenderObject> callbackHellVisitChildrenSemantics(RenderObject obj) {
    var result;
    obj.visitChildrenForSemantics((render) {
      result = render;
    });
    return Future.value(result);
  }

  //解决回调地狱  todo context.visitelement
  Future<RenderObject> callbackHellVisitChildren(RenderObject obj) {
    var result;
    obj.visitChildren((render) {
      result = render;
    });
    return Future.value(result);
  }

  //垂直是高度，水平布局是宽度  坐标？？好像不是
  //todo 自定义renderObject情况， 寻找listview的renderobject  renderobject树，widget树是怎么生成的，怎么查找子renderObject

  //setsate 更新范围，机制
  double getAllPaintExtentToIndex(GlobalKey key, int index) {
    RenderSliverMultiBoxAdaptor renderObject = key.currentContext.findRenderObject() as RenderSliverMultiBoxAdaptor;
    //list的属性
    var top = renderObject.paintBounds.top;
    var bottom = renderObject.paintBounds.bottom;
    var left = renderObject.paintBounds.left;
    var right = renderObject.paintBounds.right;
    print("list  top $top  bottom $bottom left $left right $right ");
    var child = renderObject.firstChild;
    var paintExtent = 0.0;
    paintExtent = renderObject.paintExtentOf(child) + renderObject.childScrollOffset(child);
    print("firstChild paintExtent $paintExtent");
    if (index > 0) {
      //缺点在绘制完成后使用
      //第0个已经取得高度了，所以进行判断
      //不进行判断，while中childIndex一直大于0，此时获取的第一个高度为list的总高度
      while ((child = renderObject.childAfter(child)) != null) {
        //todo 方法性能分析，缓存区存在，first一直是缓存区第一个，方法时间复杂度不会太高
        // childScrollOffset是什么 由于缓存存在，只有可见及缓存区的总高度可加，第一个到index的高度通过childScrollOffset来获得
        paintExtent = renderObject.paintExtentOf(child) + renderObject.childScrollOffset(child);
        var childIndex = renderObject.indexOf(child);
        if (childIndex == index) {
          break;
        }
      }
    }

    print("index $index paintExtent $paintExtent");
    return paintExtent;
  }

  //TODO listview 设置itemcount 和不设置的初始化 shrikwrap
  //todo 获取第一个可见https://github.com/flutter/flutter/issues/19941
  double getPaintExtentOfIndex(GlobalKey key, int index) {
    RenderSliverMultiBoxAdaptor renderObject = key.currentContext.findRenderObject() as RenderSliverMultiBoxAdaptor;
    var child = renderObject.firstChild;
    var paintExtent = 0.0;
    paintExtent = renderObject.paintExtentOf(child);
    print("firstChild paintExtent $paintExtent");
    if (index > 0) {
      //缺点在绘制完成后使用
      //第0个已经取得高度了，所以进行判断
      //不进行判断，while中childIndex一直大于0，此时获取的第一个高度为list的总高度
      while ((child = renderObject.childAfter(child)) != null) {
        paintExtent = renderObject.paintExtentOf(child);
        var childIndex = renderObject.indexOf(child);
        if (childIndex == index) {
          break;
        }
      }
    }
    var point = child.localToGlobal(Offset.zero);
    print("index $index paintExtent $paintExtent dx ${point.dx} dy ${point.dy}");
    return paintExtent;
  }
}

///TODO 滚动到底判断  iOS bunce回弹效果是否会有影响，滚动停止后判断？？
//////maxScrollExtent 可以滑动的最大距离
//bool isBottom = widget.scrollController.position.pixels ==
//        widget.scrollController.position.maxScrollExtent;

//itembuilder 中的居中算法
//var indexOffset = index * ws(130 + 48 + 48) - ws(93);  //item的大小及listview的偏移
//                  var middleOffset = _controller.offset + MediaQuery.of(context).size.width / 2;
////                  LogUtil.debug(
////                      "_controller.offset ${_controller.offset} indexOffset $indexOffset middleOffset $middleOffset");
//                  _controller.animateTo(indexOffset + (indexOffset - middleOffset) / 2,
//                      duration: Duration(milliseconds: 300), curve: Curves.easeOut);

//item 累加 RenderSliverMultiBoxAdaptor renderObject进行计算

class AliveListItem extends StatefulWidget {
  BuildContext context;
  int index;

  AliveListItem({this.context, this.index});

  @override
  _AliveListItemState createState() => _AliveListItemState();
}

class _AliveListItemState extends State<AliveListItem> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AliveCheckbox(value: false, onChange: (active) {});
  }

  @override
  bool get wantKeepAlive => true;
}

typedef BoolReturnFunction = bool Function();

//加载更多指示器
class IndicatorLoadMore extends StatefulWidget {
  VoidCallback loadData;
  Widget indicator;
  int maxCount;
  BoolReturnFunction isReachEnd;
  BoolReturnFunction isLoadMore;
  Widget child;
  Widget endWidget;
  bool isShowIndicator;

  ///解决网络问题时，一直加载的  网络问题改为false
  bool isLoadData;
  IndicatorLoadMore(
      {this.loadData,
      this.indicator,
      this.maxCount,
      this.isReachEnd,
      this.isLoadMore,
      this.child,
      this.endWidget,
      this.isShowIndicator = true,
      this.isLoadData = true});

  @override
  _IndicatorLoadMoreState createState() => _IndicatorLoadMoreState();
}

class _IndicatorLoadMoreState extends State<IndicatorLoadMore> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadData) {
      //如果到了表尾
      if (widget.isLoadMore()) {
        //不足maxCount条，继续获取数据
        if (widget.isReachEnd()) {
          //获取数据
          widget.loadData();
          //加载时显示loading
          if (widget.isShowIndicator) {
            if (null != widget.indicator) {
              return widget.indicator;
            }
            return LoadDefaultIndicator();
          } else {
            return Container();
          }
        } else {
          //已经加载了maxCount条数据，不再获取数据。
          return widget.endWidget;
        }
      } else {
        return widget.child;
      }
    } else {
      return SizedBox.shrink();
    }
  }
}

//加载更多指示器2.0版  将触发条件，内置tag统一
class IndicatorLoadMore2 extends StatefulWidget {
  VoidCallback loadData;
  Widget indicator;
  int maxCount;
  Widget child;
  Widget endWidget;
  bool isShowIndicator;
  int index;
  var loadTag;
  List data;

  ///解决网络问题时，一直加载的  网络问题改为false
  bool isLoadData;
  IndicatorLoadMore2(
      {@required this.index,
      @required this.loadData,
      this.indicator,
      @required this.maxCount,
      @required this.child,
      @required this.loadTag,
      @required this.data,
      this.endWidget,
      this.isShowIndicator = true,
      this.isLoadData = true});

  @override
  _IndicatorLoadMore2State createState() => _IndicatorLoadMore2State();
}

class _IndicatorLoadMore2State extends State<IndicatorLoadMore2> {
  @override
  void initState() {
    print("_IndicatorLoadMore2State initState ==== ");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoadData) {
      //如果到了表尾
      print("isloadMore ${widget.data[widget.index] == widget.loadTag} ====");
      if (widget.data[widget.index] == widget.loadTag) {
        //不足maxCount条，继续获取数据
        print("isReachEnd ${widget.data.length - 1 < widget.maxCount} ====");

        if (widget.data.length - 1 < widget.maxCount) {
          //获取数据
          widget.loadData();
          //加载时显示loading
          if (widget.isShowIndicator) {
            if (null != widget.indicator) {
              return widget.indicator;
            }
            return LoadDefaultIndicator();
          } else {
            return Container();
          }
        } else {
          if (widget.data.length > 0) {
            //已经加载了maxCount条数据，不再获取数据。
            return widget.endWidget;
          } else {
            ///空list返回 空box
            return Container();
          }
        }
      } else {
        return widget.child;
      }
    } else {
      return Container();
    }
  }
}

class LoadDefaultIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: CupertinoActivityIndicator() /*CircularProgressIndicator(strokeWidth: 2.0)*/),
      ),
    );
  }
}
