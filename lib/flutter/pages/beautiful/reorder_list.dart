import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:w_reorder_list/w_reorder_list.dart';

///w_reorder_list 的不同实现方式
class ReorderListPage extends StatefulWidget {
  @override
  _ReorderListPageState createState() => _ReorderListPageState();
}

class ReorderListItem extends StatelessWidget {
  int index;
  BuildContext context;

  ReorderListItem({this.index, this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("item $index is taped");
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(8.0),
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.deepPurpleAccent),
        child: Text(
          "$index",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _ReorderListPageState extends State<ReorderListPage> {
  GlobalKey<ReorderListState> _key = GlobalKey();

  GlobalKey<WReorderListState> _wkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ReorderListPage"),
      ),
      body: ReorderList(
        key: _key,
        builder: (context, index) {
          return ReorderListItem(index: index, context: context);
        },
        onIndexChanged: (i, j) {
          print("ReorderList onIndexChanged $i $j");
        },
      )

      /*WReorderList(
        key: _wkey,
        children: List<Widget>.generate(20, (index) {
          return ReorderListItem(index: index, context: context);
        }),
        onIndexChanged: (i, j) {
          print("WReorderList onIndexChanged $i $j");
        },
      )*/
      ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (null != _key.currentWidget) {
            bool canSwap = _key.currentState.canSwap(0, 1);
            print("canSwap $canSwap");
            if (canSwap) {
              _key.currentState.swap(0, 1);
            }
          } else {
            _wkey.currentState.swap(0, 1);
          }
        },
        child: Text("交换"),
      ),
    );
  }
}

typedef IndexChanged<int> = void Function(int a, int b);

class ReorderList extends StatefulWidget {
  IndexedWidgetBuilder builder;
  IndexChanged onIndexChanged;
  ReorderList({@required this.builder, this.onIndexChanged, Key key}) : super(key: key);

  @override
  ReorderListState createState() => ReorderListState();
}

class ReorderListItemData {
  BuildContext context;
  double height = 0.0;

  ///要交换的item，没有就是默认index
  int swapTarget;
  @override
  String toString() {
    return " context ${context} height $height swapTarget $swapTarget";
  }
}

class ReorderListState extends State<ReorderList> with SingleTickerProviderStateMixin<ReorderList> {
  ///用于动画
  List<int> swaps = [];
  Map<int, ReorderListItemData> layoutDatas = Map();
  AnimationController _controller;
  int swapI = 0;
  int swapJ = 0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
//        print("_controller update");
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        print("status $status");
        if (status == AnimationStatus.completed) {
          setState(() {
            //清空要交换的数据
            swaps.clear();
//          交换item数据
            int targetI = layoutDatas[swapI].swapTarget;
            int targetJ = layoutDatas[swapJ].swapTarget;
            layoutDatas[swapI]..swapTarget = targetJ;
            layoutDatas[swapJ]..swapTarget = targetI;
            print("status complete layoutDatas[swapI] ${layoutDatas[swapI]} layoutDatas[swapJ] ${layoutDatas[swapJ]}");
            if (widget.onIndexChanged != null) {
              widget.onIndexChanged(swapI, swapJ);
            }
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return Builder(builder: (boxContext) {
        if (layoutDatas[index] == null || layoutDatas[index].context != boxContext) {
          //交换数据后 context发生改变
          layoutDatas[index] = ReorderListItemData()..context = boxContext;
          layoutDatas[index].swapTarget = index;
//          print(" index $index 重新复制======== ReorderListItemData ");
        }
        //build页面之前拿取信息
//        WidgetsBinding.instance.addPostFrameCallback((duration) {
//          //build页面之后拿去信息
//          print("context index $index ${context.findRenderObject().paintBounds}");
//          if (layoutDatas[index] == null || layoutDatas[index].context != boxContext) {
//            //交换数据后 context发生改变
//            layoutDatas[index] = ReorderListItemData()..context = boxContext;
//            layoutDatas[index].swapTarget = index;
//            print(" index $index 重新复制======== ReorderListItemData ");
//          }
//        });
//        print("layoutDatas[index].height ${layoutDatas[index]?.height}  _controller.value ${_controller.value}");
        int afterSwapIndex = layoutDatas[index]?.swapTarget != null ? layoutDatas[index].swapTarget : index;
//        print(
//            "layoutDatas[index]  ${layoutDatas[index]}  index $index afterSwapIndex $afterSwapIndex  layoutDatas[index]?.swapTarget ${layoutDatas[index]?.swapTarget}");
        return swaps.contains(index)
            ? Transform(
                transform: Matrix4.identity()..translate(0.0, layoutDatas[index].height * _controller.value),
                child: widget.builder(boxContext, afterSwapIndex))
            : Transform(
                transform: Matrix4.identity(),
                child: widget.builder(boxContext, afterSwapIndex),
              );
      });
    });
  }

  bool canSwap(int i, int j) {
    if (layoutDatas[i] == null ||
        layoutDatas[i].context.findRenderObject() == null ||
        !layoutDatas[i].context.findRenderObject().attached) {
      print("第$i个 尚未绘制");
      return false;
    }
    if (layoutDatas[j] == null ||
        layoutDatas[j].context.findRenderObject() == null ||
        !layoutDatas[i].context.findRenderObject().attached) {
      print("第$j个 尚未绘制");

      return false;
    }
    return true;
  }

  void swap(int i, int j) {
    if (!canSwap(i, j)) {
      throw FlutterError("第$i个或第$j个 尚未绘制");
    }
    swaps..add(i)..add(j);

//    RenderSliverList(childManager: null)
    RenderBox rbi = layoutDatas[i].context.findRenderObject();
    RenderBox rbj = layoutDatas[j].context.findRenderObject();
//    SliverPhysicalParentData parentDataI = rbi.parentData;
//    SliverPhysicalParentData parentDataJ = rbj.parentData;
//
    Offset iOffset = rbi.localToGlobal(Offset(rbi.paintBounds.width, rbi.paintBounds.height));
    Offset jOffset = rbj.localToGlobal(Offset(rbi.paintBounds.width, rbi.paintBounds.height));
    print("iOffset $iOffset jOffset $jOffset");
    layoutDatas[i].height = (jOffset - iOffset).dy;
    layoutDatas[j].height = (iOffset - jOffset).dy;
    print("i $i layoutDatas[i].swapTarget ${layoutDatas[i].swapTarget}");
    print("j $j layoutDatas[j].swapTarget ${layoutDatas[j].swapTarget}");
    print("change ================== ");
//    layoutDatas[i].swapTarget = j;
//    layoutDatas[j].swapTarget = i;
    print("i $i layoutDatas[i].swapTarget ${layoutDatas[i].swapTarget}");
    print("j $j layoutDatas[j].swapTarget ${layoutDatas[j].swapTarget}");

    swapI = i;
    swapJ = j;
    _controller.forward(from: 0.0);
  }
}
