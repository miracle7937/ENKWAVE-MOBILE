import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../eod_controller.dart';

final eodController = ChangeNotifierProvider<EODController>((ref) {
  return EODController();
});
