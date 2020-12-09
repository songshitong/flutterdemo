///extension语法  引入该属性需要同时引入extension所在的文件  MInt.of("2").seconds();
//<extensionDeclaration> ::=
//<metadata> `extension’ <identifier>? <typeParameters>? `on’ <type> `{‘
//(<metadata> <classMemberDefinition>)*
//`}’
extension MInt on int {
  static int of(String value) {
    return int.fromEnvironment(value);
  }

  Duration seconds() => Duration(seconds: this);
}

//扩展某个类
//extension WidgetPadding on Widget {
//  Widget paddingAll(double padding) =>
//      Padding(padding: EdgeInsets.all(padding), child: this);
//}

//泛型extension
//
// extension<F, S, R> on R Function(F, S) {
//   R Function(S) curry(F first) {
//     return (S second) => this(first, second);
//   }
// }

//  extension on Widget implements MapDrawable {…}

enum St { li, zhao }

extension Student on St {
  static getStudentFromIndex(int index) {
    return St.values[index];
  }
}

void main() {
  final duration = 20.seconds();
  print("duration $duration");
  print(Student.getStudentFromIndex(0).toString());
}
