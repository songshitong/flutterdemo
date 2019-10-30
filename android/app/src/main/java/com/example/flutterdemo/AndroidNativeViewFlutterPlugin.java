package com.example.flutterdemo;

import io.flutter.plugin.common.PluginRegistry;

public class AndroidNativeViewFlutterPlugin {
   private  static  String  NativeWidgetName ="example/android/NativeName";
    public static void registerWith(PluginRegistry registry) {
        final String key = AndroidNativeViewFlutterPlugin.class.getCanonicalName();

        if (registry.hasPlugin(key)) return;
        PluginRegistry.Registrar registrar = registry.registrarFor(key);
//        registrar.activity();registrar.context()
//        组件的注册名称，在Flutter调用时需要用到，你可以使用任意格式的字符串。 在MainActivity的onCreate方法中增加注册调用
        registrar.platformViewRegistry().registerViewFactory(NativeWidgetName, new AndroidNativeViewFactory(registrar.messenger()));
    }

}
