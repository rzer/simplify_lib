import 'package:simplify_lib/src/time/call_delayed.dart';
import 'package:simplify_lib/src/time/time.dart';
import 'package:test/test.dart'; // Import the test package

int i = 0;

void addI(){
  
  i++;
  print("addI $i");

  if (i >= 5){
    DelayedCall.remove(addI);

    //this should call only once
    DelayedCall.once(0.1, checkI);
    DelayedCall.once(0.2, checkI);
  }
}

void checkA(){
  i++;
  print("checkA $i");
}

void checkI(){
  i++;
  print("checkI $i");
  if (i == 6) {
    DelayedCall.once(0.1, checkI);
    DelayedCall.remove(checkI);
    DelayedCall.once(0.1, checkA);
    DelayedCall.once(0.1, checkI);
  }
}



void main() {

  
  group('Counter Tests', () { // Organize tests into groups

    test('DelayedCall simple test', () async {
      Time.start(60);
      i = 0;
     
      DelayedCall.every(0.1, addI);
      await Future.delayed(const Duration(seconds: 3));
      expect(i, equals(8));
    });
  });
}