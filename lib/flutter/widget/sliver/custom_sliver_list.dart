import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdemo/flutter/pages/beautiful/lable_widget.dart';
import 'dart:math' as math;

import 'package:intl/intl.dart';

///
/// 自定义sliver  实现类似FlowLayout的效果
/// 代码来自RenderSliverList,做了更改
/// 参考文章 https://juejin.im/post/5d07463cf265da1b916393ad
class CustomSliverPage extends StatefulWidget {
  @override
  _CustomSliverState createState() => _CustomSliverState();
}

class _CustomSliverState extends State<CustomSliverPage> {
  static const String flowBoxList = "FlowBoxList";
  static const String listView = "listView";
  static const String gridView = "gridView";
  var datas = <String>[flowBoxList, listView, gridView];
  var textIndex = 0;
  @override
  Widget build(BuildContext context) {
    var widget;
    if (textIndex == 0) {
      widget = FlowBoxList(childrenDelegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("index$index"),
        );
      }));
    } else if (textIndex == 1) {
      widget = ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("index$index"),
        );
      });
    } else if (textIndex == 2) {
      widget = GridView.builder(
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("index$index"),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("自定义sliver"),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                textIndex++;
                if (textIndex > 2) {
                  textIndex = 0;
                }
                setState(() {});
              },
              child: Text(datas[textIndex]),
            )
          ],
        ),
        body: widget);
  }
}

class FlowBoxList extends BoxScrollView {
  @override
  Widget buildChildLayout(BuildContext context) {
    return SliverFlow(
      delegate: this.childrenDelegate,
    );
  }

  final SliverChildDelegate childrenDelegate;
  FlowBoxList({this.childrenDelegate});
}

class SliverFlow extends SliverMultiBoxAdaptorWidget {
  const SliverFlow({
    Key key,
    @required SliverChildDelegate delegate,
  }) : super(key: key, delegate: delegate);

  @override
  RenderSliverFlow createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context;
    return RenderSliverFlow(childManager: element);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverFlow renderObject) {
    super.updateRenderObject(context, renderObject);
  }
}

class RenderSliverFlow extends RenderSliverMultiBoxAdaptor {
  RenderSliverFlow({RenderSliverBoxChildManager childManager}) : super(childManager: childManager);
  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverFlowParentData) child.parentData = SliverFlowParentData();
  }

  @override
  double childCrossAxisPosition(RenderBox child) {
    final SliverFlowParentData childParentData = child.parentData;
    double childCrossAxisPosition = 0.0;
    if (null != childParentData.crossAxisOffset) {
      childCrossAxisPosition = childParentData.crossAxisOffset;
    }
//    print("index ${indexOf(child)} crossAxisOffset $childCrossAxisPosition");
    return childCrossAxisPosition;
  }

  @override
  void performLayout() {
    print("performLayout ===== ");
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);
    print("constraints $constraints");
    final double scrollOffset = constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    final BoxConstraints childConstraints = transform2BoxConstraints();
    int leadingGarbage = 0;
    int trailingGarbage = 0;
    bool reachedEnd = false;

//    这个算法原则上是直截了当的：找到与给定的scrollOffset重叠的第一个子元素，必要时在列表顶部创建更多的子元素，
//     然后在列表中遍历更新和布局每个子元素，必要时在末尾添加更多子元素，直到我们有足够的子元素覆盖整个视口。

//    有一个小问题很复杂，那就是无论何时更新或创建子项，都有可能删除一些尚未布局的子项，使列表处于不一致的状态，并要求重新创建缺少的节点。

//    为了保持这种混乱的可处理性，该算法从当前的第一个子节点（如果有的话）开始，然后从那里上下移动，以便可能被删除的节点始终位于已布局的边缘

    //确保我们至少有一个孩子。
    if (firstChild == null) {
      if (!addInitialChild()) {
        // 没有child
        geometry = SliverGeometry.zero;
        childManager.didFinishLayout();
        return;
      }
    }

    //我们至少有一个child

    //这些变量跟踪我们所安排的孩子的范围。在这个范围内，孩子们有连续的指数。在这个范围之外，孩子有可能在没有通知的情况下被移除
    // （布局cache部分）
    RenderBox leadingChildWithLayout, trailingChildWithLayout;
//    查找scrollOffset处或之前的最后一个子项
    RenderBox earliestUsefulChild = firstChild;
    double firstChildScrollOffset = 0.0;
    double leadingLineCross = 0.0;
    print("init for earliestScrollOffset ${childScrollOffset(earliestUsefulChild)} scrollOffset $scrollOffset");
    //sliver list 只要有一个满足earliestScrollOffset > scrollOffset就退出for循环
    //在该list中，有多个满足
