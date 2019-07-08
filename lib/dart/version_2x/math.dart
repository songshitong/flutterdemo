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

  // TODO  spread operator
}
