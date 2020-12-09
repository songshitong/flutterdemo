import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutterdemo/flutter/common/MyImgs.dart';
import 'package:flutterdemo/flutter/common/Style.dart';
import 'package:flutterdemo/flutter/pages/beautiful/gallery/section_info.dart';

///官方gallery demo 中 Section Organizer的animation
class SliverSectionOrganizer extends StatefulWidget {
  @override
  _SliverSectionState createState() => _SliverSectionState();
}

//背景色
const Color _kAppBackgroundColor = Color(0xFF353662);

const double _kAppBarMinHeight = 90.0;
//appbar 的mid height 表示
const double _kAppBarMidHeight = 256.0;

class _SliverSectionState extends State<SliverSectionOrganizer> {
  List<SectionInfo> _setions = [
    SectionInfo(
        MyImgs.SUNNIES, "SUNGLASSES", MyColor.mediumPurple, MyColor.mariner),
    SectionInfo(
        MyImgs.TABLE, "FURNITURE", MyColor.tomato, MyColor.mediumPurple),
    SectionInfo(MyImgs.EARRINGS, "JEWELRY", MyColor.mySin, MyColor.tomato),
    SectionInfo(MyImgs.HAT, "HEADWEAR", Colors.white, MyColor.tomato)
  ];
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double allHeight = MediaQuery.of(context).size.height;
    double bodyHeight = allHeight - statusBarHeight;
    return Scaffold(
      backgroundColor: _kAppBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomScrollView(
            physics: _SnappingScrollPhysics(
                midScrollOffset: allHeight - _kAppBarMidHeight),
            slivers: <Widget>[
              //statusbar
              StatusBarSliver(2, statusBarHeight),
              //head
              buildHead(bodyHeight, _kAppBarMinHeight), //body
              _buildBody(allHeight, _kAppBarMinHeight)
            ],
          ),
          Positioned(
              top: statusBarHeight,
              child: BackButtonWithCall(
                color: Colors.green,
                callback: () {
                  Navigator.maybePop(context);
                },
              ))
        ],
      ),
    );
  }

  SliverPersistentHeader buildHead(double bodyHeight, double headMinHieght) {
    //head在竖直展开时使用MultiChildLayout 布局，横向展开时用PageView布局
    List<Widget> cards = [];
    for (int i = 0; i < _setions.length; i++) {
      cards.add(LayoutId(
        id: 'card$i',
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [_setions[i].left, _setions[i].right])),
              child: Image.asset(
                _setions[i].imgUrl,
                color: const Color.fromRGBO(255, 255, 255, 0.075),
                colorBlendMode: BlendMode.modulate,
                fit: BoxFit.cover,
              ),
            ),
            HeadTitle(_setions[i].title)
          ],
        ),
      ));
    }
    List<Widget> allSections = [];
    for (int i = 0; i < _setions.length; i++) {
      allSections.add(Container(
        color: _kAppBackgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            var minHeight = _kAppBarMinHeight;
            var midHeight = _kAppBarMidHeight;
            var maxHeight = bodyHeight;
            final Size size = constraints.biggest;

            // 布局从列到行的进度. 它的价值在于
            // 0.0当size.height等于maxHeight时，1.0当size.height时
            //等于midHeight。
            final double tColumnToRow = 1.0 -
                ((size.height - midHeight) / (maxHeight - midHeight))
                    .clamp(0.0, 1.0);

            // 布局从midHeight行布局到
            // minHeight行布局。当size.height等于 midHeight时，其值为0.0
            //和1.0当size.height等于minHeight时.
            final double tCollapsed = 1.0 -
                ((size.height - minHeight) / (midHeight - minHeight))
                    .clamp(0.0, 1.0);
            return CustomMultiChildLayout(
              delegate: _AllSectionsLayout(
                  selectedIndex: 0,
                  translation: Alignment(-1.0, -1.0),
                  tColumnToRow: tColumnToRow,
                  tCollapsed: tCollapsed,
                  cardCount: _setions.length),
              children: cards,
            );
          },
        ),
      ));
    }
    return SliverPersistentHeader(
      pinned: true,
      delegate: SectionBodyDelete(
          maxHeight: bodyHeight,
          minHeight: headMinHieght,
          child: PageView(
            children: allSections,
          )),
    );
  }

  SliverToBoxAdapter _buildBody(double allHeight, double headMinHieght) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: allHeight - headMinHieght,
        child: PageView.builder(itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            child: Text("page $index"),
          );
        }),
      ),
    );
  }
}

