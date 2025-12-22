import 'package:simplify_lib/calls.dart';
import 'package:simplify_lib/src/time/call_delayed.dart';

class OneSignal<T1>{

  final List<_SignalListener<T1>> _handlers = [];
  int _fireIndex = 0;
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;
  bool hasListeners() => _handlers.isNotEmpty;

  void add(Function(T1) handler, {Object? tag, bool first = false})=> _add(handler, first, tag, false);
  void once(Function(T1) handler, {Object? tag, bool first = false})=> _add(handler, first, tag, true);

  OneThrottler<T1> addThrottled(double seconds, Function(T1) handler, {Object? tag, bool first = false}) {
    final throttler = OneThrottler<T1>(seconds, handler);
    _add(throttler.call, first, tag, false); 
    return throttler;
  }

  OneDebouncer<T1> addDebounced(double seconds, Function(T1) handler, {Object? tag, bool first = false}) {
    final debouncer = OneDebouncer<T1>(seconds, handler);
    _add(debouncer.call, first, tag, false); 
    return debouncer;
  }

  void delayedFire(T1 p1, {Object? tag, double after = 0}){
    DelayedCall.once(after, () => fire(p1, tag: tag));
  }
  
  void fire(T1 p1, {Object? tag}){

    if (isDisposed) return;
    if (_handlers.isEmpty) return;

    _fireIndex = 0;
    while(_fireIndex < _handlers.length){
      var handler = _handlers[_fireIndex];
      if (handler.tag == null || handler.tag == tag){

        if (handler.once){
          _handlers.removeAt(_fireIndex);
          _fireIndex--;
        }
        handler.func.call(p1);
        if (isDisposed) return;
      }
      _fireIndex++;
    }
  }
  
  void remove(Function(T1) handler, {Object? tag}){
    var anIndex = _findItem(handler, tag);
    if (anIndex == -1) return;
    if (anIndex <= _fireIndex && _fireIndex >= 0) _fireIndex--;
    _handlers.removeAt(anIndex);
  }

  void _add(Function(T1) action, bool callFirst, Object? tag, bool once){
    if (isDisposed) return;
    if (_findItem(action,tag) != -1) return;
    if (callFirst) _handlers.insert(0, _SignalListener(action,tag,once));
    else _handlers.add(_SignalListener(action,tag,once));
  }

  int _findItem(Function(T1) action, Object? tag){
    for(int i = 0; i < _handlers.length; i++){
      var handler = _handlers[i];
      var isTagEqual = (handler.tag == null && tag == null) || (handler.tag == tag);
      if (handler.func == action && isTagEqual) return i;
    }
    return -1;
  }

  void removeAll([Object? tag]){

    if (isDisposed) return;

    if (tag == null){
      _handlers.clear();
      return;
    }

    for (int i = 0; i < _handlers.length; i++)
    {
        var handler = _handlers[i];
        
        if (tag == handler.tag)
        {
            if (i <= _fireIndex && _fireIndex >= 0) _fireIndex--;
            _handlers.removeAt(i);
            i--;
        }
    }

  }

  void dispose(){
    removeAll();
    _isDisposed = true;
  }

}

class _SignalListener<T1>{
   Function(T1) func;
   Object? tag;
   bool once = true;
   _SignalListener(this.func, this.tag, this.once);
}