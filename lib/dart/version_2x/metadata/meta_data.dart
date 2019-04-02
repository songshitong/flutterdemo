library todo;

//注解使用@+编译时常量(@deprecated)或常量构造器(@Deprecated(""))
//@deprecated     const Deprecated deprecated = const Deprecated("next release");
//定义注解 类+常量构造器
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}

@deprecated
class TestTodo {
  @Todo("pritTest", "this is printTest")
  void printTest() {
    print("this is printTest");
  }
}
