extension DateTimeExtension on DateTime{
  
  DateTime addSeconds(double seconds){
    int microseconds = (seconds * Duration.microsecondsPerSecond).toInt();
    return add(Duration(microseconds: microseconds));
  }

}

DateTime minDateTime() => DateTime.utc(-271821, 4, 20);
DateTime maxDateTime() => DateTime.utc(275760, 9, 13);