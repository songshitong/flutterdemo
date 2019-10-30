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
<head>
<script type="text/javascript">
    window.onload= function(){
      alert("window load");
      const input = document.getElementById('pic');
      input.addEventListener('input', function(e){
         console.log("input ======");
         console.log(e.srcElement.value);
      });
    }
  
  function showImage(){
      var localImg = getPath('pic');
      console.log("localImg  "+localImg);
      document.getElementById('imgShow').src =localImg ;
    }
  function showVideo(){
      console.log("before "+document.getElementById('video').value);
      var localVideo = getPath('video');
      console.log("localVideo  "+localVideo);
      document.getElementById('videoShow').src =localVideo ;
  }
    
  function getPath(id) {
		var imgURL = "";
		var node=document.getElementById(id);
		try{
			var file = null;
			if(node.files && node.files[0] ){
				file = node.files[0];
			}else if(node.files && node.files.item(0)) {
				file = node.files.item(0);
			}
			//Firefox 因安全性问题已无法直接通过input[file].value 获取完整的文件路径
			try{
				//Firefox7.0
				imgURL =  file.getAsDataURL();
				//alert("//Firefox7.0"+imgRUL);
			}catch(e){
				//Firefox8.0以上
				imgURL = window.URL.createObjectURL(file);
				//alert("//Firefox8.0以上"+imgRUL);
			}
		}catch(e){      //这里不知道怎么处理了，如果是遨游的话会报这个异常
			//支持html5的浏览器,比如高版本的firefox、chrome、ie10
			if (node.files && node.files[0]) {
				var reader = new FileReader();
				reader.onload = function (e) {
					imgURL = e.target.result;
				};
				reader.readAsDataURL(node.files[0]);
			}
		}
		return imgURL;
	}
    
</script>
</head>

<body>
<h1>Test Scheme</h1> 
<!--手动点击跳转-->
<div><a href="sstdemo://www.sstdemo.com/mypath?key=mykey">Click to AndroidDemo</a></div>
<div><input type="file" name="pic" id="pic" accept="image/*" style="margin-top:10px"/>image</input></div>
<div><input type="file" name="video" id="video" accept="video/*" style="margin-top:10px">video</input></div>
<div><button onclick="showImage()" style="margin-top:10px;display:block;"/>showImage</button></div>
<div><button onclick="showVideo()" style="margin-top:10px;display:block;"/>showVideo</button></div>

<div><img src="blob:null/80ce1466-f18a-4f1c-a9b7-b829f2306975" id="imgShow" style="margin-top:10px;width: 200px; height: 100px; display:block;"></div>

<div><video controls autoplay loop src="http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4" id="videoShow" style="margin-top:10px;width: 200px; height: 100px; display:block;"></div>

</body>  
</html>
''';

class _WebviewPageState extends State<WebviewPage> {
  var url = "";
  Map<String, String> urlSources = {};
  bool progressVisible = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  //缓存HTML ，图片，视频，然后加载本地页面及图片，视频
  Map<String, String> replaceActions = {"load": "加载页面", "cache": "缓存到本地", "loadCache": "加载本地缓存"};
  @override
  void initState() {
    super.initState();
    final String contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    urlSources = {
      "localFile": "localFile",
      "baidu": "https://www.baidu.com",
      "flutter": "https://flutter.dev",
      "weibo": "https://www.weibo.com",
      "huya": "https://www.huya.com/",
      "vant": "https://youzan.github.io/vant/mobile#/zh-CN/",
      "cube-ui": "https://didi.github.io/cube-ui/example/#/",
      "AndroidDemo": "data:text/html;base64,$contentBase64",
      "hilo--flappybird": "file:///android_asset/flutter_assets/lib/game/flappybird/index.html",
      "hilo--水果忍者": "http://g.alicdn.com/tmapp/hilodemos/3.0.7/fruit-ninja/index.html",
      "白鹭--守卫我的塔": "http://dev.egret.com//cn/article/index/id/1074",
      "白鹭--密室逃脱": "http://dev.egret.com//cn/article/index/id/891",
      "cocos star-catcher": "http://fbdemos.leanapp.cn/star-catcher/",
      "pdf":
          "http://storage.jd.com/eicore-fm.jd.com/011001900411-61816050.pdf?Expires=2516350040&AccessKey=bfac05320eaf11cc80cf1823e4fb87d98523fc94&Signature=3YPHQZPL%2F%2FzI3l0CgV0zLYTdib0%3D"
    };
    url = urlSources["AndroidDemo"];
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
              if (url == "localFile") {
                //加载base64
                DefaultAssetBundle.of(context).loadString("lib/game/flappybird/index.html").then((result) {
                  print("flappybird/index.html $result");
                  //todo ios/android 加载不出来
                  var flappyBase64 = "data:text/html;base64,${base64Encode(const Utf8Encoder().convert(result))}";
                  var flappyUri =
                      Uri.dataFromString(result, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                          .toString();
                  url = flappyUri;
                  _controller.future.then((controller) {
                    controller.loadUrl(url);
                    setState(() {
                      progressVisible = true;
                    });
                  });
                });
              } else {
                _controller.future.then((controller) {
                  controller.loadUrl(url);
                  setState(() {
                    progressVisible = true;
                  });
                });
              }
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => List<PopupMenuItem<String>>.generate(replaceActions.length, (index) {
              var key = replaceActions.keys.elementAt(index);
              return PopupMenuItem(
                child: Text(key),
                value: key,
              );
            }),
            onSelected: (key) {},
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          WebView(
            initialUrl: url,
            onWebViewCreated: (viewController) {
              _controller.complete(viewController);
              print("webview created =====================");
            },
            onPageFinished: (url) {
              print("page  load finish ========= url is $url  initialUrl ${this.url}");
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
