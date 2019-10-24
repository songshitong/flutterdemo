package com.example.flutterdemo.application

import android.util.Log
import com.alibaba.sdk.android.push.CommonCallback
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory
import com.jarvanmo.rammus.RammusPushIntentService
import io.flutter.app.FlutterApplication

class MApplication :FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        PushServiceFactory.init(applicationContext)
        val pushService = PushServiceFactory.getCloudPushService()
        val callback = object : CommonCallback {
            override fun onSuccess(response: String?) {
                Log.e("TAG","success $response")

            }

            override fun onFailed(errorCode: String?, errorMessage: String?) {
                Log.e("TAG","error $errorMessage")

            }
        }

        pushService.register(applicationContext,callback)
        pushService.setPushIntentService(RammusPushIntentService::class.java)
    }
}