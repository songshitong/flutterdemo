Widget ---->Element

createElement()生成Element

canUpdate()用于更新Element    runtimeType和key同时相同返回true

```dart
static bool canUpdate(Widget oldWidget, Widget newWidget) {
  return oldWidget.runtimeType == newWidget.runtimeType
      && oldWidget.key == newWidget.key;
}
```

Element--->RenderObject

RenderObjectWidget是有渲染能力的widget

 生成的Element是RenderObjectElement

RenderObjectElement 在mount时调用RenderObjectWidget的createRenderObject()来

   初始化RenderObject

   void attachRenderObject(dynamic newSlot)  将RendeObject加入到RenderTree中

​    在update时调用RenderObjectWidget的updateRenderObject()来更新RenderObject



Widget 更新到Element的机制

setState不更新情况

child为statefulWidget情况时，Widget.canUpdate为true(runtimeType和key同时相同)，此时认为widget不变，只更新element持有的widget，element仍从原来的state进行build获得widget，没有生成新的element。此时给child增加valuekey，可以生成新的element

```
 |                     | **newWidget == null**  | **newWidget != null**   |
 | :-----------------: | :--------------------- | :---------------------- |
 |  **child == null**  |  Returns null.         |  Returns new [Element]. |
 |  **child != null**  |  Old child is removed, returns null. | Old child updated if possible, returns child or new [Element]. |
```

```dart
Element updateChild(Element child, Widget newWidget, dynamic newSlot) {
  if (newWidget == null) {
    if (child != null)
      deactivateChild(child);
    return null;
  }
  if (child != null) {
    if (child.widget == newWidget) {
      if (child.slot != newSlot)
        updateSlotForChild(child, newSlot);
      return child;
    }
    ///体现了widget是不可变的，canUpdate对比的是widget的类型而不是实例，不同的widget是  ///不同的实例
    if (Widget.canUpdate(child.widget, newWidget)) {
      if (child.slot != newSlot)
        ///将child持有的slot更新为newSlot，给widget更换位置
        updateSlotForChild(child, newSlot);
      ///对于StatelessElement将child持有的_widget更新为newWidget,StatelessElement从
      ///_widget的build构建widget
      ///对于StatefulElement将child持有的_state.widget更新为newWidget，  ///  /// ///StatefulElement从_state的build构建widget
      child.update(newWidget);
      return child;
    }
    deactivateChild(child);
  }
  return inflateWidget(newWidget, newSlot);
}
```

deactiveChild 做了三件事

 1 将parent element 置为null

2  将renderObject从render tree移除

3  将child element加入buildOwner的inactiveElements列表中

```dart
void deactivateChild(Element child) {
  child.parent = null;
  child.detachRenderObject();
  owner.inactiveElements.add(child);
}
```

inflateWidget

```
Element inflateWidget(Widget newWidget, dynamic newSlot) {
  final Key key = newWidget.key;
  if (key is GlobalKey) {
    ///取出globalkey的_currentElement并将element从element树中拿出
    final Element newChild = _retakeInactiveElement(key, newWidget);
    if (newChild != null) {
      newChild._activateWithParent(this, newSlot);
      final Element updatedChild = updateChild(newChild, newWidget, newSlot);
      return updatedChild;
    }
  }
  ///根据newWidget生成新的element
  final Element newChild = newWidget.createElement();
  newChild.mount(this, newSlot);
  return newChild;
}
```

