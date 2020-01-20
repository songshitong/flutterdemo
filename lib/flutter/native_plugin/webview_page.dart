import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterdemo/flutter/common/SingleLonData.dart';
import 'package:flutterdemo/flutter/common/http_util.dart';
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

///img 加载图片
///      <img src="https://i.imgur.com/wxaJsXF.png" alt="web-img1">
//      <img src="file:/Users/Faisal/Projects/Flutter_Apps/flutter_app/assets/f.png" alt="web-img2">
//      <img src="file:///Users/Faisal/Projects/Flutter_Apps/flutter_app/assets/f.png" alt="web-img3">
//      <img src="file:f.png" alt="web-img4">
//      <img src="file:///storage/assets/f.png" alt="img5">
//      <img src="file:///android_asset/flutter_assets/assets/f.png" alt="web-img6">
//      <img src="/Users/Faisal/Projects/Flutter_Apps/flutter_app/assets/f.png" alt="web-img6">

//改变webview的高度，js获取的高度是否有问题   document获取高度和div获取高度的区别
class WebviewPage extends StatefulWidget {
  @override
  _WebviewPageState createState() => _WebviewPageState();
}

var appDocDir = SingleLonData().appDocDir;
String kNavigationExamplePage = '''
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
<div><input type="file" name="video" id="video" accept="video/mp4" style="margin-top:10px">video</input></div>
<div><button onclick="showImage()" style="margin-top:10px;display:block;"/>showImage</button></div>
<div><button onclick="showVideo()" style="margin-top:10px;display:block;"/>showVideo</button></div>

<div><img src="http://depot.nipic.com/file/20150423/20829447_16153273773.jpg" id="imgShow" style="margin-top:10px;width: 200px; height: 100px; display:block;"></div>
<div><video controls autoplay  src="http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4" id="videoShow" style="margin-top:10px;width: 200px; height: 100px; display:block;"></div>


</body>  
</html>
''';

String tag =
    '''<h1 style="text-align: center;"><img src="https://cdn.duitang.com/uploads/item/201601/15/20160115155749_BQ3Vk.jpeg" alt="" width="500" height="500" /></h1>
<h1 style="text-align: center;">&nbsp;</h1>
<h1 style="text-align: center;">Welcome to the TinyMCE demo!</h1>
<p style="text-align: center; font-size: 15px;"><img title="Logo" src="favicon.ico" alt="Logo" width="100" height="100" /></p>
<ul>
<li>Our <a href="https://www.tiny.cloud/docs/" target="_blank" rel="noopener">documentation</a> is a great resource for learning how to configure TinyMCE.</li>
<li>Have a specific question? Visit the <a href="https://community.tinymce.com/forum/">Community Forum</a>.</li>
<li>We also offer enterprise grade support as part of <a href="https://tinymce.com/pricing">TinyMCE premium subscriptions</a>.</li>
</ul>''';

//file:///$appDocDir/20829447_16153273773.jpg
//file:///data/user/0/com.example.flutterdemo/app_flutter/20829447_16153273773.jpg
//http://depot.nipic.com/file/20150423/20829447_16153273773.jpg
class _WebviewPageState extends State<WebviewPage> {
  var url = "";
  Map<String, String> urlSources = {};
  bool progressVisible = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  var localHtml = SingleLonData().appDocDir + "/localHtml.html";
  //缓存HTML ，图片，视频，然后加载本地页面及图片，视频
  Map<String, String> replaceActions = {"load": "加载页面", "cache": "缓存到本地", "loadCache": "加载本地缓存"};
  var saveFile;
  var videoFile;

