void main() {
  Map<int, String> map = <int, String>{
    1: "item 1",
    2: "item 2",
    3: "item 3",
    4: "item 4",
  };

  //key包含
  print("containsKey ${map.containsKey(3)}");
  print("containsValue ${map.containsValue("item 4")}");

  //putIfAbsent  不存在key则放入
  map.putIfAbsent(3, () => "remove 3");
  map.putIfAbsent(5, () => "this is item5");
  print("putIfAbsent $map");

  //更新key对应的value      可以不存在调用 ifAbsent   ifAbsent不存在，error
  map.update(1, (value) => "update value $value", ifAbsent: () => "1 不存在");
  print("update $map");

  //更新所有的value
  map.updateAll((key, value) {
    return "this is value $value";
  });
  print("updateAll $map");

//  map.keys
  print("keys ${map.keys}");

  //  map.value
  print("values ${map.values}");
}
