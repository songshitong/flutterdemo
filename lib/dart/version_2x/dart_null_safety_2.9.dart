///null safety
///
///空安全
///
/// 1.默认情况不可以为空
/// 2.变量可以为空时使用？   ?跟在类型后面
/// 3.延迟初始化late
/// 4.required
/// 5. ！确定变量不为空，但在运行时空抛出异常
/// 6. ?..arrivalDate
/// 7. never
/// 8. ?[]
/// 9. late final
//
///
///
/// 开启方式：
/// analysis_options.yaml
/// analyzer:
///   enable-experiment:
///     - non-nullable
///
/// 迁移到空安全
/// 1.迁移前确保在dart 2.12以前并确保dart migrate存在且不开启空安全(否则执行命令analyze失败)  例如，使用flutter 1.22.4(内置dart 2.10.4)
/// 2.dart migrate --skip-pub-outdated --ignore-errors --ignore-exceptions      --ignore-exceptions(Generating migration suggestions产生的异常)     --skip-pub-outdated( Skip the `pub outdated --mode=null-safety` check 忽略不支持空安全的依赖检查) --ignore-errors(忽略analysis errors)
///   dart migrate --skip-import-check  --ignore-errors --ignore-exceptions     --skip-pub-outdated 不可用时使用--skip-import-check
/// 3.修改warning,error
/// 4.flutter run --no-sound-null-safety    --no-sound-null-safety(防止依赖没有空安全)
///
void main() {
  ///可空变量
  int? j = null;

  ///默认不能为空
  // int i= null;

  ///list可为空
  List<String>? list;
  print(list);

  ///list中item可为空
  List<String?> list1 = [];
  print(list1);

  ///list和item都可为空   list.add(object)此时object不能为可空类型
  List<String?>? list2;
  print(list2);

  ///map 可为空
  Map<String, int>? map;
  print(map);

  ///map中int可为空
  Map<String, int?> map2 = {};
  print(map2);

  ///map和int都可为空
  Map<String, int?>? map3;
  print(map3);
}

///参数可为空
void boogie(int? count) {}

///返回值可为空
String? getFoo() {}

///required参数可以不声明初始值
void boogie2({required int count}) {}

///返回future的函数 带上async可正常返回空
Future<void> setVolume(double volume) async {
  return getFuture();
}

///返回future的函数 没有async  返回不正常
// Future<void> setVolume1(double volume) {
//   return getFuture();
// }

Future<void>? getFuture() async {
  return Future.value(null);
}

///Non-nullable instance field 'code' must be initialized.
class AClass {
  int code = 0;
  int? code1;
  // int code2;
}

/// If you know that a non-nullable variable will be initialized to a non-null value before it’s used,
/// but the Dart analyzer doesn’t agree, insert late before the variable’s type:

/// The late keyword has two effects:
/// The analyzer doesn’t require you to immediately initialize a late variable to a non-null value.
/// The runtime lazily initializes the late variable.
/// For example,if a non-nullable instance variable must be calculated, adding the late modifier delays the calculation until the first use of the instance variable.
///
/// 使用late声明的变量，变量使用时必须全部初始化，否则报错LateInitializationError
class IntProvider {
  late int aRealInt;

  IntProvider() {
    aRealInt = calculate();
  }

  int calculate() {
    return 0;
  }
}

///声明为required，可以不用给初始值,此时初始值可以为null
class CommentsItem {
  String comments;

  CommentsItem({required this.comments});
}

///抽象方法抛出异常，或者没有方法体
abstract class BaseTable {
  Future query() {
    throw UnimplementedError();
  }

  Future delete();
}

///  !  对于可空参数，已经做过空检查时可以使用! 告诉编译器通过，同时保证了参数使用时不为空
void setAA() {
  String? a;
  if (isNotEmpty(a)) {
    a!.toLowerCase();
  }
}

bool isNotEmpty(String? str) {
  return null != str;
}

///never List<Never> 只有Never可以填进去，说明该list是个空list，不可以放null，其他对象
List<Never> getNeverList(){
  List<Never> neverList = [Never,Never];
  return neverList;
}

///?[]
void dealList(){
  List<int>? list = [1, 2, 3];

  int? x = list?[0]; // 1
}

///late final
void dealLateFinal(){
  late final int a;
  a=5;
}