import 'dart:ffi';

import 'package:simplify_lib/calls.dart';
import 'package:simplify_lib/src/time/call_delayed.dart';

class VoidSignal{

  final List<_SignalListener> _handlers = [];
  int _fireIndex = 0;
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;
  bool hasListeners() => _handlers.isNotEmpty;

  void add(Function() handler, {Object? tag, bool first = false})=> _add(handler, first, tag, false);
  void once(Function() handler, {Object? tag, bool first = false})=> _add(handler, first, tag, true);
  
  VoidThrottler addThrottled(double seconds, Function handler, {Object? tag, bool first = false}) {
    final throttler = VoidThrottler(seconds, handler);
    _add(throttler.call, first, tag, false); 
    return throttler;
  }

  VoidDebouncer addDebounced(double seconds, Function handler, {Object? tag, bool first = false}) {
    final debouncer = VoidDebouncer(seconds, handler);
    _add(debouncer.call, first, tag, false); 
    return debouncer;
  }

  void delayedFire({Object? tag, double after = 0}){
    DelayedCall.once(after, () => fire(tag: tag));
  }

  void fire({Object? tag}){
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
        handler.func.call();
        if (isDisposed) return;
      }
      _fireIndex++;
    }
  }
  void remove(Function() handler, {Object? tag}){
    var anIndex = _findItem(handler, tag);
    if (anIndex == -1) return;
    if (anIndex <= _fireIndex && _fireIndex >= 0) _fireIndex--;
    _handlers.removeAt(anIndex);
  }

  void _add(Function() action, bool callFirst, Object? tag, bool once){

    if (isDisposed) return;
    if (_findItem(action,tag) != -1) return;

    if (callFirst) {
      
      _handlers.insert(0, _SignalListener(action,tag,once));
      _fireIndex++;

    } else _handlers.add(_SignalListener(action,tag,once));
  }

  int _findItem(Function() action, Object? tag){
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

class _SignalListener{
   Function func;
   Object? tag;
   bool once = false;
   _SignalListener(this.func, this.tag, this.once);
}