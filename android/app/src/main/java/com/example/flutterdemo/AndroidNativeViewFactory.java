package com.example.flutterdemo;


import java.util.Map;

import android.content.Context;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class AndroidNativeViewFactory extends PlatformViewFactory {
    BinaryMessenger messenger;
    public AndroidNativeViewFactory(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int i, Object args) {
        //这个context不是activity context
        //创建webview的context 必须是activity，不然报错Unable to create JsDialog without an Activity
        //https://chromium.googlesource.com/chromium/src.git/+/lkgr/android_webview/glue/java/src/com/android/webview/chromium/WebViewContentsClientAdapter.java
//        args是由Flutter传过来的自定义参数
        return new AndroidNativeView(context, (Map<String, Object>) args,messenger,i);
    }


}
