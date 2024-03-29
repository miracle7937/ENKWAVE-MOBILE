import 'dart:developer';

import 'package:etop_pos_plugin/etop_pos_plugin.dart';
import 'package:flutter/cupertino.dart';

import '../../DataLayer/LocalData/local_data_storage.dart';
import '../../DataLayer/model/login_response_model.dart';
import '../CustomWidget/ReUseableWidget/snack_bar.dart';

class SyncKeys {
  init(BuildContext context, {bool? showLoader}) async {
    UserData? userData = await LocalDataStorage.getUserData();
    TerminalConfig? terminalConfig = await LocalDataStorage.getTerminalConfig();
    log("COMP1 <==============> ${terminalConfig?.compKey1}");
    log("COMP2 <==============> ${terminalConfig?.compKey2}");
    log("IP AND PORT <==============> ${terminalConfig?.ip} / ${terminalConfig?.port}");
    log("Terminal no <==============> ${userData?.terminalInfo?.terminalNo}");
    log("Base Url <==============> ${terminalConfig?.baseUrl}");
    log("LOGO Url <==============> ${terminalConfig?.logoUrl}");
    if (terminalConfig?.hasNull == true || userData?.terminalInfo == null) {
      snackBar(context, message: "Terminal not profile for pos properly");
      return;
    }
    terminalConfig?.setShowLoader(showLoader.toString());
    EtopPosPlugin().prepDevice(
        userData!.terminalInfo!.terminalNo!, terminalConfig!.toJson());
  }
}
