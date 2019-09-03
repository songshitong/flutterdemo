class Button {
  String text;
  String color;
  String _btn = "btn";

  setText(String tText) {
    text = tText;
    print("setText  -> " + tText);
  }

  setColor(String cColor) {
    color = cColor;
    print("setColor -> " + cColor);
  }

  set btn(String value) {
    _btn = value;
  }
}