//    for (double earliestScrollOffset = childScrollOffset(earliestUsefulChild);
//        earliestScrollOffset > scrollOffset;
//        earliestScrollOffset = childScrollOffset(earliestUsefulChild)) {
////    我们得在最早的孩子之前加上孩子。
//      earliestUsefulChild = insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
//      print("earliestUsefulChild for index ${indexOf(earliestUsefulChild)}");
//      if (earliestUsefulChild == null) {
//        final SliverFlowParentData childParentData = firstChild.parentData;
//        childParentData.layoutOffset = 0.0;
//        childParentData.crossAxisOffset = 0.0;
////        print(
////            "firstChild index ${indexOf(firstChild)} left ${childParentData.crossAxisOffset} top ${childParentData.layoutOffset}");
//        if (scrollOffset == 0.0) {
////          InsertAndLayoutLeadingChild只在第一个孩子之前排列孩子。在这种情况下，什么都没有列出。我们得手动布置第一个孩子
//          //这种情况是可见的第一个child
//          firstChild.layout(childConstraints, parentUsesSize: true);
//          earliestUsefulChild = firstChild;
//          leadingChildWithLayout = earliestUsefulChild;
//          trailingChildWithLayout ??= earliestUsefulChild;
//          break;
//        } else {
////         在到达滚动偏移量之前，我们已经没有孩子了.我们必须通知我们的父母这条sliver不能满足它的合同，我们需要一个滚动偏移校正
//          geometry = SliverGeometry(
//            scrollOffsetCorrection: -scrollOffset,
//          );
//          return;
//        }
//      }
//
//      leadingLineCross += paintWidthOf(firstChild);
//      if (leadingLineCross > constraints.crossAxisExtent) {
//        leadingLineCross = paintWidthOf(firstChild);
//      }
//
//      //更新childParentData  为什么需要更新ParentData，布局是滚动的，需要更新子child TODO 滚动的原理  手势也可以更新parentData
//      final SliverFlowParentData childParentData = earliestUsefulChild.parentData;
//
//      if (leadingLineCross == paintWidthOf(firstChild)) {
//        firstChildScrollOffset = earliestScrollOffset - paintExtentOf(firstChild);
//      }
//      print(
//          "firstChildScrollOffset $firstChildScrollOffset leadingLineCross $leadingLineCross paintWidthOf(firstChild) ${paintWidthOf(firstChild)} childScrollOffset(earliestUsefulChild) ${childScrollOffset(earliestUsefulChild)}  paintExtentOf(firstChild) ${paintExtentOf(firstChild)}");
    //firstChildScrollOffset可能包含双精度问题
//      if (firstChildScrollOffset < -precisionErrorTolerance) {
////        第一个子对象不适合在视口（底流）中，并且上面可能有其他子对象。找到真正的第一个子对象，然后纠正滚动位置，这样就有足够的空间容纳所有人，
////        并且使原始第一个子对象的后缘出现在滚动偏移校正之前的位置。to.do（Hansmuller）：逐步地完成这项工作，而不是一次全部完成，
////        也就是说，在返回进行滚动校正之前，要想办法避免访问偏移量小于0的所有孩子。
//        double correction = 0.0;
//        while (earliestUsefulChild != null) {
//          assert(firstChild == earliestUsefulChild);
//          correction += paintExtentOf(firstChild);
//          earliestUsefulChild = insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
//        }
//        geometry = SliverGeometry(
//          scrollOffsetCorrection: correction - earliestScrollOffset,
//        );
//        final SliverFlowParentData childParentData = firstChild.parentData;
//        childParentData.layoutOffset = 0.0;
//        childParentData.crossAxisOffset = 0.0;
//        print(
//            "double precision error firstChild index ${indexOf(firstChild)} left ${childParentData.crossAxisOffset} top ${childParentData.layoutOffset}");
//        return;
//      }

//      childParentData.layoutOffset = firstChildScrollOffset;
//      childParentData.crossAxisOffset = leadingLineCross - paintWidthOf(firstChild);
//      print(
//          "earliestUsefulChild index ${indexOf(earliestUsefulChild)} left ${childParentData.crossAxisOffset} top ${childParentData.layoutOffset}");
//      assert(earliestUsefulChild == firstChild);
//      leadingChildWithLayout = earliestUsefulChild;
//      trailingChildWithLayout ??= earliestUsefulChild;
//    }

    double earliestPaintExtent = 0.0;
    bool isInsertLeading = false;
    int collectLeadingIndex = 0;

