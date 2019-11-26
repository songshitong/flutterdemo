///extension语法
//<extensionDeclaration> ::=
//<metadata> `extension’ <identifier>? <typeParameters>? `on’ <type> `{‘
//(<metadata> <classMemberDefinition>)*
//`}’
extension on int {
  Duration seconds() => Duration(seconds: this);
}

//扩展某个类
//extension WidgetPadding on Widget {
//  Widget paddingAll(double padding) =>
//      Padding(padding: EdgeInsets.all(padding), child: this);
//}

//泛型extension
//
extension<F, S, R> on R Function(F, S) {
  R Function(S) curry(F first) {
    return (S second) => this(first, second);
  }
}

//  extension on Widget implements MapDrawable {…}

void main() {
  final duration = 20.seconds();
  print("duration $duration");
}
