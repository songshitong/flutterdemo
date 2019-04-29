//dart 所有东西都是对象，包括int，函数,null    所有对象的父类是objec
//Default value（默认值）//没有初始化的变量自动获取一个默认值为 null。类型为数字的 变量如何没有初始化其值也是 null，不要忘记了 数字类型也是对象

//var //一种不指定类型声明变量的方式
var aVar = 1;
double a;

//42  /*一个数字字面量。数字字面量是编译时常量。*/

//print() //一种打印内容的助手方法

//$variableName (or ${expression}) //字符串插值：在字符串字面量中引用变量或者表达式

//Dart 没有 public、 protected、 和 private 关键字。如果一个标识符以 (_) 开头，则该标识符 在库内是私有的
//

//fianl和const
//用final修饰的变量，必须在定义时将其初始化，其值在初始化后不可改变；const用来定义常量
//final只是要求变量在初始化后值不变，但通过final，我们无法在编译时（运行之前）知道这个变量的值；而const所修饰的是编译时常量，我们在编译时就已经知道了它的值，显然，它的值也是不可改变的。
//final int m1 = 60;
//final int m2 = Func(); // 正确
//const int n1 = 42;
//const int n2 = Func(); // 错误
// int Func(){
//
// }

//内置的类型
//numbers
//      Dart 支持两种类型的数字：
//        int
//        整数值，其取值通常位于 -253 和 253 之间。
//
//       double
//       64-bit (双精度) 浮点数，符合 IEEE 754 标准
int aInt = 1;
double aDobule = 1.1;

//strings
//     可以使用单引号或者双引号来创建字符串
//     在字符串中使用表达式，用法是这样的： ${expression}
//     判断内容相等用==，判断是否为同一个对象，调用函数 identical(str1,str2)
String aStr = "str";
const aa = 'aaaa';

//booleans
//当 Dart 需要一个布尔值的时候，只有 true 对象才被认为是 true。 所有其他的值都是 flase。这点和 JavaScript 不一样， 像 1、 "aString"、 以及 someObject 等值都被认为是 false。
//     要显式的 判断变量是否为布尔值类型。和Java一样
bool aBool = true;

//lists (也被称之为 arrays)列表，数组
//使用字面量创建
var list = [1, 2, 3];
//没有元素，显示指定范型参数为int
var list3 = <int>[];
//使用构造函数创建对象
var list1 = List<int>();
//定义一个不变的 list 对象
var list2 = const [1, 2, 3];

void setList() {
  //添加
  list.add(4);
  //循环
  for (var value in list) {
    print(value);
  }
  //清空
  list.clear();
}

//set
//只能通过set的构造函数创建实例  Dart 中的 Set 是一个无序集合，里面不能保护重复的数据。 由于是无序的，所以无法通过索引来从 set 中获取数据
var aSet = Set<String>();
var aSet1 = Set<String>();

void setSet() {
  aSet.add("aa");
  //包含
  aSet.contains("a");
  //交集
  var intersection = aSet.intersection(aSet1);
}

//maps
//Map 是一个键值对相关的对象。 键和值可以是任何类型的对象。每个 键 只出现一次， 而一个值则可以出现多次
var map = Map<String, int>();

void setMap() {
  map["foo"] = 1;
//  判断
  if (null == map["foo"]) {}

  var map1 = <String, String>{};
  map1["aa"] = "bb";
}

//Iterable 类定义了一些常用的功能  List 和 Set 实现了 Iterable 。  虽然 Map 没有实现 Iterable，但是 Map 的 keys 和 values 属性实现了 Iterable。
//isEmpty 函数来判断集合是否为空的
//forEach() 函数可以对集合中的每个数据都应用 一个方法
//where() 函数可以返回所有满足特定条件的数据。 any() 判断是否有数据满足特定条件， every() 判断是否所有数据都满足 特定条件

//runes (用于在字符串中表示 Unicode 字符)   在 Dart 中，runes 代表字符串的 UTF-32 code points   在字符串中表达 32-bit Unicode 值就需要 新的语法了
//通常使用 \uXXXX 的方式来表示 Unicode code point， 这里的 XXXX 是4个 16 进制的数。 例如，心形符号 (♥) 是 \u2665。 对于非 4 个数值的情况， 把编码值放到大括号中即可。 例如，笑脸 emoji (😆) 是 \u{1f600}。

//symbols
//一个 Symbol object 代表 Dart 程序中声明的操作符或者标识符。 你也许从来不会用到 Symbol，但是该功能对于通过名字来引用标识符的情况 是非常有价值的，特别是混淆后的代码， 标识符的名字被混淆了，但是 Symbol 的名字不会改变。
//使用 Symbol 字面量来获取标识符的 symbol 对象，也就是在标识符 前面添加一个 # 符号：
//#radix
//#bar

//Functions（方法）
//方法也是对象并且具有一种 类型， Function。 这意味着，方法可以赋值给变量，也可以当做其他方法的参数。 也可以把 Dart 类的实例当做方法来调用。
bool isNoble(int atomicNumber) {
  return map != null;
}

//对于只有一个表达式的方法，你可以选择 使用缩写语法来定义：     => expr 语法是 { return expr; } 形式的缩写。=> 形式 有时候也称之为 胖箭头 语法。
bool isNull(int atomicNumber) => map != null;

