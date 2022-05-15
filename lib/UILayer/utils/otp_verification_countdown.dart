import 'dart:async';

class CountdownOTP {
  final int countSec;
  CountdownOTP({required this.countSec});
  final streamController = StreamController<String?>();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;

  // late OTPCountDown _otpCountDown;
  Stream<String?> get timerStream => streamController.stream;
  late Timer _timer;
  int timerInSecond = 0;
  bool startCount = false;
  count() {
    timerInSecond = countSec;
    if (startCount) {
      _timer.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print("Timer  ${timer.tick}");
      timerInSecond = timerInSecond - 1;
      streamController.add("$timerInSecond sec");
      if (timerInSecond <= 0) {
        streamController.add(null);
        _timer.cancel();
      }
      print("count  $timerInSecond");
    });
    startCount = !startCount;
  }

  dispose() {
    streamController.close();
  }
}
