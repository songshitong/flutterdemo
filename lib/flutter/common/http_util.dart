import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

///代码来自 https://medium.com/@petehouston/download-files-in-dart-4f382f86a9f9
class HttpUtil {
  static Future getUrl(String url) async {
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    response.transform(utf8.decoder).listen((contents) {
      return Future.value(contents);
    });
  }

  static void downloadFile(String saveFile, String downloadUrl) {
    HttpClient client = new HttpClient();
    var _downloadData = List<int>();
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
}
