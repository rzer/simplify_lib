import "package:simplify_lib/signals.dart";

class Ticker{
  
  static OneSignal<double> onEveryTime = .new();
  static VoidSignal onEveryFrame = .new();
  static VoidSignal onEverySecond = .new();

  static double _secondProgress = 0;

  static void tick(double seconds) {
    onEveryFrame.fire();
    onEveryTime.fire(seconds);

    _secondProgress+=seconds;
    
    if (_secondProgress > 1){
      _secondProgress %= 1.0;
      onEverySecond.fire();
    }
  }

}