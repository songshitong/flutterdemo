//https://zxfcumtcs.github.io/2020/05/23/deepinto-flutter-paintingcontext/

//提供裁剪绘制的辅助方法
ClipContext{
  Canvas canvas
  void clipRectAndPaint()
}

//Canvas是 Engine(C++) 层到 Framework(Dart) 层的桥接，真正的功能在 Engine 层实现
//通过canvas接口进行的所有操作都将被PictureRecorder记录下来
Canvas{
  PictureRecorder? _recorder;
  Canvas(PictureRecorder recorder, [ Rect cullRect ]){
    _recorder!._canvas = this;
  }
}

//其主要作用是记录在Canvas上执行的「graphical operations」，通过Picture#endRecording最终生成Picture
// To begin recording, construct a [Canvas] to record the commands.
// To end recording, use the [PictureRecorder.endRecording] method.
PictureRecorder{
  Picture endRecording() {}
}

//其本质是一系列「graphical operations」的集合，对 Framework 层透明。
// Future<Image> toImage(int width, int height)，通过toImage方法可以将其记录的所有操作经光栅化后生成Image对象
Picture{
  Future<Image> toImage(int width, int height) {
  }
}

//代表合成场景的不透明对象
//Scene objects can be displayed on the screen using the [FlutterView.render]
Scene{
  Future<Image> toImage(int width, int height) {
  }
}

//用于将多个图层(Layer)、Picture、Texture 合成为 Scene
//1.添加addPicture
//2.生成Scene
//3.维护一个图形操作 stack
//   pushClipRect
//   pop
SceneBuilder{
   void addPicture(Offset offset,Picture picture)

   void addTexture(int textureId)
   void addRetained(EngineLayer retainedLayer)

   Scene build() {
       final Scene scene = Scene._();
       _build(scene);
       return scene;
     }
}

//绘制scene
FlutterView{
   void render(Scene scene)
}

///绘制上下文，最简单的理解就是为绘制操作 (Paint) 提供了场所或者说环境 (上下文)。

//为什么不直接通过canvas而是通过PaintingContext
//绘制子渲染对象时，绘画上下文所持有的画布可能会发生变化，因为在绘制子对象之前和之后发出的绘制操作可能会记录在单独的合成层中。
//因此，不要在可能绘制子渲染对象的操作中持有对画布的引用

//PaintingContext 与 RenderObject 是什么关系？
//从『类间关系』角度看，它们之间是依赖关系，即 RenderObject 依赖于 PaintingContext —— PaintingContext 作为参数出现在 RenderObject 的绘制方法中。
//也就是说，PaintingContext 是一次性的，每次执行 Paint 时都会生成对应的 PaintingContext，当绘制完成时其生命周期也随之结束

PaintingContext extend ClipContext{

  void pushLayer(ContainerLayer childLayer, PaintingContextCallback painter, Offset offset, { Rect childPaintBounds }) {
    // 注意！
    // 在 append sub layer 前先终止现有的绘制操作
    // stopRecordingIfNeeded 所执行的操作见上文
    //
    stopRecordingIfNeeded();
    appendLayer(childLayer);

    // 为 childLayer 创建新的 PaintingContext，以便独立进行绘制操作
    //
    final PaintingContext childContext = createChildContext(childLayer, childPaintBounds ?? estimatedBounds);
    painter(childContext, offset);
    childContext.stopRecordingIfNeeded();
  }

  // needsCompositing 参数一般来自 RenderObject.needCompositing
  // true 表示需要合成新的layer
  // Compositing，合成，属于 Rendering Pipeline 中的一环，表示是否要生成新的 Layer 来实现某些特定的图形效果
  // 如上，pushClipRect在needsCompositing为true时，创建了新 Layer 并在其上进行裁剪、绘制，否则在当前 Canvas 上进行裁剪、绘制
  ClipRectLayer pushClipRect(bool needsCompositing, Offset offset, Rect clipRect, PaintingContextCallback painter, { Clip clipBehavior = Clip.hardEdge, ClipRectLayer oldLayer }) {
    final Rect offsetClipRect = clipRect.shift(offset);
    if (needsCompositing) {
      // 在需要合成时，创建新 Layer
      //
      final ClipRectLayer layer = oldLayer ?? ClipRectLayer();
      layer
        ..clipRect = offsetClipRect
        ..clipBehavior = clipBehavior;

      // 将新 layer 添加到 layer tree 上，并在其上完成绘制
      //
      pushLayer(layer, painter, offset, childPaintBounds: offsetClipRect);
      return layer;
    } else {
      // 否则在当前 Canvas 上进行裁剪、绘制
      //
      clipRectAndPaint(offsetClipRect, clipBehavior, offsetClipRect, () => painter(this, offset));
      return null;
    }
  }


  Canvas get canvas {
      if (_canvas == null)
        _startRecording();
      return _canvas;
    }

  // 在当前 Canvas 上进行的图形操作生成的 Picture 将添加到该 layer 上
   void _startRecording() {
      _currentLayer = PictureLayer(estimatedBounds);
      _recorder = ui.PictureRecorder();
      _canvas = Canvas(_recorder);
      //将_currentLayer插入以_containerLayer为根节点的子树上
      _containerLayer.append(_currentLayer);
    }

   //在停止记录时，将结果 picture 加到 _currentLayer 上
   void stopRecordingIfNeeded() {
       if (!_isRecording)
         return;
       // 注意！
       // 此时，_currentLayer、_recorder、_canvas 被释放，
       // 此后，若还要通过当前 PaintingContext 进行绘制，则会生成新的 _currentLayer、_recorder、_canvas
       // 即在 PaintingContext 的生命周期内 _canvas 可能会变
       //
       _currentLayer.picture = _recorder.endRecording();
       _currentLayer = null;
       _recorder = null;
       _canvas = null;
     }
}

//todo 查看该流程
在 UI Frame 刷新时，通过RendererBinding#drawFrame->PipelineOwner#flushPaint触发RenderObject#paint；
RenderObject#paint调用PaintingContext.canvas提供的图形操作接口(draw*、clip*、transform等)完成绘制任务；
上述绘制操作被 PictureRecorder 记录下来，在绘制结束时生成 picture，并被添加到 PictureLayer (_currentLayer)上；
随后，RenderObject 通过PaintingContext#paintChild递归地绘制子节点(child renderobject，如有)；
在绘制子节点时，根据子节点是否是「Repaint Boundary」而采用不同的策略：
是「Repaint Boundary」— 为子节点生成新的 PaintingContext，从而子节点可以独立进行绘制，绘制结果就是一颗「Layer subTree」，最后将该子树 append 到父节点生成的「Layer Tree」上；
不是「Repaint Boundary」— 子节点直接绘制在当前PaintingContext.canvas上，即 RenderObject 与 Layer 是多对一的关系。
整个绘制流程结束时就得到了一棵「Layer Tree」，其后通过 SceneBuilder 生成 Scene，再经window.render送入 Engine 层，最终 GPU 对其进行光栅化处理，显示在屏幕上。
