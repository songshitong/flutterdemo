void main() {
  //判断两个对象引用是否一致
  identical(1, 2);

  //返回hashcode 如果hashcode被重写，仍然返回没被重写前的hashcode
  identityHashCode(1);

  TestHashCode testHashCode = TestHashCode();
  print("beforeCode ${testHashCode.beforeCode} hashCode ${testHashCode.hashCode}");
//  hashCode的get方法不能调用hashCode 此时hansCode还没获得，此时调用报错stackoverflow，递归调用get方法
  print("identityHashCode ${identityHashCode(testHashCode)}");
}

class TestHashCode {
  int beforeCode;
  String _name = "TestHashCode";
  @override
  int get hashCode {
    beforeCode = _name.hashCode;
    return _name.hashCode;
  }
}
