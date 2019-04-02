import 'package:flutterdemo/dart/version_2x/Btn.dart';

void main() {
//  /// =
//  var c/*= "c"*/;
//  print("c 结果是 ");
//  print(c);
//
//  ///   ??=
//  c ??= "cc";
//  print("c 结果是 ");
//  print(c);

  ///  / 除法
//  print("\n1/2 结果为 ");
//  print(1 / 2);
//
//  /// ~/
//  print("\n~/ 结果为 ");
//  print(10 ~/ 4.5);
  int numA = 3;
  int numB = 4;
  int numC = 5;
  //numB ，numC结果相等
  print("numA ${numA ~/ 2}");
  print("numB ${numB ~/ 2}");
  print("numB ${numC ~/ 2}");
//
//  /// % 模除
//  print("\n3%2结果为 ");
//  print(3 % 2);

  /// ?.
//  Button btn/*= Button()*/;
////  btn.setColor("red");
////  print("\n. color " + btn.color.toString());
//  print("\n?. color " + btn?.color.toString());

  ///   ..级联操作符
  Button aBtn = new Button();
  aBtn.setColor("red");
  aBtn.setText("this is a btn");
//
//  new Button()
//    ..setText("this is anothor  btn ")
//    ..setColor("blue");

//
///// 使用..级联操作符
//Button getBtn() {
//  return Button()
//    ..setText("this is a btn")
//    ..setColor("red");
}
