import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
//  mockito  允许我们模拟实时Web服务或数据库，并根据情况返回特定结果

  //1添加mockito的依赖
//  dev_dependencies:
//  test: <newest_version>
//  mockito: <newest_version>
//2 编写测试用例
//3 运行
  String url = "https://jsonplaceholder.typicode.com/posts/1";
  group("test fechPost ", () {
    test("test successs ", () async {
      final client = MockClient();
      //使用mock提供的when条件，返回模拟的成功结果
      when(client.get(url))
          .thenAnswer((_) async => http.Response('{"title": "Test"}', 200));

      //测试返回结果是否是post
      expect(await fetchPost(client), TypeMatcher<Post>());
    });

    test("test error ", () async {
      final client = MockClient();
      //使用mock提供的when条件，返回模拟的成功结果
      when(client.get(url))
          .thenAnswer((_) async => http.Response('NOT FOUND', 404));

      //测试返回结果是否是post
      expect(await fetchPost(client), TypeMatcher<Post>());
    });
  });
}

//创建模拟网络请求的mockclient
class MockClient extends Mock implements http.Client {}

Future<Post> fetchPost(http.Client client) async {
  final response =
      await client.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    Post post = Post.fromJson(json.decode(response.body));
    print("fetchPost post is $post");
    return post;
  } else {
    // If that call was not successful, throw an error.
    throw Exception(
        'Failed to load post  esponse.statusCode ${response.statusCode}');
  }
}

class Post {
  String? title = "";
  static Post fromJson(Map json) => Post()..title = json["title"];
  @override
  String toString() {
    return "Post{'title':$title}";
  }
}
