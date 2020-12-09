import 'package:flutter/material.dart';

///https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9
///CompositedTransformTarget  滚动跟随
///CompositedTransformFollower
class CompositedTargetPage extends StatefulWidget {
  @override
  _CompositedTargetPageState createState() => _CompositedTargetPageState();
}

class _CompositedTargetPageState extends State<CompositedTargetPage> {
  LayerLink _layerLink = LayerLink();
  late BuildContext targetContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CompositedTargetPage"),
        actions: [
          FlatButton(
            onPressed: () {
              if (_overlayEntry == null) {
                popupMenu();
              } else {
                removeMenu();
              }
            },
            child: Text("toggle menu"),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 80),
              child: CompositedTransformTarget(
                  link: _layerLink,
                  child: Builder(builder: (context) {
                    targetContext = context;
                    return TextField();
                  })),
            ),
          ),
          SliverToBoxAdapter(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 100,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("$index"),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  OverlayEntry? _overlayEntry;
  void removeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void popupMenu() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = targetContext.findRenderObject() as RenderBox;
    var size = renderBox.size;
    print("_createOverlayEntry size $size");
    return OverlayEntry(
        builder: (context) => Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: this._layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5.0),
                child: Material(
                  elevation: 4.0,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        title: Text('Syria'),
                        onTap: () {
                          print('Syria Tapped');
                        },
                      ),
                      ListTile(
                        title: Text('Lebanon'),
                        onTap: () {
                          print('Lebanon Tapped');
                        },
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
