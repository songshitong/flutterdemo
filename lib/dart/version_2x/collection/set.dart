void main() {
  Set<int> set1 = Set();
  set1..add(1)..add(2)..add(3)..add(4);
  //contains 是否存在元素
  print("contains ${set1.contains(1)}");

  //containsAll 是否存在所有iterable的元素
  print("containsAll ${set1.containsAll([1, 2, 3, 4])}");
  print("containsAll ${set1.containsAll([1, 2, 3, 4, 5, 6, 7])}");

  //lookup 查找元素，存在返回该元素，不存在返回null；
  print("lookup ${set1.lookup(2)}");
  print("lookup ${set1.lookup(20000)}");

  Set<int> set2 = Set()..add(2)..add(3)..add(4)..add(5)..add(6);
  // difference  差集 set1 -set2
  print("set1 difference set2 ${set1.difference(set2)}");
  print("set2 difference set1 ${set2.difference(set1)}");

  //union 并集
  print("union ${set1.union(set2)}");

  //相交  交集
  print("intersection ${set1.intersection(set2)}");
}
