void main() {
  var perfectCookie = const PerfectCookie(number_of_chips: 1);
  print("perfectCookie ${perfectCookie.number_of_chips}");
  //不可以再次赋值
  // perfectCookie.number_of_chips = 2;

  var perfectCookie1 = const PerfectCookie1();
  //不可以再次赋值
  // perfectCookie1.number_of_chips=2;
  print("perfectCookie1 ${perfectCookie1.number_of_chips}");
}

class PerfectCookie {
  final number_of_chips;
  const PerfectCookie({this.number_of_chips});
}

class PerfectCookie1 {
  final number_of_chips = 42;
  const PerfectCookie1();
}
