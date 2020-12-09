import 'package:flutter/material.dart';

///checkBOx
///
/// 如何保持状态
/// 单独封装一个stateFulWidget
/// 在listview中使用MAP或list保持状态
/// 在listView中使用AutomaticKeepAlive属性，原理KeepAlive
class CheckBoxPage extends StatefulWidget {
  @override
  _CheckBoxPageState createState() => _CheckBoxPageState();
}

class _CheckBoxPageState extends State<CheckBoxPage> {
  bool _checkValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("checkbox"),
      ),
      body: Column(
        children: <Widget>[
          Checkbox(
              value: true,
              activeColor: Colors.red,
              onChanged: (value) {
                print("onchaged1 $value");
              }),
          Checkbox(
              value: _checkValue,
              onChanged: (value) {
                print("onchaged2 $value");
                _checkValue = value ?? false;
                setState(() {});
              }),
          Checkbox(
              value: null!,
              tristate: true,
              onChanged: (value) {
                print("onchaged3 $value");
              }),
        ],
      ),
    );
  }
}

class AliveCheckbox extends StatefulWidget {
  ValueChanged<bool> onChange;
  bool value;

  AliveCheckbox({required this.onChange, this.value = false});

  @override
  _AliveCheckboxState createState() => _AliveCheckboxState();
}

class _AliveCheckboxState extends State<AliveCheckbox> {
  late bool active;
  @override
  void initState() {
    active = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: active,
        onChanged: (result) {
          setState(() {
            widget.onChange.call(result ?? false);
            active = result ?? false;
          });
        });
  }
}
