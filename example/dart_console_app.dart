
import 'package:simplify_lib/time.dart';
import 'package:simplify_lib/tween.dart';

void main(List<String> arguments) {

  Time.start(10);

  var timeScaler = TimeScaler(1);
  var timeScale = (1.0, 0.1);
  print("ok");
  
  var t = Tween.play(2, (t){

    timeScaler.timeScale = timeScale.ulerp(quadIn(t.rate));
    print("rate ${t.rate}, timeScale: ${timeScaler.timeScale}");

  }, timeScaler:timeScaler).wait(1).next(1, (t){

    print("second: ${t.rate}");

  }).then((){
        print("timer cancel");
        Time.stop();
  });


  

 
  
}
