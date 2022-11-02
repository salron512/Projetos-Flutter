import 'package:mobx/mobx.dart';
part 'Counter.g.dart';

class Counter = _Counter with _$Counter;

abstract class _Counter with Store {
 

  @observable
  int index = 0;

  @action
  void increment() {
    index++;
  }
}
