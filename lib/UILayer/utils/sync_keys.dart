import 'package:flutter/cupertino.dart';

import 'pos_launch_helper.dart';

class SyncKeys {
  init(BuildContext context, {bool? showLoader}) async {
    await PosLaunchHelper.prepare(
      context,
      prepDevice: true,
      showLoader: showLoader ?? false,
    );
  }
}