//Optional parameters（可选参数）
//Optional named parameters（可选命名参数）
//调用方法的时候，你可以使用这种形式 paramName: value 来指定命名参数
//enableFlags(bold: true);
//在定义方法的时候，使用 {param1, param2, …} 的形式来指定命名参数：
void enableFlags({bool bold, bool hidden}) {
  // ...
}

//Optional positional parameters（可选位置参数）
//把一些方法的参数放到 [] 中就变成可选 位置参数了：
String say(String from, String msg, [String device]) {
  if (null != device) {
    print(device);
  }
}

void callSay() {
  say('aa', 'a');
}

//Default parameter values（默认参数值）
//在定义方法的时候，可以使用 = 来定义可选参数的默认值。 默认值只能是编译时常量。 如果没有提供默认值，则默认值为 null
bool enableFlags1({bool bold = false, bool hidden = false}) {
  // ...
}

//The main() function（入口函数）
//每个应用都需要有个顶级的 main() 入口方法才能执行。 main() 方法的返回值为 void 并且有个可选的 List<String> 参数。

//Functions as first-class objects（一等方法对象）
//可以把方法当做参数调用另外一个方法
void callMethod(bool arg) {}

void demoM() => callMethod(enableFlags1());

//Anonymous functions（匿名方法）   没有名字的方法，称之为 匿名方法，有时候也被称为 lambda 或者 closure 闭包
//匿名函数和命名函数看起来类似— 在括号之间可以定义一些参数，参数使用逗号 分割，也可以是可选参数。 后面大括号中的代码为函数体：
//([[Type] param1[, …]]) {
//codeBlock;
//};
//定义了一个参数为i （该参数没有指定类型）的匿名函数。 list 中的每个元素都会调用这个函数来 打印出来，同时来计算了每个元素在 list 中的索引位置。
//var list3 = ['apples', 'oranges', 'grapes', 'bananas', 'plums'];
//list3.forEach((i) {
//print(list3.indexOf(i).toString() + ': ' + i);
//});

//Lexical scope（静态作用域）
//Dart 是静态作用域语言，变量的作用域在写代码的时候就确定过了。 基本上大括号里面定义的变量就 只能在大括号里面访问，和 Java 作用域 类似

//Lexical closures（词法闭包）
//一个 闭包 是一个方法对象，不管该对象在何处被调用， 该对象都可以访问其作用域内 的变量。
//方法可以封闭定义到其作用域内的变量。 下面的示例中，makeAdder() 捕获到了变量 addBy。 不管你在那里执行 makeAdder() 所返回的函数，都可以使用 addBy 参数
Function makeAdder(num addBy) {
  return (num i) => addBy + i;
}
//闭包
//闭包是一个方法（对象）
//闭包定义在其他方法内部
//闭包能够访问外部方法内的局部变量，并持有其状态

void main(List<String> args) {
  var func = funA();
  for (var i = 0; i < 5; i++) {
    func();
  }
  print("-------------------------");
  var func1 = b();
  for (var i = 0; i < 5; i++) {
    func1();
  }
}

Function funA() {
  int count = 0;
  printCount() {
    print(count++);
  }

  return printCount;
}

Function b() {
  int count = 10;
  return () {
    print(--count);
  };
}

//main() {
//  // Create a function that adds 2.
//  var add2 = makeAdder(2);
//  // Create a function that adds 4.
//  var add4 = makeAdder(4);
//  assert(add2(3) == 5);
//  assert(add4(3) == 7);
//}

//Testing functions for equality（测试函数是否相等）  ==

//Return values（返回值）
//所有的函数都返回一个值。如果没有指定返回值，则 默认把语句 return null; 作为函数的最后一个语句执行

//Operators（操作符）
//   /	除号
//   ~/	除号，但是返回值为整数
//assert(5 ~/ 2 == 2);

//Type test operators（类型判定操作符）
//as	类型转换
//is	如果对象是指定的类型返回 True
//is!	如果对象是指定的类型返回 False
//只有当 obj 实现了 T 的接口， obj is T 才是 true。例如 obj is Object 总是 true。
//使用 as 操作符把对象转换为特定的类型。 一般情况下，你可以把它当做用 is 判定类型然后调用 所判定对象的函数的缩写形式
//if (emp is Person) { // Type check
//emp.firstName = 'Bob';
//}
//简化 (emp as Person).firstName = 'Bob';    如果 emp 是 null 或者不是 Person 类型， 则第一个示例使用 is 则不会执行条件里面的代码，而第二个情况使用 as 则会抛出一个异常

//Assignment operators（赋值操作符）
//使用 = 操作符来赋值。 但是还有一个 ??= 操作符用来指定 值为 null 的变量的值。
//a = value;   // 给 a 变量赋值
//b ??= value; // 如果 b 是 null，则赋值给 b；如果不是 null，则 b 的值保持不变

//复合赋值操作符 += 等可以 赋值
//对于 操作符 op:	a op= b	 效果等同   a = a op b

//Logical operators（逻辑操作符） ！||  &&

//Bitwise and shift operators（位和移位操作符）
//&	AND
//|	OR
//^	XOR
//~expr	Unary bitwise complement (0s become 1s; 1s become 0s)
//<<	Shift left
//>>	Shift right
// assert((value & ~bitmask) == 0x20);  // AND NOT

