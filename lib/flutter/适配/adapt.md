  1 动态计算
    常见如ScreenUtil，flutter_responsive_screen  通过屏幕与设计图的比，根据像素动态计算实际值
    优化   通过定义function的形式，简化代码，类似于给代码起别名；    hp是顶级函数，可以在其他dart中直接使用

```dart
Function hp = Screen(MediaQuery.of(context).size).hp;
Function wp = Screen(MediaQuery.of(context).size).wp;
```

  2 重写widgetsbinding
    https://juejin.im/post/5cb49e306fb9a068a3729b41

```dart
void main() => InnerWidgetsFlutterBinding.ensureInitialized()
  ..attachRootWidget(new MyApp())
  ..scheduleWarmUpFrame();


class InnerContainer extends SingleChildRenderObjectWidget {
  InnerContainer(_widget) : super(child: _widget);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderInner();
  }
}

class RenderInner extends RenderPadding {
  RenderInner() : super(padding: EdgeInsets.all(0));

  @override
  Size get size => printSize();

  printSize() {
    print("printSize    " + super.size.toString());
    return super.size;
  }
}

class InnerWidgetsFlutterBinding extends WidgetsFlutterBinding {
  static WidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) InnerWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }

  @override
  ViewConfiguration createViewConfiguration() {
    return ViewConfiguration(
      size: getScreenAdapterSize(),
      devicePixelRatio: getAdapterRatio(),
    );
  }

  ///
  /// 以下一大重写与 GestureBinding
  /// 唯一目的 把 _handlePointerDataPacket 方法 事件原始数据转换 改用
  /// 修改过的 PixelRatio

  @override
  void initInstances() {
    super.initInstances();
    ui.window.onPointerDataPacket = _handlePointerDataPacket;
  }

  @override
  void unlocked() {
    super.unlocked();
    _flushPointerEventQueue();
  }

  final Queue<PointerEvent> _pendingPointerEvents = Queue<PointerEvent>();

  void _handlePointerDataPacket(ui.PointerDataPacket packet) {
    _pendingPointerEvents.addAll(PointerEventConverter.expand(
        packet.data,
        // 适配事件的转换比率,采用我们修改的
        getAdapterRatio()));
    if (!locked) _flushPointerEventQueue();
  }

  @override
  void cancelPointer(int pointer) {
    if (_pendingPointerEvents.isEmpty && !locked)
      scheduleMicrotask(_flushPointerEventQueue);
    _pendingPointerEvents.addFirst(PointerCancelEvent(pointer: pointer));
  }

  void _flushPointerEventQueue() {
    assert(!locked);
    while (_pendingPointerEvents.isNotEmpty)
      _handlePointerEvent(_pendingPointerEvents.removeFirst());
  }

  final Map<int, HitTestResult> _hitTests = <int, HitTestResult>{};

  void _handlePointerEvent(PointerEvent event) {
    assert(!locked);
    HitTestResult result;
    if (event is PointerDownEvent) {
      assert(!_hitTests.containsKey(event.pointer));
      result = HitTestResult();
      hitTest(result, event.position);
      _hitTests[event.pointer] = result;
      assert(() {
        if (debugPrintHitTestResults) debugPrint('$event: $result');
        return true;
      }());
    } else if (event is PointerUpEvent || event is PointerCancelEvent) {
      result = _hitTests.remove(event.pointer);
    } else if (event.down) {
      result = _hitTests[event.pointer];
    } else {
      return; 
    }
    if (result != null) dispatchEvent(event, result);
  }
}
```



  两种方式比较  

​      第一种  每次都要计算，但经过优化后还以接受

​                    不受源码影响，一劳永逸的适配

​     第二种   重写部分源码，一次设置，直接使用

​                    源码更改或存在bug需要手动更改