//  todo 有意思的for 结构体判断条件 break退出  for (int i = 0; true; i += 1) {}
    var allArray = List<List<LineItem>>();
    var lineArray = <LineItem>[];
    allArray.add(lineArray);
    for (;;) {
      double earliestScrollOffset = childScrollOffset(earliestUsefulChild);
      print(
          "earliestScrollOffset $earliestScrollOffset  earliestPaintExtent $earliestPaintExtent         scrollOffset $scrollOffset");
      if (!(earliestScrollOffset > scrollOffset || earliestScrollOffset + earliestPaintExtent > scrollOffset)) {
        break;
      }

      earliestUsefulChild = insertAndLayoutLeadingChild(childConstraints, parentUsesSize: true);
      earliestPaintExtent = paintExtentOf(firstChild);
      print("earliestUsefulChild==null ${earliestUsefulChild == null}");
      if (earliestUsefulChild == null) {
        final SliverFlowParentData childParentData = firstChild.parentData;
        childParentData.layoutOffset = 0.0;
        childParentData.crossAxisOffset = 0.0;

        if (scrollOffset == 0.0) {
          firstChild.layout(childConstraints, parentUsesSize: true);
          earliestUsefulChild = firstChild;
          leadingChildWithLayout = earliestUsefulChild;
          trailingChildWithLayout ??= earliestUsefulChild;
          break;
        } else {
          geometry = SliverGeometry(
            scrollOffsetCorrection: -scrollOffset,
          );
          return;
        }
      }
      isInsertLeading = true;
      leadingLineCross += paintWidthOf(firstChild);
      if (leadingLineCross > constraints.crossAxisExtent) {
        leadingLineCross = paintWidthOf(firstChild);
      }
      final SliverFlowParentData childParentData = earliestUsefulChild.parentData;
      if (leadingLineCross == paintWidthOf(firstChild)) {
        firstChildScrollOffset = earliestScrollOffset - paintExtentOf(firstChild);
        lineArray = [];
        allArray.add(lineArray);
      }
      childParentData.layoutOffset = firstChildScrollOffset;
      childParentData.crossAxisOffset = leadingLineCross - paintWidthOf(firstChild);
      lineArray
        ..add(LineItem()
          ..child = firstChild
          ..childParentData = childParentData
          ..childWidth = paintWidthOf(firstChild)
          ..childHeight = paintExtentOf(firstChild));
      if (childParentData.layoutOffset + paintExtentOf(firstChild) < scrollOffset) {
        collectLeadingIndex++;
      }
      print(
          "insertAndLayoutLeadingChild index ${indexOf(firstChild)} layoutOffset ${childParentData.layoutOffset}  crossAxisOffset ${childParentData.crossAxisOffset}");
      assert(earliestUsefulChild == firstChild);
      leadingChildWithLayout ??= earliestUsefulChild;
      trailingChildWithLayout ??= earliestUsefulChild;
    }

    //重新布局leadinglayout  之前从左到右是倒序布局，循环中index递减      快速滑动，有时leading没有layout出现错乱
    //    快速滑动，假设布局一行leadinglayout，此时performlayout的调用次数不变，滚动距离的变化增大，适合leading区域就不止一行了
    //    同时快速滑动倒地时，performalayout的布局仍距离底部还存在边距，leading是错乱的，会滚动出现，由于到底了没有下一次的重新布局,所以leading每次要放置正确的布局
    allArray.forEach((line) {
      //每一行
      var allCross = 0.0;
      line
        ..reversed.forEach((item) {
          final SliverFlowParentData childParentData = item.child.parentData;
          childParentData.crossAxisOffset = allCross;
          allCross += item.childWidth;
        });
    });
    //回收多余的  重新赋值leadingChildWithLayout  回收的属于不可见的，下一次布局时从firstchild开始  即insetleading最后一个不可见,下次布局从这个child开始，属于应该回收的，不回收对下一次布局有影响(高度不正确)
    if (collectLeadingIndex > 0) {
      collectGarbage(collectLeadingIndex, 0);
      leadingChildWithLayout ??= firstChild;
      trailingChildWithLayout ??= firstChild;
      earliestUsefulChild = firstChild;
    }