//Conditional expressions（条件表达式）
//Dart 有两个特殊的操作符可以用来替代 if-else 语句：
//condition ? expr1 : expr2  //如果 condition 是 true，执行 expr1 (并返回执行的结果)； 否则执行 expr2 并返回其结果。
//expr1 ?? expr2  //如果 expr1 是 non-null，返回其值； 否则执行 expr2 并返回其结果。

//Cascade notation (..)（级联操作符）
//级联操作符 (..) 可以在同一个对象上 连续调用多个函数以及访问成员变量。 使用级联操作符可以避免创建 临时变量， 并且写出来的代码看起来 更加流畅：
//严格来说， 两个点的级联语法不是一个操作符。 只是一个 Dart 特殊语法。
//querySelector('#button') // Get an object.
//..text = 'Confirm'   // Use its members.
//..classes.add('important')
//..onClick.listen((e) => window.alert('Confirmed!'));
//第一个方法 querySelector() 返回了一个 selector 对象。 后面的级联操作符都是调用这个对象的成员， 并忽略每个操作 所返回的值
//上面的代码和下面的代码功能一样：
//var button = querySelector('#button');
//button.text = 'Confirm';
//button.classes.add('important');
//button.onClick.listen((e) => window.alert('Confirmed!'));

//级联调用也可以嵌套：
//final addressBook = (new AddressBookBuilder()
//  ..name = 'jenny'
//  ..email = 'jenny@example.com'
//  ..phone = (new PhoneNumberBuilder()
//    ..number = '415-555-0100'
//    ..label = 'home')
//      .build())
//    .build();

//Other operators（其他操作符）
//()	使用方法	代表调用一个方法
//[]	访问 List	访问 list 中特定位置的元素
//    .	访问 Member	访问元素，例如 foo.bar 代表访问 foo 的 bar 成员

//    ?.	条件成员访问	和 . 类似，但是左边的操作对象不能为 null，例如 foo?.bar 如果 foo 为 null 则返回 null，否则返回 foo的bar 成员,可以避免当左边对象为 null 时候 抛出异常,访问类的属性

//Overridable operators（可覆写的操作符）
//可以覆写的操作符
//<	+	|	[]
//>	/	^	[]=
//<=	~/	&	~
//>=	*	<<	==
//–	%	>>
class Vector {
  final int x;
  final int y;
  const Vector(this.x, this.y);

  /// Overrides + (a + b).
  Vector operator +(Vector v) {
    return new Vector(x + v.x, y + v.y);
  }

  /// Overrides - (a - b).
  Vector operator -(Vector v) {
    return new Vector(x - v.x, y - v.y);
  }
}

//main() {
//  final v = new Vector(2, 3);
//  final w = new Vector(2, 2);
//
//  // v == (2, 3)
//  print(v.x == 2 && v.y == 3);
//
//  // v + w == (4, 5)
//  print((v + w).x == 4 && (v + w).y == 5);
//
//  // v - w == (0, 1)
//  print((v - w).x == 0 && (v - w).y == 1);
//}

//Control flow statements（流程控制语句）
//可以使用下面的语句来控制 Dart 代码的流程：
//if and else
//for loops
//while and do-while loops

//break and continue
//使用 break 来终止循环：
//while (true) {
//if (shutDownRequested()) break;
//processIncomingRequests();
//}
//使用 continue 来开始下一次循环：
//for (int i = 0; i < candidates.length; i++) {
//var candidate = candidates[i];
//if (candidate.yearsExperience < 5) {
//continue;
//}
//candidate.interview();
//}

//switch and case
//Dart 中的 Switch 语句使用 == 比较 integer、string、或者编译时常量。 比较的对象必须都是同一个类的实例（并且不是 其之类），class 必须没有覆写 == 操作符。 Enumerated types 非常适合 在 switch 语句中使用
//每个非空的 case 语句都必须有一个 break 语句。 另外还可以通过 continue、 throw 或 者 return 来结束非空 case 语句。
//在 Dart 中的空 case 语句中可以不要 break 语句：
//当没有 case 语句匹配的时候，可以使用 default 语句来匹配这种默认情况

//如果你需要实现这种继续到下一个 case 语句中继续执行，则可以 使用 continue 语句跳转到对应的标签（label）处继续执行：
//var command = 'CLOSED';
//switch (command) {
//case 'CLOSED':
//executeClosed();
//continue nowClosed;
//         // Continues executing at the nowClosed label.
//nowClosed:
//case 'NOW_CLOSED':
//       // Runs for both CLOSED and NOW_CLOSED.
//executeNowClosed();
//break;
//}
//每个 case 语句可以有局部变量，局部变量 只有在这个语句内可见

//assert  断言只在检查模式下运行有效，如果在生产模式 运行，则断言不会执行

