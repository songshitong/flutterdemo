import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sharesdk/sharesdk.dart';

/// shareSDK flutter版本
class ShareSDKPage extends StatefulWidget {
  @override
  _ShareSDKPageState createState() => _ShareSDKPageState();
}

class _ShareSDKPageState extends State<ShareSDKPage> {
  @override
  void initState() {
    ShareSDKRegister register = ShareSDKRegister();
    register.setupWechat("wx617c77c82218ea2c", "c7253e5289986cf4c4c74d1ccc185fb1");
    register.setupSinaWeibo("568898243", "38a4f8204cc784f81f9f0daaf31e02e3", "http://www.sharesdk.cn");
    register.setupQQ("100371282", "aed9b0303e3ed1e27bae87c33761161d");
    ShareSDK.regist(register);
    if (TargetPlatform.android == defaultTargetPlatform) {
      ShareSDK.listenNativeEvent();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("分享"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              shareToWechat(context);
            },
            child: Text("分享图片到微信"),
          )
        ],
      ),
    );
  }

  void shareToWechat(BuildContext context) {
    SSDKMap params = SSDKMap()
      ..setGeneral(
          "title",
          "text",
          [
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1541565611543&di=4615c8072e155090a2b833059f19ed5b&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201501%2F06%2F20150106003502_Ajcte.jpeg"
          ],
          "http://pic28.photophoto.cn/20130818/0020033143720852_b.jpg",
          null,
          "http://pic28.photophoto.cn/20130818/0020033143720852_b.jpg",
          "http://pic28.photophoto.cn/20130818/0020033143720852_b.jpg",
          "http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT",
          "http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT",
          SSDKContentTypes.image);

    ShareSDK.share(ShareSDKPlatforms.wechatSession, params,
        (SSDKResponseState state, Map userdata, Map contentEntity, SSDKError error) {
      showAlert(state, error.rawData, context);
    });
  }

  void showAlert(SSDKResponseState state, Map content, BuildContext context) {
    print("--------------------------> state:" + state.toString() + " content $content");
    String title = "失败";
    switch (state) {
      case SSDKResponseState.Success:
        title = "成功";
        break;
      case SSDKResponseState.Fail:
        title = "失败";
        break;
      case SSDKResponseState.Cancel:
        title = "取消";
        break;
      default:
        title = state.toString();
        break;
    }
  }
}