///每个标题
class HeadTitle extends StatelessWidget {
  final String title;

  const HeadTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 4,
          child: Text(
            "$title",
            style: TextStyle(fontSize: 40, color: const Color(0x19000000)),
          ),
        ),
        Text(
          "$title",
          style: TextStyle(fontSize: 40),
        ),
      ],
    );
  }
}

///[SliverPersistentHeader]的委派配置
class SectionBodyDelete extends SliverPersistentHeaderDelegate {
  SectionBodyDelete({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  double get minExtent => math.min(maxHeight, minHeight);

  @override
  bool shouldRebuild(SectionBodyDelete oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

///创建一个跟随主体滚动而缩放的StatusBar,主体向上滚动，StatusBar收缩至0，主体向下，StatusBar扩张至默认大小
class StatusBarSliver extends SingleChildRenderObjectWidget {
  double scrollFactor;
  double maxHeight;

  StatusBarSliver(this.scrollFactor, this.maxHeight);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return StatusBarSliverRender(
        scrollFactor: scrollFactor, maxHeight: maxHeight);
  }

  @override
  void updateRenderObject(
      BuildContext context, StatusBarSliverRender renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..maxHeight = maxHeight
      ..scrollFactor = scrollFactor;
  }
}

//StatusBar
class StatusBarSliverRender extends RenderSliver {
  double _scrollFactor;
  double _maxHeight;

  set scrollFactor(double value) {
    _scrollFactor = value;
    markNeedsLayout();
  }

  set maxHeight(double value) {
    _maxHeight = value;
    markNeedsLayout();
  }

  StatusBarSliverRender(
      {required double scrollFactor, required double maxHeight})
      : _scrollFactor = scrollFactor,
        _maxHeight = maxHeight;

  @override
  void performLayout() {
    final double height =
        (_maxHeight - constraints.scrollOffset / _scrollFactor)
            .clamp(0.0, _maxHeight);
    geometry = SliverGeometry(
      paintExtent: math.min(height, constraints.remainingPaintExtent),
      scrollExtent: _maxHeight,
      maxPaintExtent: _maxHeight,
    );
  }
}

///代码改编自[BackButton]
class BackButtonWithCall extends StatelessWidget {
  final Color color;
  final VoidCallback? callback;
  BackButtonWithCall({this.color = Colors.black87, this.callback});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const BackButtonIcon(),
      color: color,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
      onPressed: this.callback!,
    );
  }
}

//支持捕捉滚动到midScrollOffset：在那一点app栏的高度为_kAppBarMidHeight，只有一个部分标题可见

class _SnappingScrollPhysics extends ClampingScrollPhysics {
  const _SnappingScrollPhysics({
    ScrollPhysics? parent,
    required this.midScrollOffset,
  })   : assert(midScrollOffset != null),
        super(parent: parent);

  final double midScrollOffset;

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnappingScrollPhysics(
        parent: buildParent(ancestor), midScrollOffset: midScrollOffset);
  }

  Simulation _toMidScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, midScrollOffset, velocity,
        tolerance: tolerance);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = math.max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, 0.0, velocity,
        tolerance: tolerance);
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double dragVelocity) {
    final Simulation? simulation =
        super.createBallisticSimulation(position, dragVelocity);
    final double offset = position.pixels;
    print("simulation $simulation");
    if (simulation != null) {
      // 拖动以足够的速度结束以触发创建simulation.
      // 如果simulation朝向midScrollOffset但不会到达它,
      // 然后把它抓到那里. 同样，如果simulation
      // 朝向midScrollOffset然后超过了但不会达到零, 然后将其捕捉到零.
      final double simulationEnd = simulation.x(double.infinity);

      ///滚动超过midScrollOffset,继续滚动到底   midScrollOffset可以定义为屏幕的任意位置
      if (simulationEnd >= midScrollOffset) return simulation;

      ///没有滚动到midScrollOffset但有速度，此时滚动到midScrollOffset
      if (dragVelocity > 0.0)
        return _toMidScrollOffsetSimulation(offset, dragVelocity);

      ///没有滚动到midScrollOffset但速度<0，滚动到初始位置
      if (dragVelocity < 0.0)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    } else {
      // 用户以很少或没有速度结束拖动。 如果他们
      //没有将偏移量保留在midScrollOffset之上, 然后
      //如果它们超过一半，就会捕捉到midScrollOffset,
      // 否则会零.
      final double snapThreshold = midScrollOffset / 2.0;

      ///偏移超过midScrollOffset/2但小于midScrollOffset，滚动到midScrollOffset
      if (offset >= snapThreshold && offset < midScrollOffset)
        return _toMidScrollOffsetSimulation(offset, dragVelocity);

      ///偏移不超过midScrollOffset/2，滚动到0初始位置
      if (offset > 0.0 && offset < snapThreshold)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    }
    return simulation;
  }
}

