class ContentA {}

class ContentB extends ContentA {}

abstract class People {
  sayHello() {
    print(" people hello");
  }

  ContentA? getContent();
}

///继承
class Student extends People {
  printHello() {
    sayHello();
    print(" student hello ");
  }

  Student getParent() {
    return StudentA();
  }

  @override
  ContentB getContent() {
    return ContentB();
  }
}

class StudentA extends Student {
  //继承只继承父类的属性，不在向上查找
  @override
  ContentB getContent() {
    return ContentB();
  }
}

///实现  类实现了一个默认接口
class Robot implements People {
  @override
  sayHello() {
    print("robot hello ");
    return null;
  }

//  StudentA getA() {
////    父类不能替代子类 强转也不行
//    return Student() as StudentA;
//  }

  @override
  ContentA? getContent() {
    // TODO: implement getContent
    return null;
  }
}

void main() {
//  var student = new Student();
//  student.printHello();

  var bobot = Robot();
  bobot.sayHello();

  ///多个mixin
  Women women = Women();
  women.log();

  Men men = Men();
  men.log();

//  mixins的类型  women is A true        women is B true
  print("women is A ${women is A}  women is B ${women is B}");

  ///如果一个对象是不会改变的，你可以讲这些对象创建为编译时常量。定义cost构造函数，而且要确保所有的常量都是final的
  var robot1 = const ImmutablePoint(1, 1);

  //
//  var student = Robot().getA();
//  print("sudent $student");

  //子类可以替代父类
  var studentChild = Student().getParent();
  print("studentChild $studentChild");
}

class ImmutablePoint {
  static final ImmutablePoint origin = const ImmutablePoint(0, 0);

  final num x, y;

  const ImmutablePoint(this.x, this.y);
}

//Mixin是面向对象程序设计语言中的类，提供了方法的实现。其他类可以访问mixin类的方法而不必成为其子类。
//[1]Mixin有时被称作"included"而不是"inherited"。mixin为使用它的class提供额外的功能，但自身却不单独使用（不能单独生成实例对象，属于抽象类）
//。因为有以上限制，Mixin类通常作为功能模块使用，在需要该功能时“混入”，而且不会使类的关系变得复杂。使用者与Mixin不是“is-a”的关系，而是“-able”关系
//Mixin有利于代码复用[2]又避免了多继承的复杂。[3][4]使用Mixin享有单一继承的单纯性和多重继承的共有性。
//接口与mixin相同的地方是都可以多继承，不同的地方在于 mixin 是带实现的。Mixin也可以看作是带实现的interface。这种设计模式实现了依赖反转原则

///使用mixins的关键字with
///mixins类只能继承自object
///mixins类不能有构造函数
///一个类可以mixins多个mixins类
///可以mixins多个类，不破坏Flutter的单继承, 多个类中有同样的方法，生效的是最后一个，可以理解为逐层实现最上层的混入
///mixins的类型就是其超类的子类型

class A {
  log() {
    print("a");
  }
}

class B {
  log() {
    print("b");
  }
}

class Women with A, B {
  @override
  log() {
    super.log();
    print("women");
  }
}

class Men with B, A {
  @override
  log() {
    super.log();
    print("men");
  }
}

//class B3 extends C with A,A1{
//
//}
///可以分解为
///class CA = C with A;
///class CAA1 = CA with A1;
///
///class B3 extends CAA1{
//
//}

///mixin 关键字   为了让mixin想传统类一样使用,使用mixin替代class
mixin Musical {
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

//mixins X on A  声明只有特定的类型可以使用mixin , 要mixins X的话，得先接口实现或者继承A。这里A可以是类，也可以是接口
//mixin 使用实现和继承在前，with在后     mixin X 也可以实现接口AA的方法？？
class AA {
  void a() {
    print("a");
  }
}

mixin X on AA {
  void x() {
    print("x");
  }

  void a() {}
}

class mixinsX extends AA with X {
  @override
  void x() {}
  @override
  void a() {}
}

class implA implements AA {
  @override
  void a() {}
}

class mixinsX2 extends implA with X {}

//Use the factory keyword when implementing a constructor that doesn’t always create a new instance of its class.
//a factory constructor might return an instance from a cache, or it might return an instance of a subtype.
// factory 可能从缓存返回实例，也可能返回一个子类
class Factory {
  factory Factory.icon() = _Phone;

  Factory();
}

class _Phone extends Factory {}