//使用 try-catch 和 throw 还能影响控制流程的 跳转
//和 Java 不同的是，所有的 Dart 异常是非检查异常。 方法不一定声明了他们所抛出的异常， 并且你不要求捕获任何异常。
//Dart 提供了 Exception 和 Error 类型， 以及一些子类型。你还 可以定义自己的异常类型。但是， Dart 代码可以 抛出任何非 null 对象为异常，不仅仅是实现了 Exception 或者 Error 的对象
//Throw
//下面是抛出或者 扔出一个异常的示例：
//throw new FormatException('Expected at least 1 section');
//还可以抛出任意的对象：
//throw 'Out of llamas!';
//由于抛出异常是一个表达式，所以可以在 => 语句中使用，也可以在其他能使用表达式的地方抛出异常。
//distanceTo(Point other) =>
//    throw new UnimplementedError();

//Catch    函数 catch() 可以带有一个或者两个参数， 第一个参数为抛出的异常对象， 第二个为堆栈信息 (一个 StackTrace 对象)。
//捕获异常可以避免异常继续传递（你重新抛出rethrow异常除外）。 捕获异常给你一个处理 该异常的机会：
//try {
//breedMoreLlamas();
//} on OutOfLlamasException {
//buyMoreLlamas();
//}

//对于可以抛出多种类型异常的代码，你可以指定 多个捕获语句。每个语句分别对应一个异常类型， 如果捕获语句没有指定异常类型，则 该可以捕获任何异常类型：
//使用 rethrow 关键字可以 把捕获的异常给 重新抛出。
//try {
//breedMoreLlamas();
//} on OutOfLlamasException {
//      //A specific exception
//buyMoreLlamas();
//} on Exception catch (e) {
//      //Anything else that is an exception
//print('Unknown exception: $e');
//} catch (e,s) {
//    // No specified type, handles all
//print('Something really unknown: $e');
//rethrow; // Allow callers to see the exception.
//}

//Finally
//要确保某些代码执行，不管有没有出现异常都需要执行，可以使用 一个 finally 语句来实现。
// 如果没有 catch 语句来捕获异常， 则在执行完 finally 语句后， 异常被抛出了：
//try {
//breedMoreLlamas();
//} finally {
//    // Always clean up, even if an exception is thrown.
//cleanLlamaStalls();
//}

//Classes
//Dart 是一个面向对象编程语言，同时支持基于 mixin 的继承机制。 每个对象都是一个类的实例，所有的类都继承于 Object.。 基于 Mixin 的继承 意味着每个类（Object 除外） 都只有一个超类，一个类的代码可以在其他 多个类继承中重复使用。
//dart2后new和const可以省略,推荐英文网站
//使用 new 关键字和构造函数来创建新的对象。 构造函数名字可以为 ClassName 或者 ClassName.identifier。例如
//所有没有初始化的变量值都是 null。
//每个实例变量都会自动生成一个 getter 方法（隐含的）。 Non-final 实例变量还会自动生成一个 setter 方法

//Default constructors（默认构造函数）
//如果你没有定义构造函数，则会有个默认构造函数。 默认构造函数没有参数，并且会调用超类的 没有参数的构造函数
//Constructors aren’t inherited（构造函数不会继承）
//子类不会继承超类的构造函数。 子类如果没有定义构造函数，则只有一个默认构造函数 （没有名字没有参数）
//Named constructors（命名构造函数）
//使用命名构造函数可以为一个类实现多个构造函数， 或者使用命名构造函数来更清晰的表明你的意图：
//构造函数不能继承，所以超类的命名构造函数 也不会被继承。如果你希望 子类也有超类一样的命名构造函数， 你必须在子类中自己实现该构造函数
class Point {
  num x;
  num y;

  Point(this.x, this.y);

  // Named constructor
  Point.fromJson(Map json) {
    x = json['x'];
    y = json['y'];
  }
}

//Invoking a non-default superclass constructor（调用超类构造函数）
//默认情况下，子类的构造函数会自动调用超类的 无名无参数的默认构造函数。 超类的构造函数在子类构造函数体开始执行的位置调用。 如果提供了一个 initializer list（初始化参数列表） ，则初始化参数列表在超类构造函数执行之前执行。 下面是构造函数执行顺序：
//initializer list（初始化参数列表）
//superclass’s no-arg constructor（超类的无名构造函数）
//main class’s no-arg constructor（主类的无名构造函数）
//如果超类没有无名无参数构造函数， 则你需要手工的调用超类的其他构造函数。 在构造函数参数后使用冒号 (:) 可以调用 超类构造函数。
class Person {
  String firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  // Person does not have a default constructor;
  // you must call super.fromJson(data).
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

//main() {
//  var emp = new Employee.fromJson({});
//}
//由于超类构造函数的参数在构造函数执行之前执行，所以 参数可以是一个表达式或者 一个方法调用：
//class Employee extends Person {
//  Employee() : super.fromJson(findDefaultData());
//}

//Initializer list（初始化列表）
//在构造函数体执行之前除了可以调用超类构造函数之外，还可以 初始化实例参数。 使用逗号分隔初始化表达式
//初始化表达式等号右边的部分不能访问 this
//class Point {
//  num x;
//  num y;
//  Point(this.x, this.y);
//   Initializer list sets instance variables before
//   the constructor body runs.
//  Point.fromJson(Map jsonMap)
//      : x = jsonMap['x'],
//        y = jsonMap['y'] {
//    print('In Point.fromJson(): ($x, $y)');
//  }
//}
//初始化列表非常适合用来设置 final 变量的值
//import 'dart:math';
//class Point {
//  final num x;
//  final num y;
//  final num distanceFromOrigin;
//  Point(x, y)
//      : x = x,
//        y = y,
//        distanceFromOrigin = sqrt(x * x + y * y);
//}
//main() {
//  var p = new Point(2, 3);
//  print(p.distanceFromOrigin);
//}

//Redirecting constructors（重定向构造函数）
//有时候一个构造函数会调动类中的其他构造函数。 一个重定向构造函数是没有代码的，在构造函数声明后，使用 冒号调用其他构造函数。
//class Point {
//  num x;
//  num y;
//       // The main constructor for this class.
//  Point(this.x, this.y);
//         //Delegates to the main constructor.
//  Point.alongXAxis(num x) : this(x, 0);
//}

//Constant constructors（常量构造函数）
//如果你的类提供一个状态不变的对象，你可以把这些对象 定义为编译时常量。要实现这个功能，需要定义一个 const 构造函数， 并且声明所有类的变量为 final
class ImmutablePoint {
  final num x;
  final num y;

