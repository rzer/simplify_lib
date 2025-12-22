import "package:simplify_lib/signals.dart";

///Time flow rate in tweens. Allows you to create slow-motion effects for specific parts of the game
class TimeScaler{

  static final List<TimeScaler> _scalers = [];
  static final TimeScaler main = TimeScaler(1);

  static void tick(double seconds){
    for (var scaler in _scalers) {
      scaler._tick(seconds);
    }
  }

  double timeScale;
  bool isPaused = false;

  TimeScaler(this.timeScale){
    _scalers.add(this);
  }

  OneSignal<double> onEveryTime = .new();

  void _tick(double seconds){
    if (isPaused) return;
    onEveryTime.fire(seconds*timeScale);
  }

  void dispose(){
    isPaused = true;
    _scalers.remove(this);
    onEveryTime.dispose();
  }

}