//    此时，earliestUseVolectChild是第一个子级，并且是其scrollOffset位于或早于scrollOffset的子级，
//    并且leadingChildWithLayout和trailingChildWithLayout要么为空，要么覆盖一系列的呈现框，其中第一个与EarliesTouseChild相同，
//    最后一个位于滚动偏移处或之后。
    print("earliestUsefulChild == firstChild earliestUsefulChild $earliestUsefulChild  firstChild $firstChild");
    assert(earliestUsefulChild == firstChild);
    assert(childScrollOffset(earliestUsefulChild) <= scrollOffset);
    print("leadingChildWithLayout == null ${leadingChildWithLayout == null}");
    //确保至少放置一个child
    if (leadingChildWithLayout == null) {
      isInsertLeading = false;
      earliestUsefulChild.layout(childConstraints, parentUsesSize: true);
      leadingChildWithLayout = earliestUsefulChild;
      trailingChildWithLayout = earliestUsefulChild;
      //此时child在默认位置
      SliverFlowParentData childParentData = earliestUsefulChild.parentData;
      childParentData.layoutOffset = childScrollOffset(earliestUsefulChild);
      print(
          "default at least one index  ${indexOf(earliestUsefulChild)} left ${childParentData.crossAxisOffset} top ${childParentData.layoutOffset}");
    }

//    在这里，earliestUseVolectChild仍然是第一个子，它有一个scrollOffset，在实际的scrollOffset处或之前，它已经被布置好了，
//    实际上是我们的leadingChildWithLayout。有可能除此之外的一些孩子也被安排好了。
    bool inLayoutRange = true;
    //sliverlist 使用earliestUsefulChild从第一个开始布局(一行有一个)  slivergrid使用trailingChildWithLayout(一行有多个) 从insertAndLayoutLeadingChild前的第一个布局
    RenderBox child = trailingChildWithLayout;
    int index = indexOf(child);
    //多次调用advance后变为 endScrollOffset代表这些child的高度和
    double endScrollOffset;
    if (!isInsertLeading) {
      endScrollOffset = childScrollOffset(child);
    } else {
      endScrollOffset = childScrollOffset(child) + paintExtentOf(child); //初始代表 child行的结束
    }
    double lineCrossOffset;
    if (isInsertLeading) {
      lineCrossOffset = 0.0;
    } else {
      lineCrossOffset = paintWidthOf(child);
    }

//    print("init lineCrossOffset $lineCrossOffset endScrollOffset $endScrollOffset");

    // 没有child返回false，返回true如果我们前进
    bool leadingFirst = true;
    bool advance() {
      assert(child != null);
      if (child == trailingChildWithLayout) inLayoutRange = false;
      child = childAfter(child);
      if (child == null) inLayoutRange = false;
      index += 1;
      if (!inLayoutRange) {
        if (child == null || indexOf(child) != index) {
//         我们少了一个孩子。如有可能，请将其插入（并展开）
          child = insertAndLayoutChild(
            childConstraints,
            after: trailingChildWithLayout,
            parentUsesSize: true,
          );
          if (child == null) {
            return false;
          }
        } else {
          //把孩子摆出来
          child.layout(childConstraints, parentUsesSize: true);
        }
        trailingChildWithLayout = child;
        lineCrossOffset += paintWidthOf(child);
      }
      assert(child != null);
      //更新child的位置
      final SliverFlowParentData childParentData = child.parentData;

//      print(
//          "index ${indexOf(child)} lineCrossOffset $lineCrossOffset constraints.crossAxisExtent ${constraints.crossAxisExtent}");
      if (lineCrossOffset > constraints.crossAxisExtent) {
        lineCrossOffset = paintWidthOf(child);
      }
      childParentData.crossAxisOffset = lineCrossOffset - paintWidthOf(child);
      assert(childParentData.index == index);
      childParentData.layoutOffset = endScrollOffset;
      print(
          "advance childScrollOffset(child) ${childScrollOffset(child)} paintExtentOf(child) ${paintExtentOf(child)} ");
      print(
          "advance index ${indexOf(child)}  paintWidthOf(child) ${paintWidthOf(child)} lineCrossOffset $lineCrossOffset}");

      //insetleading 情况下第一个可见的后不回行
      if (lineCrossOffset == paintWidthOf(child) && !(isInsertLeading && leadingFirst)) {
        endScrollOffset = childScrollOffset(child) + paintExtentOf(child);
        childParentData.layoutOffset = endScrollOffset;
      }
      leadingFirst = false;
//      print("index ${indexOf(child)} left ${childParentData.crossAxisOffset} top ${childParentData.layoutOffset}");
      return true;
    }

    //找到在滚动偏移之后结束的第一个子项
    print("endScrollOffset < scrollOffset endScrollOffset $endScrollOffset scrollOffset  $scrollOffset");
    while (endScrollOffset + paintExtentOf(child) < scrollOffset) {
//      print(
//          "endScrollOffset < scrollOffset endScrollOffset $endScrollOffset scrollOffset $scrollOffset  leadingGarbage $leadingGarbage");
      //缓存区待回收
      leadingGarbage += 1;
      if (!advance()) {
        print("endScrollOffset < scrollOffset !advance  leadingGarbage $leadingGarbage");
        assert(leadingGarbage == childCount);
        assert(child == null);
        // 我们要确保保留最后一个子对象，以便知道结束滚动偏移量
        collectGarbage(leadingGarbage - 1, 0);
        assert(firstChild == lastChild);
        final double extent = childScrollOffset(lastChild) + paintExtentOf(lastChild);
        geometry = SliverGeometry(
          scrollExtent: extent,
          paintExtent: 0.0,
          maxPaintExtent: extent,
        );
        print("endScrollOffset < scrollOffset return $geometry");
        return;
      }
    }

    //现在找到我们结束后的第一个孩子  当前布局结束(cache+viewport)
    while (endScrollOffset < targetEndScrollOffset) {
//      print(
//          "endScrollOffset < targetEndScrollOffset endScrollOffset $endScrollOffset targetEndScrollOffset $targetEndScrollOffset");

      if (!advance()) {
        reachedEnd = true;
        break;
      }
    }

    //最后把剩下的孩子都数一数，然后把他们标为垃圾
    if (child != null) {
      child = childAfter(child);
      while (child != null) {
        trailingGarbage += 1;
        child = childAfter(child);
      }
    }

    //在这一点上，一切都应该是好的，我们只需要清理垃圾和报告几何。 回收头和尾不需要布局的child
    collectGarbage(leadingGarbage, trailingGarbage);
    print("collectGarbage last leadingGarbage $leadingGarbage trailingGarbage $trailingGarbage");

    //确定SliverGeometry
    assert(debugAssertChildListIsNonEmptyAndContiguous());
    double estimatedMaxScrollOffset;