  const ImmutablePoint(this.x, this.y);

  static final ImmutablePoint origin = const ImmutablePoint(0, 0);
}

//Factory constructors（工厂方法构造函数）
//如果一个构造函数并不总是返回一个新的对象，则使用 factory 来定义 这个构造函数。例如，一个工厂构造函数 可能从缓存中获取一个实例并返回，或者 返回一个子类型的实例
//工厂构造函数无法访问 this。
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to the _ in front
  // of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final logger = new Logger._internal(name);
      _cache[name] = logger;
      return logger;
    }
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) {
      print(msg);
    }
  }
}

//使用 new 关键字来调用工厂构造函数。
void callFactory() {
  var logger = new Logger('UI');
  logger.log('Button clicked');
}

//Methods（函数）
//函数是类中定义的方法，是类对象的行为。
//Instance methods（实例函数）
//对象的实例函数可以访问 this
//import 'dart:math';
//class Point {
//  num x;
//  num y;
//  Point(this.x, this.y);
//
//  num distanceTo(Point other) {
//    var dx = x - other.x;
//    var dy = y - other.y;
//    return sqrt(dx * dx + dy * dy);
//  }
//}

//Getters and setters
//Getters 和 setters 是用来设置和访问对象属性的特殊 函数。每个实例变量都隐含的具有一个 getter， 如果变量不是 final 的则还有一个 setter。 你可以通过实行 getter 和 setter 来创建新的属性， 使用 get 和 set 关键字定义 getter 和 setter
//像 (++) 这种操作符不管是否定义 getter 都会正确的执行。 为了避免其他副作用， 操作符只调用 getter 一次，然后 把其值保存到一个临时变量中
class Rectangle {
  num left;
  num top;
  num width;
  num height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  num get right => left + width;

  set right(num value) => left = value - width;

  num get bottom => top + height;

  set bottom(num value) => top = value - height;
}
//main() {
//  var rect = new Rectangle(3, 4, 20, 15);
//  assert(rect.left == 3);
//  rect.right = 12;
//  assert(rect.left == -8);
//}

//Abstract methods（抽象函数）
//实例函数、 getter、和 setter 函数可以为抽象函数， 抽象函数是只定义函数接口但是没有实现的函数，由子类来 实现该函数。如果用分号来替代函数体则这个函数就是抽象函数
abstract class Doer {
  // ...Define instance variables and methods...
  void doSomething(); // Define an abstract method.
}

class EffectiveDoer extends Doer {
  void doSomething() {
    // ...Provide an implementation, so the method is not abstract here...
  }
}

//Abstract classes（抽象类）
//使用 abstract 修饰符定义一个 抽象类—一个不能被实例化的类。 抽象类通常用来定义接口， 以及部分实现。如果你希望你的抽象类 是可示例化的，则定义一个 工厂 构造函数。
//抽象类通常具有 抽象函数。
// This class is declared abstract and thus
// can't be instantiated.
abstract class AbstractContainer {
  // ...Define constructors, fields, methods...

  void updateChildren(); // Abstract method.
}

//下面的类不是抽象的，但是定义了一个抽象函数，这样 的类是可以被实例化的： -----> dart2中抽象方法只能定义在抽象类中
abstract class SpecializedContainer extends AbstractContainer {
  // ...Define more constructors, fields, methods...

  void updateChildren() {
    // ...Implement updateChildren()...
  }

  // Abstract method causes a warning but
  // doesn't prevent instantiation.     会产生警告，但可以实例化
  void doSomething();
}

//Implicit interfaces（隐式接口）
//每个类都隐式的定义了一个包含所有实例成员的接口， 并且这个类实现了这个接口。如果你想 创建类 A 来支持 类 B 的 api，而不想继承 B 的实现， 则类 A 应该实现 B 的接口。
//一个类可以通过 implements 关键字来实现一个或者多个接口， 并实现每个接口定义的 API
// A person. The implicit interface contains greet().
class Personn {
  // In the interface, but visible only in this library.
  final _name;

  // Not in the interface, since this is a constructor.
  Personn(this._name);

  // In the interface.
  String greet(who) => 'Hello, $who. I am $_name.';
}

// An implementation of the Person interface.
class Imposter implements Personn {
  // We have to define this, but we don't use it.
  final _name = "";

