import 'package:simplify_lib/src/time/call_delayed.dart';

//Call handler no more than 1 time per n seconds
class VoidThrottler {

  final double interval;
  final void Function() action;
  bool _isWaiting = false;
  bool _isTrailing = false;
  bool _needTrailing = false;

  VoidThrottler(this.interval, this.action, {bool isTrailing = false}) {
    _isTrailing = isTrailing;
  }

   void _execute(){
    _isWaiting = true;
    _needTrailing = false;

    action();

    DelayedCall.once(interval, _delayedCheck);
  } 

  void _delayedCheck(){
    _isWaiting = false;
    if (_isTrailing && _needTrailing) _execute();
  }

  void call() {

    if (_isWaiting){
      _needTrailing = true;
      return;
    } 
    
    _execute();
  }

  void cancel(){
    DelayedCall.remove(_delayedCheck);
    _isWaiting = false;
  }
}

class OneThrottler<T1> {

  final double interval;
  final void Function(T1) action;
  bool _isWaiting = false;
  bool _isTrailing = false;
  bool _needTrailing = false;

  T1? _lastValue; 

  OneThrottler(this.interval, this.action, {bool isTrailing = false}) {
    _isTrailing = isTrailing;
  }

  void _execute(){
    _isWaiting = true;
    _needTrailing = false;

    action(_lastValue as T1);

    DelayedCall.once(interval, _delayedCheck);
  }

  void _delayedCheck(){
    _isWaiting = false;
    if (_isTrailing && _needTrailing) _execute();
  }

  void call(T1 value) {
    _lastValue = value;

    if (_isWaiting){
      _needTrailing = true;
      return;
    } 

    _execute();
  }

  void cancel(){
    DelayedCall.remove(_delayedCheck);
    _isWaiting = false;
    _lastValue = null;
  }
}

class TwoThrottler<T1, T2> {

  final double interval;
  final void Function(T1, T2) action;
  bool _isWaiting = false;
  bool _isTrailing = false;
  bool _needTrailing = false;

  T1? _lastValue1; 
  T2? _lastValue2;

  TwoThrottler(this.interval, this.action, {bool isTrailing = false}) {
    _isTrailing = isTrailing;
  } 

  void _execute(){
    _isWaiting = true;
    _needTrailing = false;

    action(_lastValue1 as T1, _lastValue2 as T2);
    DelayedCall.once(interval, _delayedCheck);
  }

  void _delayedCheck(){
    _isWaiting = false;
    if (_isTrailing && _needTrailing) _execute();
  }

  void call(T1 value1, T2 value2) {
    _lastValue1 = value1;
    _lastValue2 = value2;

    if (_isWaiting){
      _needTrailing = true;
      return;
    } 

    _execute();
  }

  void cancel(){
    DelayedCall.remove(_delayedCheck);
    _isWaiting = false;
    _lastValue1 = null;
    _lastValue2 = null;
  }
}