//    print("reachedEnd $reachedEnd");
    if (reachedEnd) {
      estimatedMaxScrollOffset = endScrollOffset;
    } else {
      estimatedMaxScrollOffset = childManager.estimateMaxScrollOffset(
        constraints,
        firstIndex: indexOf(firstChild),
        lastIndex: indexOf(lastChild),
        leadingScrollOffset: childScrollOffset(firstChild),
        trailingScrollOffset: endScrollOffset,
      );
      assert(estimatedMaxScrollOffset >= endScrollOffset - childScrollOffset(firstChild));
    }
    final double paintExtent = calculatePaintOffset(
      constraints,
      from: childScrollOffset(firstChild),
      to: endScrollOffset,
    );
    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: childScrollOffset(firstChild),
      to: endScrollOffset,
    );
    final double targetEndScrollOffsetForPaint = constraints.scrollOffset + constraints.remainingPaintExtent;
    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.   为避免在滚动期间闪烁
      hasVisualOverflow: endScrollOffset > targetEndScrollOffsetForPaint || constraints.scrollOffset > 0.0,
    );

//    print("geometry $geometry");

//    我们可能在滚动到结尾时启动了布局，这不会公开新的子级。
    if (estimatedMaxScrollOffset == endScrollOffset) childManager.setDidUnderflow(true);
    childManager.didFinishLayout();
  }

  BoxConstraints transform2BoxConstraints() {
    switch (constraints.axis) {
      case Axis.horizontal:
        return BoxConstraints.loose(Size(double.infinity, constraints.crossAxisExtent));
      case Axis.vertical:
        return BoxConstraints.loose(Size(constraints.crossAxisExtent, double.infinity));
    }
    return null;
  }

  double paintWidthOf(RenderBox child) {
    assert(child != null);
    assert(child.hasSize);
    switch (constraints.axis) {
      case Axis.horizontal:
        return child.size.height;
      case Axis.vertical:
        return child.size.width;
    }
    return null;
  }
}

class SliverFlowParentData extends SliverMultiBoxAdaptorParentData {
  double crossAxisOffset;

  @override
  String toString() => 'crossAxisOffset=$crossAxisOffset; ${super.toString()}';
}

class LineItem {
  RenderBox child;
  SliverFlowParentData childParentData;
  double childWidth;
  double childHeight;
}
