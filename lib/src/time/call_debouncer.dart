import 'package:simplify_lib/src/time/call_delayed.dart';

//Call handler after n seconds of no activity
class VoidDebouncer {

  final double delay;
  final Function action;
  
  VoidDebouncer(this.delay, this.action);

  void _execute() => action();
  void call()=> DelayedCall.once(delay, _execute);
}

class OneDebouncer<T> {

  final double delay;
  final void Function(T) action;
  
  T? _lastValue; 

  OneDebouncer(this.delay, this.action);

  void _execute() => action(_lastValue as T);
  
  void call(T value) {
    _lastValue = value; 
    DelayedCall.once(delay, _execute);
  }
}

class TwoDebouncer<T1, T2> {

  final double delay;
  final void Function(T1, T2) action;
  
  T1? _lastValue1; 
  T2? _lastValue2;

  TwoDebouncer(this.delay, this.action);

  void _execute() => action(_lastValue1 as T1, _lastValue2 as T2);
  
  void call(T1 value1, T2 value2) {
    _lastValue1 = value1;
    _lastValue2 = value2;
    DelayedCall.once(delay, _execute);
  }
}