import 'dart:async';
//typedef 可以看作function的别名，当函数类型分配给变量时，typedef会保留类型信息
//定义function的检查类型   T被编译为dynamic？？
// typedef Compare<T> = int Function(T a, T b);

typedef Compare<T> = Null Function(T a, T b);
typedef CompareA<T> = void Function(T a, T b);

typedef TestFunction = dynamic Function(String param);
//(T,action)=>T  函数式
typedef ApplyLikeEnhancer = TestFunction Function(TestFunction functor);

class LocaleErrors {}

///声明一个返回值为LocaleErrors的function
typedef GetLocaleErrors = LocaleErrors Function(String key);

///顶级函数 一般初始化一次
///代码简化  此时i18nLabels==getLocaleLabels   CustomLocalizations.of(Constant().rootContext)获取的对象只执行了一次
//GetLocaleErrors i18nLabels =
//    CustomLocalizations.of(Constant().rootContext).getLocaleLabels;

///此时 此时i18nLabels==getLocaleLabels   CustomLocalizations.of(Constant().rootContext)获取的对象每次都执行一次
//GetLocaleLabels i18nLabels = (String key) {
//  return CustomLocalizations.of(Constant().rootContext).getLocaleLabels(key);
//};

ApplyLikeEnhancer delay(int millis) {
  return (dynamic Function(String) functor) {
    return (String positionalArguments) async {
      await Future<void>.delayed(Duration(milliseconds: millis));
      return functor(positionalArguments);
    };
  };
}

class SortedCollection {
  Function? compare;

  SortedCollection(f(int a, int b)) {
    compare = f;
  }
}

///顶层函数(Function)不与类绑定的方法  静态函数    类中为实例函数(method 方法)
///顶级变量  dart支持顶级变量  在一个文件中声明顶级变量(在方法和类外面)，在另一个文件中使用
// Initial, broken implementation.
int sort(int a, int b) {
  print("a + b 结果是");
  print(a + b);
  return a + b;
}

void main(List<String> args) async {
  //main 方法可以范型为String的list
  //运行dart 文件    运行命令  dart 文件名  ["arg0","arg1"]
  print("main args is $args");

  ///fuction 作为参数
//  var sortedCollction = new SortedCollection(sort);
//  sortedCollction.compare(1, 2);

  ///可选命名参数
  enableFlags1("flag0");
  enableFlags("flag1");
  enableFlags("flag2", bold: "bold ");

  ///可选位置参数
//  say("from", "msg");
//  say("from2", "msg2", "device2");

  ///匿名函数
  var list = <String>[];
  list.add("tom");
  list.add("jack");
  list.add("Rose");
  list.forEach((e) {
    print("e is " + e.toString());
  });

  ///forEach 定义了一个参数为e的匿名函数
  ///

//  嵌套方法/局部方法
  //在main中定义函数
  launch() {
    print('this is launch');
  }

  var launchB = () {
    print("this ia launchB");
  };
  bool flag = true;
  if (flag) {
    print("flag is  $flag");
    launchB();
  } else {
    print("flag is  $flag");
    launchB();
  }

  print(await delay(5));
  //js 概念
//  闭包就是能够读取其他函数内部变量的函数。   直接读取函数内部变量不可读，通过增加一层函数返回读取
//  它的最大用处有两个  一个是前面提到的可以读取函数内部的变量，另一个就是让这些变量的值始终保持在内存中。变量的执行上下文发生变化，

//  Operator	Name	Meaning
//    ()	Function application	Represents a function call
  //()是function的返回调用
  ///函数
  print("getA ${getA}");

  ///getA 是函数    getA Closure: () => Future<String> from Function 'getA': static.
  ///getA() 是得到函数的返回
  print("getA() ${await getA()}");
  () {
    print("自执行函数");
  }();

  //将function作为参数，
  TestBuilder((str) {
    return "this is $str";
  });

  TestBuilder tb = TestBuilder(realBuild);
  print("测试call ${tb.inintCall()}");

  // TestBuilder((str) {}, subscribe: ((void Function() fc) {
  //   if (null != fc) {
  //     _listeners.add(fc);
  //   }
  // }));

  print("ApplyLikeEnhancer $ApplyLikeEnhancer");

//  function  dart/core/function
  //解释
//  The base class for all function types.
//  *
//  * A function value, or an instance of a class with a "call" method, is a
//  * subtype of a function type, and as such, a subtype of [Function].

//call 运行
//   它是怎样运行的？
//   当对x(a1, …, an)求值的时候，在支持相应参数的情况下，如果它是一个标准的函数，它会以正常的方式被调用。如果并不是标准函数，则会调用call()。
//   否则，noSuchMethod()被调用。noSuchMethod()的默认实现会检查该方法是否是因为企图使用call()而被调用，
//   如果是这样的问题，建议使用闭包，以获取有用的错误信息

// Create a function that adds 2.     add2 现在是个function  (i)=>2+i;
  var add2 = makeAdder(2);
  // Create a function that adds 4.   add4 现在是个function  (i)=>4+i;
  var add4 = makeAdder(4);
  //调用函数
  print(add2(3));
  print(add4(3));

  ///Function.apply  通过制定的args动态的调用function
  Function a = (int b) => b + 1;
  print("Function.apply result ${Function.apply(a, [1])}");

  ///箭头函数
  var functionArrow = () => {"aa": "aa", "bb": "bb"};
  print("functionArrow $functionArrow \nfunctionArrow call ${functionArrow()}");

  var functionArrow1 = () => ({"aa": "aa", "bb": "bb"});
  print(
      "functionArrow1 $functionArrow1 \nfunctionArrow1 call ${functionArrow1()}");

  ///动态返回函数 返回一个函数，函数的具体逻辑逻辑依赖于外部参数，使用与参数为函数但其实现逻辑需要动态改变的情况
  var validateMaxLength =
      (maxLength, name) => (rule, value, Function callback) {
            if (null != value) {
              if (value.length > maxLength)
                callback("error");
              else
                callback(name);
            } else
              callback();
          };
  print(
      "validateMaxLength $validateMaxLength \nvalidateMaxLength call ${validateMaxLength(10, "success")}");
}

