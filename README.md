# simplify_lib
Simple dart utilities to make life better

# Initialization

The library uses conditional imports. It automatically detects if it's running in a Flutter app or a pure Dart CLI app, so you don't need to change your code.

```dart
import 'package:simplify_lib/time.dart';

//Support console or flutter apps
Time.start(fps);
// ... later
Time.stop();
```

## Tween

Simpliest tweener based on function closures. The `Record` type is used for conveniently changing properties from and to

Idea from https://github.com/shohei909/tweenx/tree/master/src/tweenxcore/tweenxcore

```dart
import 'package:simplify_lib/tween.dart';

Tween moveObj(){

    var xCoord = (0.0, 100.0);

    return Tween.play(2, (t){
        obj.x = xCoord.ulerp(quadIn(t.rate));
    });
  
}

```

You could use `record.lerp` - lerp clamped, `record.ulerp` - lerp unclamped extensions.

All standart tween function are supported. Also you could use enum values:
```dart
    var easeFunc = Easings.easeBounceInOut;
    obj.x = xCoord.ulerp(easeFunc(t.rate));
```

You can create tween sequences using:

```dart
Tween.play(1,firstUpdateFunc)
    .wait(1.2)
    .then(firstCompleteFunc)
    .next(1, secondTweenFunc);
```

You can split execution to multiple branches after first tween:

```dart
Tween.play(0)
    .split(Tween.create()....)
    .split(Tween.create()...);
```

You can pass to the tween a time scaler object responsible for the time dilation effects:

```dart

var enemyUnitsTimeScaler = TimeScaler(1.0);
Tween.play(1, moveEnemyUnits, timeScaler:enemyUnitsTimeScaler);

// Slow down only these specific tweens
enemyUnitsTimeScaler.timeScale = 0.1;
```

## DelayedCalls

```dart
import 'package:simplify_lib/calls.dart';

DelayedCall.once(2.0, calledOnceAfterTwoSeconds);
DelayedCall.every(0.1, calledEvery100MsWithoutTryCatch, unsafe:true);
```

## Signals

Observer pattern realization. Support one, two or void arguments.

```dart
import 'package:simplify_lib/signals.dart';

var signal = OneSignal<string>();
signal.once(calledOnlyOnce);
signal.add(calledEveryFireFirstly, first:true);
signal.addThrottled(calledNoMoreThanOncePerSecond, 1.0);
signal.addDebounced(calledAfterInactivityWithLatestValue, 1.0);

//dispatch event
signal.fire("first value");
signal.delayedFire("second value", after:0.5); 
signal.delayedFire("third value", after:1.1); 
signal.fire("cancel");

void calledEveryFireFirstly(String text){
    if (text == "cancel") {
        // Subsequent listeners in this 'fire' cycle won't be called
        signal.removeAll(); 
    }
}
```
## Ticker

Standard signals to update something every frame, or every second. It's convinient way to tick all timers simultaneously.

```dart
import 'package:simplify_lib/time.dart';

Ticker.onEveryTime.add(handleTime);
Ticker.onEveryFrame.add(handleFrame);
Ticker.onEverySecond.add(handleSecond);

void handleTime(double dSeconds){
    ///when you need time from last frame
}

void handleFrame(){
    ///just need to update something every frame
}

void handleSecond(){
    ///called when second changed
}
```

## Debouncer

```dart
import 'package:simplify_lib/calls.dart';

// Create 0.5 delay debounce
final searchDebouncer = OneDebouncer<String>(0.5, (text) {
  print("Send to server $text");
});

...

TextField(
  onChanged: searchDebouncer.call,
)
```
