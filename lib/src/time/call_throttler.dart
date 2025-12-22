import 'package:simplify_lib/src/time/call_delayed.dart';

//Call handler no more than n seconds
class VoidThrottler {

  final double interval;
  final Function action;
  bool _isWaiting = false;

  VoidThrottler(this.interval, this.action);

  void call() {
    if (_isWaiting) return; 

    action(); 
    _isWaiting = true;

    DelayedCall.once(interval, () {
      _isWaiting = false;
    });
  }
}

class OneThrottler<T1> {

  final double interval;
  final void Function(T1) action;
  bool _isWaiting = false;

  OneThrottler(this.interval, this.action);

  void call(T1 param) {
    if (_isWaiting) return; 

    action(param); 
    _isWaiting = true;

    DelayedCall.once(interval, () {
      _isWaiting = false;
    });
  }
}

class TwoThrottler<T1, T2> {


  final double interval;
  final void Function(T1, T2) action;
  bool _isWaiting = false;

  TwoThrottler(this.interval, this.action);

  void call(T1 param1, T2 param2) {
    if (_isWaiting) return; 

    action(param1, param2); 
    _isWaiting = true;

    DelayedCall.once(interval, () {
      _isWaiting = false;
    });
  }
}