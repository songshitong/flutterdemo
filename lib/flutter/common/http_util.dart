import 'dart:convert';
import 'dart:io';

///代码来自 https://medium.com/@petehouston/download-files-in-dart-4f382f86a9f9
class HttpUtil {
  static Future? getUrl(String url) async {
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    Future<String>? result;
    response.transform(utf8.decoder).listen((contents) {
      result = Future.value(contents);
    });
    return result;
  }

  static void downloadFile(String saveFile, String downloadUrl) {
    HttpClient client = new HttpClient();
    List<int> _downloadData = [];
    var fileSave = new File(saveFile);
    if (!fileSave.existsSync()) {
      fileSave.createSync();
    }
    client.getUrl(Uri.parse(downloadUrl)).then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) {
      response.listen((d) => _downloadData.addAll(d), onDone: () {
        fileSave.writeAsBytes(_downloadData);
      });
    });
  }

  static Future post() async {
    final client = HttpClient();
    final request =
        await client.postUrl(Uri.parse("http://trans.xiaohuaerai.com/trans"));
    var data = "s=en&d=zh-CN&q=hello";
    request.headers.set(
        HttpHeaders.contentTypeHeader, "application/x-www-form-urlencoded");
    request.headers
        .set("Authorization", "APPCODE 1fe27223b011401db9e110e42f715252");
    request.write(data);
    final response = await request.close();
    String httpValue = await response.transform(utf8.decoder).first;
    return httpValue;
  }
}
