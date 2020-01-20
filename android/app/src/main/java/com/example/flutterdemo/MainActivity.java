package com.example.flutterdemo;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.os.BatteryManager;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.engine.plugins.FlutterPlugin;


//todo FlutterPlugin干嘛用的 webview_plugin用到了
public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.io/battery";
  Context context;
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    context = this;
    //注册自己的原生控件
    AndroidNativeViewFlutterPlugin.registerWith(this);
    GeneratedPluginRegistrant.registerWith(this);
//    1创建MethodChannel并设置一个MethodCallHandler。确保使用和Flutter客户端中使用的通道名称相同的名称。
//    2我们需要处理平台方法名为getBatteryLevel的调用消息，所以我们需要先在call参数判断调用的方法是否为getBatteryLevel。
//    这个平台方法的实现只需调用我们在前一步中编写的Android代码，并通过result参数返回成功或错误情况的响应信息。
//    如果调用了未定义的API，我们也会通知返回
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                if (call.method.equals("getBatteryLevel")) {
                  int batteryLevel = getBatteryLevel();
                  if (batteryLevel != -1) {
                    result.success(batteryLevel);   ///进入flutter future.then
                  } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null); ///进入flutter 的异常 future.catchErr
                  }
                } else {
                  result.notImplemented();
                }
              }
            });
  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
              registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
              intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }
    Toast.makeText(context,"android getBatteryLevel "+batteryLevel,Toast.LENGTH_LONG).show();
    return batteryLevel;
  }
}
