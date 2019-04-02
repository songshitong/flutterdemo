//List<Widget>.generate       生成list

import 'dart:math';

void main() {
  List<int> inits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  //生成长度为5的list
  List<String> strs = List<String>.generate(5, (index) {
    return "index $index";
  });
  print("strs $strs");

  //从一个iterable生成list
  Map<int, int> initMap = <int, int>{1: 1, 2: 2};
  List<int> fromList = List<int>.from(initMap.keys);
  print("fromList $fromList");

  //List.of  调用List.from 生成一个新的list

  //List.unmodifiable 生成一个不可修改的list   add抛出异常
  List<int> unmList = List.unmodifiable(inits);
//  unmList.add(11);
  print("unmList $unmList");

  //List.copyRange 将一个list的一部分[start,end）复制到另一个list   at放置开始位置   放置list长度必须>= a+copy length
  List copyRangeList = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  List.copyRange(copyRangeList, 1, inits, 0, 3);
  print("copyRangeList $copyRangeList");

  //排序  >0 从大到小
  inits.sort((a, b) {
    return b.compareTo(a);
  });
  print("sort inits $inits");

  //删除第几个
  inits.removeAt(inits.length - 1);
  //删除最后一个
  inits.removeLast();
  //删除符合条件的
  inits.removeWhere((item) {
    //参数为每个小项
    return item == 2;
  });
  //删除对象
  inits.remove(6);
  //删除[star,end)  前闭后开
  inits.removeRange(0, 1);
  print("inits remove $inits");

  //asmap  转为Map<int,E>    index-value形式的map
  print("asMap ${inits.asMap()}");

  //重写操作符 [] []= +
  print("[] ${inits[0]}");
  inits[0] = 100;
  print("[]= $inits");
  List<int> append = [0, 0, 0, 10, 10, 10, 10, 10];
  print("+ ${inits + append}");

  //setRange   从源拿出数据放到目标[start,end)， 可设置源跳过前几个
  List list2 = [0, 0, 0, 0, 0, 0, 0];
  list2.setRange(0, 3, inits, 2);
  print("inits $inits");
  print("list2 $list2");

  //retainWhere 保留符合条件的元素，
  inits.retainWhere((item) => item == 100);
  print("retainWhere $inits");

  //lastIndex 从后往前查找符合条件的最后一个(最大一个) ,从start到0     start为0从end开始查找
  List<String> notes = ['do', 're', 'mi', 're'];
  int lastIndex = notes.lastIndexOf('re', 2); // 查找顺序 mi ,re,do,
  print("lastIndex $lastIndex");
  int lastIndex1 = notes.lastIndexOf('re'); //查找顺序 re,mi,re,do
  print("lastIndex1 $lastIndex1");

  //  lastIndexWhere 符合条件的index
  int lastIndexWhere1 = notes.lastIndexWhere((note) => note.startsWith('r')); //3  re,mi,re,do
  print("lastIndexWhere1 $lastIndexWhere1");
  int lastIndexWhere2 = notes.lastIndexWhere((note) => note.startsWith('r'), 2); //1  me,re,do
  print("lastIndexWhere2 $lastIndexWhere2");

  //shuffle  洗牌,打乱顺顺序
  List<int> list4 = [1, 2, 3, 4];
  list4.shuffle(Random.secure());
  print("shuffle $list4");
}
