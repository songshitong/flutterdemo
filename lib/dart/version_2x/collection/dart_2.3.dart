//主要更新是关于集合colleciton的
void main() {
//  1 Spread operator （...）
  List<int> list1 = [1, 2, 3];
  List<int> list2 = [4, 5, 6];
  List<int> list3 = [7, 8, 9];
  List<int> orders = [...list1, ...list2, ...list3];
  print("orders $orders");

//  2  using if in a collection

  List<String> worlds = [];
  List<String> american = ["american1", "american2", "american3"];
  List<String> chinese = ["chinese1", "chinese2", "chinese3"];
  bool isAsian = true;
  worlds.addAll(american);
  if (isAsian) worlds.addAll(chinese);

//   在集合中使用if
  worlds = [...american, if (isAsian) ...chinese];

//   3 using for in a collection

//   将orders转为widget
  List<Widget> widgets = orders.map((item) => Text("item is $item")).toList();

  //在集合中使用for
  widgets = [for (var item in orders) Text("item is $item")];

  //在map中使用if
  var a = 1, b = 2;
  var map1 = {"a": a, if (a < b) "b": b};
  var map2 = {"a": a, if (a >= b) "b": b};

  print("map1 $map1 \nmap2 $map2");
}

abstract class Widget {}

class Text extends Widget {
  Text(String text);
}