  String greet(who) => 'Hi $who. Do you know who I am?';
}

greetBob(Personn person) => person.greet('bob');

//main() {
//  print(greetBob(new Personn('kathy')));
//  print(greetBob(new Imposter()));
//}
//下面是实现多个接口 的示例：
//class Point implements Comparable, Location {

//}

//Extending a class（扩展类）
//使用 extends 定义子类， supper 引用 超类：
//@override 注解来 表明你的函数是想覆写超类的一个函数
//@proxy 注解来避免警告信息

//Enumerated types（枚举类型）
//枚举类型通常称之为 enumerations 或者 enums， 是一种特殊的类，用来表现一个固定 数目的常量。
//枚举类型具有如下的限制：
//无法继承枚举类型、无法使用 mix in、无法实现一个枚举类型
//无法显示的初始化一个枚举类型
//Using enums
//使用 enum 关键字来定义枚举类型：
enum Color { red, green, blue }

//Adding features to a class: mixins（为类添加新的功能）
//Mixins 是一种在多类继承中重用 一个类代码的方法。
//使用 with 关键字后面为一个或者多个 mixin 名字来使用 mixin
//class Musician extends Performer with Musical {
// ...
//}
//class Maestro extends Person with Musical, Aggressive, Demented {
//  Maestro(String maestroName) {
//    name = maestroName;
//    canConduct = true;
//  }
//}
//定义一个类继承 Object，该类没有构造函数， 不能调用 super ，则该类就是一个 mixin。例如：

abstract class Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}

//Class variables and methods（类变量和函数）
//使用 static 关键字来实现类级别的变量和函数。
//Static variables（静态变量）
//静态变量对于类级别的状态是 非常有用的
//静态变量在第一次使用的时候才被初始化。
class Colorr {
  static const red = const Colorr('red'); // A constant static variable.
  final String name; // An instance variable.
  const Colorr(this.name); // A constant constructor.
}

//main() {
//  assert(Color.red.name == 'red');
//}

//Static methods（静态函数）
//静态函数不再类实例上执行， 所以无法访问 this
//对于通用的或者经常使用的静态函数，考虑 使用顶级方法而不是静态函数。
//静态函数还可以当做编译时常量使用。例如， 你可以把静态函数当做常量构造函数的参数来使用
//import 'dart:math';
//
//class Point {
//  num x;
//  num y;
//  Point(this.x, this.y);
//
//  static num distanceBetween(Point a, Point b) {
//    var dx = a.x - b.x;
//    var dy = a.y - b.y;
//    return sqrt(dx * dx + dy * dy);
//  }
//}
//
//main() {
//  var a = new Point(2, 2);
//  var b = new Point(4, 4);
//  var distance = Point.distanceBetween(a, b);
//  assert(distance < 2.9 && distance > 2.8);
//}

//Generics（泛型）
//如果你查看 List 类型的 API 文档， 则可以看到 实际的类型定义为 List<E>。 这个 <…> 声明 list 是一个 泛型 (或者 参数化) 类型。 通常情况下，使用一个字母来代表类型参数， 例如 E, T, S, K, 和 V 等。
//Why use generics?（为何使用泛型）
//在 Dart 中类型是可选的，你可以选择不用泛型。 有些情况下你可能想使用类型来表明你的意图， 不管是使用泛型还是 具体类型
//Using collection literals（使用集合字面量）
//List 和 map 字面量也是可以参数化的。 参数化定义 list 需要在中括号之前 添加 <type> ， 定义 map 需要在大括号之前 添加 <keyType, valueType>。 如果你需要更加安全的类型检查，则可以使用 参数化定义
var names = <String>['Seth', 'Kathy', 'Lars'];
var pages = <String, String>{
  'index.html': 'Homepage',
  'robots.txt': 'Hints for web robots',
  'humans.txt': 'We are people, not machines'
};
//Using parameterized types with constructors（在构造函数中使用泛型）
//在调用构造函数的时候， 在类名字后面使用尖括号(<...>)来指定 泛型类型。例如：

//var names = new List<String>();
//names.addAll(['Seth', 'Kathy', 'Lars']);
//var nameSet = new Set<String>.from(names);
//   //下面代码创建了一个 key 为 integer， value 为 View 类型 的 map：
//var views = new Map<int, View>();

//Generic collections and the types they contain
//Dart 的泛型类型是固化的，在运行时有也 可以判断具体的类型。例如在运行时（甚至是成产模式） 也可以检测集合里面的对象类型：
//var names = new List<String>();
//names.addAll(['Seth', 'Kathy', 'Lars']);
//print(names is List<String>); // true
//注意 is 表达式只是判断集合的类型，而不是集合里面具体对象的类型。 在成产模式，List<String> 变量可以包含 非字符串类型对象。对于这种情况， 你可以选择分别判断每个对象的类型或者 处理类型转换异常 (参考 Exceptions)。
//注意： Java 中的泛型信息是编译时的，泛型信息在运行时是不纯在的。 在 Java 中你可以测试一个对象是否为 List， 但是你无法测试一个对象是否为 List<String>。

