import 'dart:math' as math;

void main() {
//  math.log();
  int a = -1;
  //clamp 钳子函数  值比lowerLimit小，返回lowerLimit，值比upperLimit大，返回upperLimit,在两者之间，返回自己
  int b = a.clamp(0, 255);
  print("a $a b $b");

  //截短
  double double1 = 0.444444;
  print("double1.truncateToDouble() ${double1.truncateToDouble()}");

  //double int 截断到整数位，将丢弃小数位
  print("1.45.toInt ${1.45.toInt()}  1.55.toInt  ${1.55.toInt()}");

  //double round 4舍五入
  print("1.45.round ${1.45.round()}  1.55.round ${1.55.round()}");

  //random
  print("random bool ${math.Random.secure().nextBool()}");

  //0 到 最大值max到 1<<32
  print("random int ${math.Random.secure().nextInt(1 << 32)}");

  //0.0 到1.0
  print("random double ${math.Random.secure().nextDouble()}");
}
