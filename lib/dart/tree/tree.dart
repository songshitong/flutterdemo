import 'dart:collection';

void main() {
  ///构建一棵树
  ///1{
  ///  2{
  ///    4
  ///    5
  ///  }
  ///  3{
  ///    6
  ///  }
  ///}
  var node2 = Node()
    ..name = "2"
    ..left = (Node()..name = "4")
    ..right = (Node()..name = "5");
  var node3 = Node()
    ..name = "3"
    ..left = (Node()..name = "6");
  var root = Node()
    ..name = "1"
    ..left = node2
    ..right = node3;
  print("Front Order ====");
  root.printFrontOrder();
  print("Middle Order ====");
  root.printMiddleOrder();
  print("Behind Order ====");
  root.printBehindOrder();

  print("Layer Order ====");

  ///层级排序类似广度优先
  ///1. 存在固定顺序，先进先出
  ///2. 需要临时数据(树的结构，一层一层遍历，兄弟节点不存在连接线，需要临时数据去保存)
  ///3. 综合以上两点需要队列
  ///
  /// 前中后排序类似深度优先
  /// 1. 存在固定顺序，先进先出
  /// 2. 不需要临时数据(树的结构，父子节点存在连接线，顺序执行就可)
  var node = root;

  ///实现先进先出fifo并存储临时节点 1,2,3,4,5,6
  var queue = ListQueue<Node?>();
  queue.add(node);

  ///队列为空停止
  while (!queue.isEmpty) {
    var first = queue.first;
    print("${first?.name}");
    queue.removeFirst();

    ///每次循环执行第一个的name并弹出

    ///判断第一个是否有子节点并加入队列
    if (null != first?.left) {
      queue.add(first?.left);
    }
    if (null != first?.right) {
      queue.add(first?.right);
    }
  }
}

///todo 迭代和递归的性能比较
///
/// https://blog.csdn.net/qq_43503315/article/details/89418215
class Node {
  String name = "";
  Node? left;
  Node? right;

  ///前后中指根节点的位置
  ///前序遍历 1,2,4,5,3,6   根，左，右
  printFrontOrder() {
    print("$name");
    left?.printFrontOrder();
    right?.printFrontOrder();
  }

  ///中序遍历 2,4,5,1,3,6  左，根，右
  printMiddleOrder() {
    left?.printFrontOrder();
    print("$name");
    right?.printFrontOrder();
  }

  ///后序遍历 2,4,5,3,6,1  左，右，根
  printBehindOrder() {
    left?.printFrontOrder();
    right?.printFrontOrder();
    print("$name");
  }
}
