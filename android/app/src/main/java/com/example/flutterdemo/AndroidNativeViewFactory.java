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
//        args是由Flutter传过来的自定义参数
        return new AndroidNativeView(context, (Map<String, Object>) args,messenger,i);
    }
}
