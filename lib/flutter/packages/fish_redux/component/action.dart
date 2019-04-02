import 'package:fish_redux/fish_redux.dart';

enum ContainerAction { append, delete }

class ContainerActionCreator {
  static Action onEditAction(String text) {
    return Action(ContainerAction.append, payload: text);
  }

  static Action onDeleteAction(String text) {
    return Action(ContainerAction.delete, payload: text);
  }
}