  @override
  void initState() {
    super.initState();
    final String contentBase64 = base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));

    ///加载base64不会自动链接到本地资源，直接加载本地HTML可以？？
    ///webview shouldInterceptRequest直接拦截file协议，将HTML读作资源展示，展示HTML源码，pdf的展示可以吗，其他资源展示，利用原生
    ///解析，转换为web展示的资源可以吗
    urlSources = {
      "localFile": "file:///$localHtml",
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
          "http://storage.jd.com/eicore-fm.jd.com/011001900411-61816050.pdf?Expires=2516350040&AccessKey=bfac05320eaf11cc80cf1823e4fb87d98523fc94&Signature=3YPHQZPL%2F%2FzI3l0CgV0zLYTdib0%3D",
      "全景新闻": "http://vr.ce.cn/tyvr/lh/20180305/bztd2/",
      "html5test": "https://html5test.com"
    };
    //直接加载本地，先判断文件存在不
    if (File(localHtml).existsSync()) {
      url = urlSources["localFile"];
    } else {
      url = urlSources["AndroidDemo"];
    }
  }

  ///高度使用contrainbox而不是sizebox
  ///webview获取内容高度后更新自己  使用js最多加载3000px然后崩溃   https://stackoverflow.com/questions/57651134/flutter-set-webview-height-as-wrap-content
  ///onPageFinished: (some) async {
  //                double height = double.parse(await _listController[index]
  //                    .evaluateJavascript(
  //                        "document.documentElement.scrollHeight;"));
  //                setState(() {
  //                  _heights[index] = height;
  //                });
  //              },

  /// webview 滑动冲突
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

                rootBundle.loadString("lib/game/flappybird/index.html").then((result) {
                  print("flappybird/index.html $result");
                  //通过<link rel=stylesheet href=styles/main.css>加载的不显示
                  //通过<style>或<script>加载的可以显示
                  //base64+file://无法加载file
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
            onSelected: (key) {
              if (key == "load") {
                url = urlSources["AndroidDemo"];
                _controller.future.then((controller) {
                  controller.loadUrl(url);
                  setState(() {
                    progressVisible = true;
                  });
                });
              } else if (key == "cache") {
                //体取网页中链接
                var document = parse(kNavigationExamplePage);
                var imgElements = document.querySelectorAll("img");
                var newString;
                imgElements.forEach((e) {
                  var url = e.attributes["src"];
                  print("document img url  $url ");
                  //下载存储
                  var temp = url.split(".");
                  var suffix = temp.last;
                  var name = temp[temp.length - 2].split("/").last;
                  saveFile = SingleLonData().appDocDir + "/" + name + "." + suffix;
                  print("img name $name  saveFile $saveFile");

                  //是否对同一图片重复下载？，下载失败？
                  HttpUtil.downloadFile(saveFile, url);
                  newString = kNavigationExamplePage.replaceAll(url, saveFile);
//                  File file = new File(localHtml);
//                  if (!file.existsSync()) {
//                    file.createSync();
//                  }
//                  file.writeAsString(newString);
                });

                var videoElements = document.querySelectorAll("video");
                videoElements.forEach((e) {
                  var url = e.attributes["src"];
                  print("document video url  $url ");
                  //下载存储
                  var temp = url.split(".");
                  var suffix = temp.last;
                  var name = temp[temp.length - 2].split("/").last;
                  videoFile = SingleLonData().appDocDir + "/" + name + "." + suffix;
                  print("img name $name  saveFile $videoFile");

                  //是否对同一视频重复下载？，下载失败？
                  HttpUtil.downloadFile(videoFile, url);
                  newString = newString.replaceAll(url, videoFile);
                  File file = new File(localHtml);
                  if (!file.existsSync()) {
                    file.createSync();
                  }
                  file.writeAsString(newString);
                });
              } else if (key == "loadCache") {
                _controller.future.then((controller) {
                  var fileString = File(localHtml).readAsStringSync();
                  var imgBase64 = File(saveFile).readAsBytesSync();
                  var videoBase64 = File(videoFile).readAsBytesSync();

                  //将本地URL替换为base64
                  fileString = fileString.replaceAll(saveFile, "data:text/image;base64,${base64Encode(imgBase64)}");
                  fileString = fileString.replaceAll(videoFile, "data:video/mp4;base64,${base64Encode(videoBase64)}");
                  //ios 可以播放video base64 但是视频转为base64需要消耗时间
                  //Android 播放video base64 有问题
                  print(
                      "img base64 " + "data:text/image;base64,${base64Encode(const Utf8Encoder().convert(saveFile))}");

                  var base64 = "data:text/html;base64,${base64Encode(const Utf8Encoder().convert(fileString))}";
                  var localUri =
                      Uri.dataFromString(fileString, mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
                          .toString();
                  controller.loadUrl(localUri);
                  setState(() {
                    progressVisible = true;
                  });
                });
              }
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onHorizontalDragDown: (downDetail) {
              print("GestureDetector down ");
            },
            onHorizontalDragUpdate: (updateDetail) {
              print("GestureDetector update ");
            },
            child: WebView(
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
              javascriptChannels: <JavascriptChannel>[
                ///js调用flutter   flutter调用js  _controller.evaluateJavascript
                _alertJavascriptChannel(context)
              ].toSet(),
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
              gestureRecognizers: Set()
                ..add(Factory(() {
                  var x;
                  return HorizontalDragGestureRecognizer()
                    ..onDown = (downDetail) {
                      print("ondown  ===== ");
                      x = downDetail.globalPosition.dx;
                    }
                    ..onUpdate = (updateDetail) {
                      print("onupdate =====");
                      if (updateDetail.globalPosition.dx - x > 100) {
                        _controller.future.then((controller) async {
                          final go = await controller.canGoBack();
                          print("controller ==== go back $go ");
                          if (go) {
                            controller.goBack();
                          }
                        });
                      }
                    }
                    ..onEnd = (endDetail) {
                      print("onEnd  ===== ");
                    }
                    ..onCancel = () {
                      print("onCancel  ===== ");
                    };
                })),
            ),
          ),
          Visibility(visible: progressVisible, child: SizedBox(height: 3, child: LinearProgressIndicator()))
        ],
      ),
    );
  }

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    ///js调用方法    Toast.postMessage("JS调用了Flutter");
    return JavascriptChannel(
        name: 'Toast',
        onMessageReceived: (JavascriptMessage message) {
//          showToast(message.message);
        });
  }
}