// 安排章节标题，指标和卡片. 卡片仅在
//布局在垂直和水平之间内转换时包括. 一旦水平布局了
//卡片由PageView布局.
//
// 部分卡片，标题和指示器的布局由
//两个0.0-1.0“t”参数，两者都基于布局的高度:
// - tColumnToRow
//   0.0高度为maxHeight且布局为列时
//   1.0当高度为midHeight并且布局是一行时
// - tCollapsed
//   0.0 当高度为midHeight且布局为一行时
//   1.0 当高度为minHeight且布局为（静止）行时
//
// minHeight < midHeight < maxHeight
//
// 这里的一般方法是计算列布局和行大小
//和每个元素的位置，然后使用它们在它们之间进行插值
// tColumnToRow. 一旦tColumnToRow达到1.0，布局就会发生变化
//由tCollapsed定义. 随着tCollapsed的增加，标题扩散
//直到只有一个标题可见且指标聚集在一起
//直到他们全部可见.
class _AllSectionsLayout extends MultiChildLayoutDelegate {
  _AllSectionsLayout({
    this.translation,
    this.tColumnToRow,
    this.tCollapsed,
    this.cardCount,
    this.selectedIndex,
  });

  final Alignment? translation;
  final double? tColumnToRow;
  final double? tCollapsed;
  final int? cardCount;
  final double? selectedIndex;
  Rect? _interpolateRect(Rect begin, Rect end) {
    return Rect.lerp(begin, end, tColumnToRow!);
  }

  Offset? _interpolatePoint(Offset begin, Offset end) {
    return Offset.lerp(begin, end, tColumnToRow!);
  }

  @override
  void performLayout(Size size) {
    //分为5份
    final double columnCardX = size.width / 5.0;
    //偏移一份，占据4份
    final double columnCardWidth = size.width - columnCardX;
    //高度平分为cardCount份
    final double columnCardHeight = size.height / cardCount!;
    //横向排列时每个card的宽度
    final double rowCardWidth = size.width;
    //根据aligment 和size得出offset
    final Offset offset = translation!.alongSize(size);
    //初始为y=0
    double columnCardY = 0.0;
    //横向每个cardx
    double rowCardX = -(selectedIndex! * rowCardWidth);

    for (int index = 0; index < cardCount!; index++) {
      // 布局带有索引的每个card
      final Rect columnCardRect = Rect.fromLTWH(
          columnCardX, columnCardY, columnCardWidth, columnCardHeight);
      final Rect rowCardRect =
          Rect.fromLTWH(rowCardX, 0.0, rowCardWidth, size.height);
      final Rect cardRect =
          _interpolateRect(columnCardRect, rowCardRect)!.shift(offset);
      final String cardId = 'card$index';
      if (hasChild(cardId)) {
        layoutChild(cardId, BoxConstraints.tight(cardRect.size));
        positionChild(cardId, cardRect.topLeft);
      }

      //高度累加，宽度累加
      columnCardY += columnCardHeight;
      rowCardX += rowCardWidth;
    }
  }

  @override
  bool shouldRelayout(_AllSectionsLayout oldDelegate) {
    return tColumnToRow != oldDelegate.tColumnToRow ||
        cardCount != oldDelegate.cardCount ||
        selectedIndex != oldDelegate.selectedIndex;
  }
}
