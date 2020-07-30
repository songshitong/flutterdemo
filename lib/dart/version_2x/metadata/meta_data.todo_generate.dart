// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: TodoTopGenerate
// **************************************************************************

//source:
library todo;

//注解使用@+编译时常量(@deprecated)或常量构造器(@Deprecated(""))
//@deprecated     const Deprecated deprecated = const Deprecated("next release");
//定义注解 类+常量构造器
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}

@Todo("TestTodo", "this is TestTodo")
@deprecated
// Code for TestTodo ClassElementImpl who: TestTodo what: this is TestTodo
class TestTodo {
  @Todo("TestTodo", "this is printTest")
  void printTest() {
    print("this is printTest");
  }
}

@Todo("顶层函数", "this is 顶层函数 printTest")
void printTopTest() {
  print("this is printTest");
}
