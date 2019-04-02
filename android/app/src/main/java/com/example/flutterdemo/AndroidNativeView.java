package com.example.flutterdemo;

import java.util.Map;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.widget.TextView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class AndroidNativeView implements PlatformView, MethodChannel.MethodCallHandler{
    private  static final String PARAM_KEY_CONTENT = "context";
    private  static final String METHOD_KEY_CHANGE_TEXT = "changeText";

    private static final String CHANNEL = "example/android/method_channel/android_native_view";

    private final TextView realView;

    public AndroidNativeView(Context context, Map<String,Object> params, BinaryMessenger messenger,int id) {
        TextView tv = new TextView(context);
        Log.d("android natvie view",params.toString());
        if (null != params && params.containsKey(PARAM_KEY_CONTENT)) {
            String myContent = (String) params.get(PARAM_KEY_CONTENT);
            tv.setText(myContent);
        }else{
            tv.setText("Android -- 暂无内容");
        }
        tv.setBackgroundColor(Color.GRAY);
        this.realView = tv;


        //MethodChannel 原生通信 id 是view独有的
        MethodChannel methodChannel = new MethodChannel(messenger, CHANNEL+id);
        methodChannel.setMethodCallHandler(this);
    }

    /**
     * 返回原生 view
     * @return
     */
    @Override
    public View getView() {
        return this.realView;
    }

    @Override
    public void dispose() {

    }

    /**
     * 调用原生方法
     * @param methodCall
     * @param result
     */
    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        if (METHOD_KEY_CHANGE_TEXT.equals(methodCall.method)) {
            String text = (String) methodCall.arguments;
            realView.setText(text);
            result.success(null);
        }
    }
}
