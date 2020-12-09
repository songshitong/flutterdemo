 Flutter (Channel stable, 1.20.2, on Mac OS X 10.15.6 19G2021, locale zh-Hans)
 
SelectableText build方法返回_SelectableTextSelectionGestureDetectorBuilder包裹的 EditableText
_SelectableTextSelectionGestureDetectorBuilder 负责手势
onSingleLongTapStart 第一次长按弹出浮窗
TextSelectionControls 负责构建复制选择UI{
   //构建左右拖动选择范围的handle
   Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight);
   
   Widget buildToolbar(
       BuildContext context,
       Rect globalEditableRegion,
       double textLineHeight,
       Offset position,
       List<TextSelectionPoint> endpoints,
       TextSelectionDelegate delegate,
       ClipboardStatusNotifier clipboardStatus,
     );
}
TextSelectionOverlay  负责具体的展示逻辑，Overlay的插入
TextSelectionDelegate  实现者要使用工具栏小部件的用于操纵选择的接口{
  TextEditingValue get textEditingValue;
  set textEditingValue(TextEditingValue value);
  void hideToolbar();

  /// Brings the provided [TextPosition] into the visible area of the text
  /// input.
  void bringIntoView(TextPosition position);
  bool get cutEnabled => true;
  bool get copyEnabled => true;
  bool get pasteEnabled => true;
  bool get selectAllEnabled => true;
}
                        

 final Widget child = RepaintBoundary(
      child: EditableText(
        key: editableTextKey,
        style: effectiveTextStyle,
        readOnly: true,
        textWidthBasis: widget.textWidthBasis ?? defaultTextStyle.textWidthBasis,
        textHeightBehavior: widget.textHeightBehavior ?? defaultTextStyle.textHeightBehavior,
        showSelectionHandles: _showSelectionHandles,
        showCursor: widget.showCursor,
        controller: _controller,
        focusNode: focusNode,
        strutStyle: widget.strutStyle ?? const StrutStyle(),
        textAlign: widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
        textDirection: widget.textDirection,
        textScaleFactor: widget.textScaleFactor,
        autofocus: widget.autofocus,
        forceLine: false,
        toolbarOptions: widget.toolbarOptions,
        minLines: widget.minLines,
        maxLines: widget.maxLines ?? defaultTextStyle.maxLines,
        selectionColor: themeData.textSelectionColor,
        selectionControls: widget.selectionEnabled ? textSelectionControls : null,
        onSelectionChanged: _handleSelectionChanged,
        onSelectionHandleTapped: _handleSelectionHandleTapped,
        rendererIgnoresPointer: true,
        cursorWidth: widget.cursorWidth,
        cursorRadius: cursorRadius,
        cursorColor: cursorColor,
        cursorOpacityAnimates: cursorOpacityAnimates,
        cursorOffset: cursorOffset,
        paintCursorAboveText: paintCursorAboveText,
        backgroundCursorColor: CupertinoColors.inactiveGray,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        dragStartBehavior: widget.dragStartBehavior,
        scrollPhysics: widget.scrollPhysics,
      ),
    );
    return Semantics(
      onTap: () {
        if (!_controller.selection.isValid)
          _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
        _effectiveFocusNode.requestFocus();
      },
      onLongPress: () {
        _effectiveFocusNode.requestFocus();
      },
      child: _selectionGestureDetectorBuilder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    ); 

EditableText build返回_Editable 对应真正的绘制Object  RenderEditable


EditableTextState  _showCaretOnScreen()
