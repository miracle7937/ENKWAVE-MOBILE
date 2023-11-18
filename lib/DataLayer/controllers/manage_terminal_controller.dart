import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import '../model/terminal_request_model.dart';
import '../model/terminal_transaction_request_model.dart';
import '../repository/setting_repository.dart';

class ManageTerminalController with ChangeNotifier {
  OnGetTerminal? _onGetTerminal;
  OnTerminalHistory? _onTerminalHistory;
  PageState? pageState;
  PageState? forHistoryState;
  List<TerminalData>? terminalData;
  TerminalTransactionsModel? terminalTransactionsModel;
  TerminalData? selectedTerminal;
  String? totalAmountPaid;

  set setSelectedTerminal(v) {
    selectedTerminal = v;
  }

  set onGetTerminal(v) {
    _onGetTerminal = v;
  }

  set onTerminalHistory(v) {
    _onTerminalHistory = v;
  }

  getListOFTerminal() {
    if (pageState == null) {
      pageState = PageState.loading;
      SettingRepository().getAllTerminal().then((value) {
        terminalData = value.data ?? [];
        totalAmountPaid = value.amountPaid;
        pageState = PageState.loaded;
        notifyListeners();
      }).onError((v, o) {
        _onGetTerminal?.onError(v.toString());
        pageState = PageState.loaded;
        notifyListeners();
      });
    }
  }

  Future getTerminalHistory({bool? refresh}) async {
    forHistoryState = PageState.loading;
    if (refresh == true) {
      notifyListeners();
    }
    Map data = {"serial_no": selectedTerminal?.serialNo ?? ""};

    try {
      terminalTransactionsModel =
          await SettingRepository().requestTerminalTransaction(data);
      forHistoryState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      print(e);
      _onTerminalHistory?.onError(e.toString());
      forHistoryState = PageState.loaded;
      notifyListeners();
    }
  }

  clearAll() {
    pageState = null;
    terminalTransactionsModel = null;
  }

  clearAllHistory() {
    terminalTransactionsModel = null;
  }
}

abstract class OnGetTerminal {
  onSuccess(String? message);
  onError(String? message);
}

abstract class OnTerminalHistory {
  onSuccess(String? message);
  onError(String? message);
}
