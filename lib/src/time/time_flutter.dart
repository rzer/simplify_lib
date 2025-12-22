import 'package:flutter/scheduler.dart';
import 'time.dart';

Ticker? _ticker;

void startInternal() {
  
  if (_ticker != null) return;
    
  Duration _last = Duration.zero;

  _ticker = Ticker((Duration elapsed) {
    
    double dt = (elapsed - _last).inMicroseconds / Duration.microsecondsPerSecond;
    _last = elapsed;
    Time.tick(dt);
  });

  _ticker.start();
}

void stopInternal(){
  _ticker?.stop();
  _ticker = null;
}