//Restricting the parameterized type（限制泛型类型）
//当使用泛型类型的时候，你 可能想限制泛型的具体类型。
// T must be SomeBaseClass or one of its descendants.
//class Foo<T extends SomeBaseClass> {...}
//
//class Extender extends SomeBaseClass {...}
//
//void main() {
//   It's OK to use SomeBaseClass or any of its subclasses inside <>.
//  var someBaseClassFoo = new Foo<SomeBaseClass>();
//  var extenderFoo = new Foo<Extender>();
//
//   It's also OK to use no <> at all.
//  var foo = new Foo();
//
// Specifying any non-SomeBaseClass type results in a warning and, in
// checked mode, a runtime error.
// var objectFoo = new Foo<Object>();
//}

//Using generic methods（使用泛型函数）
//一开始，泛型只能在 Dart 类中使用。 新的语法也支持在函数和方法上使用泛型了。

T first<T>(List<T> ts) {
  // ...Do some initial work or error checking, then...
  T tmp;
  tmp ??= ts[0];
  // ...Do some additional checking or processing...
  return tmp;
}
//这里的 first (<T>) 泛型可以在如下地方使用 参数 T ：
//函数的返回值类型 (T).
//参数的类型 (List<T>).
//局部变量的类型 (T tmp).

//Libraries and visibility（库和可见性）
//使用 import 和 library 指令可以帮助你创建 模块化的可分享的代码。库不仅仅提供 API， 还是一个私有单元：以下划线 (_) 开头的标识符只有在库 内部可见。
// 每个 Dart app 都是一个库， 即使没有使用 library 命令也是一个库
//Using libraries（使用库）
//使用 import 来指定一个库如何使用另外 一个库
//import 必须参数为库 的 URI。 对于内置的库，URI 使用特殊的 dart: scheme。 对于其他的库，你可以使用文件系统路径或者 package: scheme。 package: scheme 指定的库通过包管理器来提供， 例如 pub 工具。
//import 'dart:io';
//import 'package:mylib/mylib.dart';
//import 'package:utils/utils.dart';

//Specifying a library prefix（指定库前缀）
//如果你导入的两个库具有冲突的标识符， 则你可以使用库的前缀来区分。 例如，如果 library1 和 library2 都有一个名字为 Element 的类
//import 'package:lib1/lib1.dart';
//import 'package:lib2/lib2.dart' as lib2;

//Importing only part of a library（导入库的一部分）
//如果你只使用库的一部分功能，则可以选择需要导入的 内容
// Import only foo.
//import 'package:lib1/lib1.dart' show foo;
//Import all names EXCEPT foo.
//import 'package:lib2/lib2.dart' hide foo;
//Dart允许我们把一个库拆分成一个或者多个较小的part组件。或者我们想让某一些库共享它们的私有对象的时候，我们需要使用part
//part data.dart
//Part与import有什么区别
//可见性：
//如果说在A库中import了B库，A库对B库是不可见的，也就是说B库是无法知道A库的存在的。而part的作用是将一个库拆分成较小的组件。两个或多个part共同构成了一个库，它们彼此之间是知道互相的存在的。
//作用域：import不会完全共享作用域，而part之间是完全共享的。如果说在A库中import了B库，B库import了C库，A库是没有办法直接使用C库的对象的。而B,C若是A的part，那么三者共享所有对象。并且包含所有导入。

//Lazily loading a library（延迟载入库）
//Deferred loading (也称之为 lazy loading) 可以让应用在需要的时候再 加载库。 下面是一些使用延迟加载库的场景：
//减少 APP 的启动时间。
//执行 A/B 测试，例如 尝试各种算法的 不同实现。
//加载很少使用的功能，例如可选的屏幕和对话框。
//要延迟加载一个库，需要先使用 deferred as 来 导入：
//import 'package:deferred/hello.dart' deferred as hello;
//当需要使用的时候，使用库标识符调用 loadLibrary() 函数来加载库：
//greet() async {
//  await hello.loadLibrary();
//  hello.printGreeting();
//}

//在一个库上你可以多次调用 loadLibrary() 函数。 但是该库只是载入一次。
//使用延迟加载库的时候，请注意一下问题：
//延迟加载库的常量在导入的时候是不可用的。 只有当库加载完毕的时候，库中常量才可以使用。
//在导入文件的时候无法使用延迟库中的类型。 如果你需要使用类型，则考虑把接口类型移动到另外一个库中， 让两个库都分别导入这个接口库。
//Dart 隐含的把 loadLibrary() 函数导入到使用 deferred as 的命名空间 中。 loadLibrary() 方法返回一个 Future
//

//Asynchrony support（异步支持）
//Dart 有一些语言特性来支持 异步编程。 最常见的特性是 async 方法和 await 表达式。
//Dart 库中有很多返回 Future 或者 Stream 对象的方法。 这些方法是 异步的： 这些函数在设置完基本的操作 后就返回了， 而无需等待操作执行完成。 例如读取一个文件，在打开文件后就返回了。

//有两种方式可以使用 Future 对象中的 数据：
//使用 async 和 await
//使用 Future API

//同样，从 Stream 中获取数据也有两种 方式：
//使用 async 和一个 异步 for 循环 (await for)
//使用 Stream API

