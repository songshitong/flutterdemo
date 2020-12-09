void main() {
  List<int> inits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  //list ,map, set 实现iterable 都可以用
  //以分隔符"！"合并为string
  print("join ${inits.join("|")}");

  //.iterrator 获取迭代器
  print("inits.iterator.moveNext() ${inits.iterator.moveNext()}");

  //  cast   强转list的类型
  List<dynamic> castList = [1, 2, 3, 4];
  print("cast ${castList.cast<int>()}");
  List<num> doubleList = [0, 1, 2];
  print("cast ${doubleList.cast<int>()}");
  //castfrom static方法强转
  print("castfrom ${List.castFrom(doubleList)}");

  //map  对每个元素执行函数F,返回iterable  适用于取列表中每个对象的某个属性然后生成新的列表，或者对每个对象进行某种操作
  var map = inits.map((item) {
    return "${item + 1}";
  });
  print("map ${map.toList()}");

  //followedBy 将一个list放在另一个后面
  List<int> list3 = [1, 3, 5, 7, 9];
  print("followedBy ${inits.followedBy(list3)}");

  //wheretype  从iterable选出特定类型的list
  Iterable<int> iterable = inits.whereType<int>();
  print("whereType $iterable  runtimetype ${iterable.runtimeType}");

  //where  取出符合条件的item并转为list输出
  List<int> newList = inits.where((item) {
    return item == 0;
  }).toList();
  print("where $newList");

  //expand  把每一个元素扩展为0或更多的元素
  List<int> expandList1 = inits.expand((item) => [item, item * item]).toList();
  print("expandList1 $expandList1");
  List<int> expandList2 = [
    [1, 2],
    [3, 4]
  ].expand((item) {
    print("expand $item");
    return item;
  }).toList();
  print("expandList2 $expandList2");

  //contains  是否存在
  print("contain ${inits.contains(0)}");

  //forEach
  inits.forEach((e) {});

  //reduce     根据结合函数，将iterable的每一个元素缩减为一个
  var reduce = inits.reduce((item1, item2) {
    return item1 + item2;
  });
  print("reduce $reduce");

  //fold    根据结合函数，将iterable的每一个元素缩减为一个,操作前有个初始值
  var fold = inits.fold(1, (dynamic item1, item2) {
    return item2 + item1;
  });
  print("fold $fold");

  //every  检测是否所有元素满足条件
  print(" every ${inits.every((item) => item < 100)}");

  //any    检测是否存着满足条件的元素
  print("any ${inits.any((item) => item > 9)}");

  //take  取几个元素
  print("take ${inits.take(3)}");

  //takewhile   取元素直到不满足条件 第一个元素不满足则不会继续下去
  print("takeWhile ${inits.takeWhile((item) => item < 5)}");
  List<int> list1 = [10, 5, 5, 5, 5, 5];
  print("takeWhile ${list1.takeWhile((item) => item < 6)}");

  //skip 跳过前几个元素
  print("skip ${inits.skip(5)}");
  //skipWhile 跳过元素直到不满足条件
  print("skipWhile inits ${inits.skipWhile((item) {
    return item < 3;
  })}");
  List<int> list2 = [10, 4, 4, 4, 4, 4, 4];
  print("skipWhile inits ${list2.skipWhile((item) {
    //跳过元素直到item>=9  结果输出所有list2
    return item < 9;
  })}");

  //first
  print("first ${inits.first}");

  //last
  print("last ${inits.last}");

  // single 验证是否只有一个元素     空或者多个抛出异常
  var single;
  try {
    single = inits.single;
  } catch (e) {
    print("single error ${e.toString()}");
  }
  print("single ${single}");

  //fistwhere  返回满足条件的第一个元素
  print("firstwhere ${inits.firstWhere((item) => item > 5)}");

  //lastwhere  返回满足条件的最后一个元素
  print("lastwhere ${inits.lastWhere((item) => item > 5)}");

  //singlewhere     只有一个元素满足，返回这个元素，多个元素满足，抛出异常，没有元素满足，返回orElse的结果，如果orElse为空，抛出异常
  print(
      "singlewhere ${inits.singleWhere((item) => item > 10, orElse: () => 0)}");

  //elementAt   返回第几个元素
  print("elementat ${inits.elementAt(1)}");
}