/// Returns a function that adds [addBy] to the
/// function's argument.
Function makeAdder(num addBy) {
  return (num i) => addBy + i;
}

Future<String> getA() async {
  return "a";
}

String realBuild(String str) {
  return "realBuild str is $str";
}

//将void function 作为参数
final List<void Function()> _listeners = <void Function()>[];
typedef Subscribe = void Function() Function(void Function() callback);

typedef StringBuilder = String Function(String str);

class TestBuilder {
  StringBuilder sb;
  Subscribe? subscribe;
  TestBuilder(this.sb, {this.subscribe});

  inintCall() {
    //function可以用call调用自己
    return sb.call("测试call");
  }
}

//就版本代码可能需要使用一个冒号 (:) 而不是 = 来设置参数默认值
//不推荐使用
enableFlags1(String flag, {bold: String, hidden: String}) {
  print("enableFlags1 flag " +
      flag +
      " bold $bold runtimeType ${bold.runtimeType} " +
      " hidden $hidden runtimeType  ${hidden.runtimeType}");
}

enableFlags(String flag, {String? bold, bool? hidden}) {
  print("flag " +
      flag +
      " bold " +
      bold.toString() +
      " hidden " +
      hidden.toString());
  print("flag " +
      flag +
      " bold $bold runtimeType ${bold.runtimeType} " +
      " hidden $hidden runtimeType  ${hidden.runtimeType}");
}

say(String from, String msg, [String? device]) {
  print("from " + from + " msg " + msg);

  ///device 不存在的情况下，无法输出
  if (null != device) {
    print(" device " + device);
  }
}

//协变参数covariant   子类可以用更严格的所需类型覆盖此参数    Dart强模式不允许非静态安全的，去掉covariant报错
class Widget {
  void addChild(covariant Widget widget) {}
}

class RadioButton extends Widget {
  void select() {}
}

class RadioGroup extends Widget {
  void addChild(RadioButton button) {}
}

//协变修饰符也可用于可变字段。这样做对应于将隐式生成的该字段的setter中的参数
class Widget1 {
  covariant Widget? child;
}

//这是语法糖
class Widget2 {
  Widget? _child;
  Widget? get child => _child;
  set child(covariant Widget? value) {
    _child = value;
  }
}

// 与Mirror和noSuchMethod()进行交互，Function.apply的动态调用
// noSuchMethod 覆写，当方法找不到时，进行调用转发
class NoMethodClass {
  noSuchMethod(Invocation invocation) => invocation.memberName == #foo
      ? Function.apply(
          say, invocation.positionalArguments, invocation.namedArguments)
      : super.noSuchMethod(invocation);
}