//要使用 await，其方法必须带有 async 关键字：
//Declaring async functions（声明异步方法）//一个 async 方法 是函数体被标记为 async 的方法。 虽然异步方法的执行可能需要一定时间，但是 异步方法立刻返回 - 在方法体还没执行之前就返回
////在 await expression 中， expression 的返回值通常是一个 Future； 如果返回的值不是 Future，则 Dart 会自动把该值放到 Future 中返回。 Future 对象代表返回一个对象的承诺（promise）。 await expression 执行的结果为这个返回的对象。 await expression 会阻塞住，直到需要的对象返回为止
//await关键字必须在async函数内部使用
//使用 async 和 await 的代码是异步的， 但是看起来有点像同步代码。 例如，下面是一些使用 await 来 等待异步方法返回的示例：
//await lookUpVersion()
//checkVersion() async {
//  var version = await lookUpVersion();
//  if (version == expectedVersion) {
//     Do something.
//  } else {
//     //Do something else.
//  }
//}
//

//Future最主要的功能就是提供了链式调用 链式调用解决两大问题：明确代码执行的依赖关系和实现异常捕获
//funA(){
//  ...set an important variable...    //设置变量
//}
//
//funB(){
//  ...use the important variable...   //使用变量
//}
//main(){
//  new Future.then(funA()).then(funB());   // 明确表现出了后者依赖前者设置的变量值
//
//  new Future.then(funA()).then((_) {new Future(funB())});    //还可以这样用
//
// 链式调用，捕获异常
//  new Future.then(funA(),onError: (e) { handleError(e); }).then(funB(),onError: (e) { handleError(e); })
//}
//
//延时
//new Future.delayed(Duration(seconds: 3), (){});

//Comments（注释）
//Dart 支持单行注释、多行注释和 文档注释
//Single-line comments
//单行注释以 // 开始。 // 后面的一行内容 为 Dart 代码注释
//Multi-line comments
//多行注释以 /* 开始， */ 结尾。 多行注释 可以 嵌套
//Documentation comments
//文档注释可以使用 /// 开始， 也可以使用 /** 开始 并以 */ 结束。 推荐使用///
//在文档注释内， Dart 编译器忽略除了中括号以外的内容。 使用中括号可以引用 classes、 methods、 fields、 top-level variables、 functions、 和 parameters。中括号里面的名字使用 当前注释出现地方的语法范围查找对应的成员。
/// A domesticated South American camelid (Lama glama).
///
/// Andean cultures have used llamas as meat and pack
/// animals since pre-Hispanic times.
class Llama {
  String name;

  /// Feeds your llama [Food].
  ///
  /// The typical llama eats one bale of hay per week.
  void feed(Rectangle food) {
    // ...
  }

  /// Exercises your llama with an [activity] for
  /// [timeLimit] minutes.
  void exercise(Color activity, int timeLimit) {
    // ...
  }
}

//类型注解
//对于公有 API，最好提供类型注解。
//类型注解是非常重要的文档，它说明了相应的库应当如何使用。为参数以及公有方法的返回类型注解有利于使用者了解 API 需要什么参数以及它能提供什么功能。
//但是，如果有个 API 可以接收任何参数，或者是 Dart 中无法表示的值，那么该 APi 可以不用添加注解
//对于库内部的代码（即便是私有的，或者是嵌套的函数），请再你认为有帮助的地方添加注解，但是不要认为你必须提供这些注解。
install(id, destPath) {
  // bad
  // ...
}
//在上面的代码中，我们就不清楚 id 到底是什么。字符串？那么 destPath 又是什么呢？字符串还是文件对象？这个函数是同步的还是异步的？
//Future<bool> install(PackageId id, String destPath) {
//  // good
//  // ...
//}
//其他查看EffectiveDart 对于类型注解的推荐

//Callable classes（可调用的类）
//如果 Dart 类实现了 call() 函数则 可以当做方法来调用
class WannabeFunction {
  call(String a, String b, String c) => '$a $b $c!';
}
//main() {
//  var wf = new WannabeFunction();
//  var out = wf("Hi","there,","gang");
//  print('$out');
//}

//Typedefs
//使用 typedef, 或者 function-type alias 来为方法类型命名， 然后可以使用命名的方法。 当把方法类型赋值给一个变量的时候，typedef 保留类型信息
//没有使用typedef
class SortedCollection {
  Function compare;

  SortedCollection(int f(Object a, Object b)) {
    compare = f;
  }
}

// Initial, broken implementation.
int sort(Object a, Object b) => 0;
//main() {
//  SortedCollection coll = new SortedCollection(sort);
//
//  // 我们只知道 compare 是一个 Function 类型，
//  // 但是不知道具体是何种 Function 类型？
//  assert(coll.compare is Function);
//}

//当把 f 赋值给 compare 的时候， 类型信息丢失了。 f 的类型是 (Object, Object) → int (这里 → 代表返回值类型)， 当然该类型是一个 Function。
// 如果我们使用显式的名字并保留类型信息， 开发者和工具可以使用 这些信息：
//使用typdeof
typedef int Compare(Object a, Object b);
//class SortedCollection {
//  Compare compare;
//
//  SortedCollection(this.compare);
//}
//// Initial, broken implementation.
//int sort(Object a, Object b) => 0;
//main() {
//  SortedCollection coll = new SortedCollection(sort);
//  assert(coll.compare is Function);
//  assert(coll.compare is Compare);
//}
