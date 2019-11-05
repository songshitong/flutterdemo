class SingleLonData {
  static final SingleLonData _singleton = new SingleLonData._internal();

  factory SingleLonData() {
    return _singleton;
  }

  SingleLonData._internal();

  String tempPath = "";
  String appDocDir = "";
}
