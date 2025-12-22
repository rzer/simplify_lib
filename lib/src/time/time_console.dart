
import 'dart:async';
import 'time.dart';

Timer? _timer;

void startInternal(double fps) {
  final Stopwatch stopwatch = Stopwatch();
  int lastMicroseconds = 0;

  // Инициализируем начальное состояние времени
  lastMicroseconds = stopwatch.elapsedMicroseconds;
  stopwatch.start();

  // Рассчитываем длительность кадра в микросекундах
  int frameDuration = Duration.microsecondsPerSecond ~/ fps;

  // Создаем периодический таймер (Event Loop консоли)
  _timer = Timer.periodic(Duration(microseconds: frameDuration), (t) {
    int currentElapsed = stopwatch.elapsedMicroseconds;
    var delta = currentElapsed - lastMicroseconds;
    lastMicroseconds = currentElapsed;

    // Вызываем общий метод tick из основного класса Time
    Time.tick(delta / Duration.microsecondsPerSecond);
  });
}

void stopInternal(){
  _timer?.cancel();
}