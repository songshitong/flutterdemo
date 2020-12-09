void main() {
  ///设置默认的asset加载
  ///AssetBundle默认实现，大于10KB将在isolate中执行，此时测试可能已经走完
  ///https://medium.com/@sardox/flutter-test-and-randomly-missing-assets-in-goldens-ea959cdd336a
  ///flutter 多isolate进行drive测试异常
  ///https://github.com/flutter/flutter/issues/24703
  // DefaultAssetBundle();
}
