
import 'time_stub.dart' 
  if (dart.library.ui) 'time_flutter.dart'
  if (dart.library.io) 'time_console.dart';

import 'package:simplify_lib/src/time/call_delayed.dart';
import 'package:simplify_lib/src/time/ticker.dart';
import 'package:simplify_lib/src/time/time_scaler.dart';

abstract class Time {
  
  static void start(double fps) => startInternal(fps); 
  static void stop() => stopInternal();
 
  static void tick(double seconds) {
    Ticker.tick(seconds);
    DelayedCall.tick(seconds);
    TimeScaler.tick(seconds);
    Ticker.lateTick(seconds)
  }
}