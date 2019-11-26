import 'dart:convert';

import 'package:crypto/crypto.dart';

main() async {
  var str = "i am string";
  var strMd5 = md5.convert(utf8.encode(str)).toString();
  print("strMd5 $strMd5");

  //文件生成md5
  //  var hash = await md5.bind(file.openRead()).first;
//  var ret = hex.encode(hash.bytes).toUpperCase();
//  print("md5 ${md5.bind(stream)}");
}
