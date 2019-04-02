// dart soundness
//A dynamic list is good when you want to have a list with different kinds of things in it.
//However, you can’t use a dynamic list as a typed list.
class Animal {}

class Cat extends Animal {}

class Dog extends Animal {}

void main() {
//  List<Cat> foo = <dynamic>[Dog()]; // Error
  List<dynamic> bar = <dynamic>[Dog(), Cat()]; // OK

  ///dynamic is not a subtype of  String      需要特定类型，但是读取类型是dynamic 需要类型转换
  Map<String, dynamic> arguments = {'argA': 'hello', 'argB': 42};

  //42转为string
  print("argB ${(arguments["argB"] as num).toString()}");

  Map<String, dynamic> argument1 = {
    'argA': ["aaa", "bbb", "cccc"]
  };
  List<String> list = argument1["argA"];
  print("list $list");
  List<String> par = argument1["argA"].cast<String>();
  print("par $par");

  //map.from 转类型
  Map<String, dynamic> argument2 = {'argA': "aaa"};
  Map<String, String> map2 = Map.from(argument2);
  print("map2 $map2");
}
