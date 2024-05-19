import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:telpo_pos_enkwave/telpo_pos_enkwave.dart';

import '../../DataLayer/LocalData/local_data_storage.dart';
import '../../DataLayer/model/login_response_model.dart';
import '../CustomWidget/ReUseableWidget/snack_bar.dart';

class SyncKeys {
  init(BuildContext context) async {
    UserData? userData = await LocalDataStorage.getUserData();
    TerminalConfig? terminalConfig = await LocalDataStorage.getTerminalConfig();
    log("COMP1 <==============> ${terminalConfig?.compKey1}");
    log("COMP2 <==============> ${terminalConfig?.compKey2}");
    log("IP AND PORT <==============> ${terminalConfig?.ip} / ${terminalConfig?.port}");
    log("Terminal no <==============> ${userData?.terminalInfo?.terminalNo}");
    log("Base Url <==============> ${terminalConfig?.baseUrl}");
    if (terminalConfig?.hasNull == true || userData?.terminalInfo == null) {
      snackBar(context, message: "Terminal not profile for pos transaction");
      return;
    }
    TelpoPosEnkwave()
        .prep(userData!.terminalInfo!.terminalNo!, terminalConfig!.toJson());
  }
}
