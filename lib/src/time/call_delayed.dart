import 'package:simplify_lib/src/extensions/datetime.dart';

class DelayedCall{

    static List<DelayedCall> _calls = [];
    static final List<DelayedCall> _toCall = [];
    static DateTime nearestCheck = minDateTime();
    
    static void once(double seconds, Function() f, {bool unsafe = false}) => _add(seconds,f, true, unsafe);
    static void every(double seconds, Function() f, {bool unsafe = false}) => _add(seconds,f, false, unsafe);

    static void _add(double second, Function() f, bool onlyOnce, bool unsafe){

      var c = _find(f);
      
      if (c == null){
        c = DelayedCall();
        _calls.add(c);
      } 

      c.isDestroyed = false;
      c.interval = second;
      c.onlyOnce = onlyOnce;
      c.handler = f;
      c.unsafeCall = unsafe;

      c.stamp = DateTime.now().addSeconds(second);
      if (nearestCheck.isAfter(c.stamp)) nearestCheck = c.stamp;
    }

    static bool remove(Function() f){
      for (int i=0; i < _calls.length; i++){
        var c = _calls[i];
        if (c.handler == f){
          c.isDestroyed = true;
          return true;
        }
      }

      return false;
    }

    static void tick(double seconds) {
      
      if (nearestCheck.isAfter(DateTime.now())) return;
      if (_calls.isEmpty) return;

      nearestCheck = minDateTime();
      _toCall.clear();
      _calls = _calls.where(_doCalls).toList();
      for (var c in _toCall) {

        if (c.unsafeCall){
          c.handler.call();
          continue;
        }

        try{
          c.handler.call();
        }catch(e,s){

          c.isDestroyed = true;
          print('An error occurred: $e');
          print('Stack trace: $s');
          
        }
      }

      _toCall.clear();
    }

    static bool _doCalls(DelayedCall c){
      if (c.isDestroyed) return false;

      if (nearestCheck.isAfter(c.stamp) || nearestCheck == minDateTime()){
        nearestCheck = c.stamp;
      }
      if (c.stamp.isAfter(DateTime.now())) return true;
      if (c.onlyOnce) c.isDestroyed = true;
      _toCall.add(c);
      if (c.isDestroyed) return false;
      c.stamp = c.stamp.addSeconds(c.interval);
      return true;
    }

    static DelayedCall? _find(Function() f){
      for (var c in _calls) {
        if (c.handler == f) return c;
      }

      return null;
    }

    late Function() handler;
    DateTime stamp = minDateTime();
    bool onlyOnce = false;
    double interval = 1;
    bool isDestroyed = false;
    bool unsafeCall = false;
}