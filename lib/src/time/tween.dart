
import 'package:simplify_lib/src/time/time_scaler.dart';
import 'package:simplify_lib/src/math/easings.dart';

typedef TweenHandler = Function(Tween);

class Tween{

  double _elapsed = 0;
  double _duration = 1;
  TimeScaler? _timeScaler;
  
  TweenHandler? updateHandler;
  Function()? completeHandler;
  List<Tween> nextTweens = [];

  double get totalDuration => _duration + nextTweens.fold(0.0, (max, t) => t.totalDuration > max ? t.totalDuration : max);
  double get rate => _duration <= 0 ? 1.0 : clamp01(_elapsed / _duration);
  TimeScaler get timeScaler =>  _timeScaler ?? TimeScaler.main;
 
  static Tween create(double duration, TweenHandler? updateHandler, {TimeScaler? timeScaler}){
    var t = Tween();
    t._duration = duration;
    t.updateHandler = updateHandler;
    t._timeScaler = timeScaler;
    return t;
  }

  static Tween play(double duration, TweenHandler? updateHandler, {TimeScaler? timeScaler}){
    var t = Tween();
    t._duration = duration;
    t.updateHandler = updateHandler;
    t._timeScaler = timeScaler;
    return t.start();
  }
 
  Tween start(){
    timeScaler.onEveryTime.add(_tick);
    return this;
  }
  
  Tween split(Tween t){
    t._timeScaler ??= _timeScaler;
    nextTweens.add(t);
    return this;
  }

  Tween next(double duration, TweenHandler? updateHandler){
    var t = Tween.create(duration, updateHandler, timeScaler: _timeScaler);
    nextTweens.add(t);
    return t;
  }

  Tween wait(double duration){
    var t = Tween.create(duration, null, timeScaler: _timeScaler);
    nextTweens.add(t);
    return t;
  }

  Tween then(Function() completeHandler){
    this.completeHandler = completeHandler;
    return this;
  }

  void _tick(double deltaTime){
    _elapsed+=deltaTime;
    updateHandler?.call(this);
    if (_elapsed >= _duration){
      double overtime = _elapsed - _duration;
      complete(overtime);
    } 
  }

  void complete([double overtime = 0]){

    timeScaler.onEveryTime.remove(_tick);

    completeHandler?.call();

    for (var t in nextTweens) {
      t.start();
      if (overtime > 0) t._tick(overtime); 
    }

  }

  void stop(){
    timeScaler.onEveryTime.remove(_tick);
    for (var t in nextTweens) {
      t.stop();
    }
  }


}