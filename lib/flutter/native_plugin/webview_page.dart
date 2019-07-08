import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:android_intent/android_intent.dart';
import 'package:platform/platform.dart';
import 'package:url_launcher/url_launcher.dart';

//ios 配置 Opt-in to the embedded views preview by adding a boolean property to the app's Info.plist file with the key
// io.flutter.embedded_views_preview and the value YES
//Android 不需要特殊配置

//scheme跳转 配置
//iOS https://www.jianshu.com/p/0811ccd6a65d
//  目标配置info->url type->scheme
//  跳转发起者配置-> info  ios9以后配置
//  <key>LSApplicationQueriesSchemes</key>
//    <array>
//        <string>scheme</string>
//    </array>

//android 配置manifest->intent filter->data->scheme
class WebviewPage extends StatefulWidget {
  @override
  _WebviewPageState createState() => _WebviewPageState();
}

const String kNavigationExamplePage = '''
<!DOCTYPE html>  
<html>  
<body>
<h1>Test Scheme</h1> 
<!--手动点击跳转-->
<a href="sstdemo://www.sstdemo.com/mypath?key=mykey">Click to AndroidDemo</a>
</body>  
</html>
''';

class _WebviewPageState extends State<WebviewPage> {
  var url = "";
  Map<String, String> urlSources = {};
  bool progressVisible = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    final String contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    urlSources = {
      "baidu": "https://www.baidu.com",
      "flutter": "https://flutter.dev",
      "weibo": "https://www.weibo.com",
      "huya": "https://www.huya.com/",
      "AndroidDemo": "data:text/html;base64,$contentBase64"
    };
    url = urlSources["baidu"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebviewPage "),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (BuildContext context) => List<PopupMenuItem<String>>.generate(urlSources.length, (index) {
                  var key = urlSources.keys.elementAt(index);
                  return PopupMenuItem(
                    child: Text(key),
                    value: key,
                  );
                }),
            onSelected: (key) {
              url = urlSources[key];
              _controller.future.then((controller) {
                controller.loadUrl(url);
              });
              setState(() {
                progressVisible = true;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: url,
            onWebViewCreated: (viewController) {
              print("webview created =====================");
              _controller.complete(viewController);
            },
            onPageFinished: (url) {
              print("page  load finish ========= url is $url");
              setState(() {
                progressVisible = false;
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (request) {
              var url = request.url;
              print("navigationDelegate url is $url");
              if (url.startsWith("sstdemo://www.sstdemo.com")) {
                //对webview的url进行拦截，否侧无法识别自定义scheme
                // 使用AndroidIntent拉起
//                if (LocalPlatform().isAndroid) {
//                  AndroidIntent intent = AndroidIntent(
//                    action: 'action_view',
//                    data: '$url',
//                  );
//                  intent.launch().catchError((e) {
//                    //url 错误
//                    print("intent launch errr === " + e.toString());
//                  });
//                }
                //使用 url launcher 拉起
                canLaunch(url).then((canLaunch) {
                  if (canLaunch) {
                    print('canLaunch  can launch $url');
                    launch(url);
                  } else {
                    print('canLaunch  Could not launch $url');
                  }
                });
                return NavigationDecision.prevent;
              } else {
                return NavigationDecision.navigate;
              }
            },
          ),
          Visibility(visible: progressVisible, child: SizedBox(height: 3, child: LinearProgressIndicator()))
        ],
      ),
    );
  }
}
