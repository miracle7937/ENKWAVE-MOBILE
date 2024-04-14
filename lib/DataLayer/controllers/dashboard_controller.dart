import 'dart:developer';

import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../Constant/package_info.dart';
import '../../Constant/string_values.dart';
import '../../UILayer/Screens/history/widget/transaction_enum.dart';
import '../LocalData/local_data_storage.dart';
import '../model/history_model.dart';
import '../repository/dashboard_repository.dart';

class DashBoardController with ChangeNotifier {
  UserData userData = UserData();
  List<TransactionData> transactionData = [];
  List<TransactionData> queryTransactionData = [];
  late DashboardView _dashboardView;
  late MainView _mainView;
  late HistoryView _historyView;
  PageState pageState = PageState.loaded;
  bool isAccountCreationLoading = false;
  bool isHistoryLoading = false;
  AppSettings? appSettings;
  String? startDate, endDate;
  set setView(DashboardView dashboardView) {
    _dashboardView = dashboardView;
  }

  set setHistoryView(v) {
    _historyView = v;
  }

  set setMainView(MainView mainView) {
    _mainView = mainView;
  }

  String get fullName => "${userData.firstName}";
  get getAccountBalance => "${userData.mainWallet}";
  get getAccountBonusBalance => "${userData.bonusWallet}";
  get getVAccountNumber => "${userData.vAccountNo}";
  get getVBankName => "${userData.vBankName}";
  get getVAccountName => "${userData.vAccountName}";
  bool get completeKYC => userData.isStatusCompleted();
  bool get isMale => (userData.gender?.toUpperCase() == "male".toUpperCase());
  // bool get isMerchant => !(userData.accountBalance == "user");

  fetchDashboardData({bool refresh = false}) async {
    if (userData.firstName == null || refresh == true) {
      try {
        pageState = PageState.loading;
        if (refresh == true) {
          notifyListeners();
        }
        LoginResponseModel result = await DashboardRepository().fetch();

        if (result.data != null) {
          userData = result.data!;
          LocalDataStorage.saveUserData(userData);
        }
        pageState = PageState.loaded;
        notifyListeners();
        appSettings = await LocalDataStorage.getUserAppSettings();
        log(">>>>>>>>>>>>>>>>>>>feature>>>>>>>>>>>>>>>>>");
        if (appSettings?.version != PackageInfo().getVersion()) {
          _dashboardView.onVersionCheck();
        }
      } catch (e) {
        log(e.toString());
        pageState = PageState.loaded;
        notifyListeners();
        _dashboardView.onError(e.toString());
      }
    }
  }

  fetchHistory({bool refresh = false}) async {
    if (!refresh) {
      if (isHistoryLoading) {
        return;
      }
    }
    pageState = PageState.loading;
    if (refresh == true) {
      notifyListeners();
    }
    await DashboardRepository().getHistory().then((result) {
      if (result.status == true) {
        queryTransactionData = result.transactionData!;
        isHistoryLoading = true;
      }
      pageState = PageState.loaded;
      notifyListeners();
      log(userData.toJson().toString());
    }).onError((onError, trace) {
      print("$trace trace");
      pageState = PageState.loaded;
      notifyListeners();
      _dashboardView.onError(onError.toString());
    });
  }

  fetchHistoryByDate() async {
    if (isEmpty(startDate) || isEmpty(endDate)) {
      _historyView.onError("Please choose a start date and an end date.");
      return;
    }
    DateFormat format = DateFormat("dd-MM-yyyy");
    DateTime _startDate = format.parse(startDate!);
    DateTime _endDate = format.parse(endDate!);

    if (_startDate.isAfter(_endDate)) {
      _historyView
          .onError("Please choose a start date that is before end date.");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    await DashboardRepository()
        .getHistoryByDate(startDate: startDate!, endDate: endDate!)
        .then((result) {
      if (result.status == true) {
        if (result.message == null) {
          transactionData = result.transactionData!;
          queryTransactionData = result.transactionData!;
        } else {
          _historyView.onSuccess(result.message ??
              "Please review the transaction details sent to your email.");
        }
      }
      startDate = null;
      endDate = null;
      pageState = PageState.loaded;
      notifyListeners();
      log(userData.toJson().toString());
    }).onError((onError, trace) {
      print("$trace trace");
      startDate = null;
      endDate = null;
      pageState = PageState.loaded;
      notifyListeners();
      _historyView.onError(onError.toString());
    });
  }

  filterHistoryItems(String query) {
    if (isEmpty(query)) {
      queryTransactionData = transactionData;
    }
    queryTransactionData = transactionData
        .where((item) =>
            item.transactionType!.toLowerCase().contains(query.toLowerCase()) ||
            item.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  filterByTransactionType(TransactionEnum query) {
    if (isEmpty(query.name)) {
      queryTransactionData = transactionData;
    }
    if (query == TransactionEnum.all) {
      queryTransactionData = transactionData;
    } else if (query == TransactionEnum.billsPayment) {
      queryTransactionData = transactionData
          .where((item) => item.transactionType!
              .toLowerCase()
              .contains("billsPayment".toLowerCase()))
          .toList();
    } else {
      queryTransactionData = transactionData
          .where((item) => item.transactionType!
              .toLowerCase()
              .contains(query.name.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  createAccount() async {
    isAccountCreationLoading = true;
    notifyListeners();
    await DashboardRepository().createAccount().then((value) {
      if (value.status == true) {
        _mainView.onAccountCreateSuccess(value.message ?? "");
      } else {
        _mainView.onError(value.message ?? "");
      }
      isAccountCreationLoading = false;
      notifyListeners();
    }).catchError((onError) {
      isAccountCreationLoading = false;
      notifyListeners();
      _mainView.onError(onError.toString());
    });
  }

  onCahIn() {
    if (!userData.userHaveAccount()) {
      _mainView.onAccountCheck();
    } else {
      _mainView.onShowTransferAccount();
    }
  }

  clearAll() {
    userData = UserData();
    startDate = null;
    endDate = null;
  }
}

abstract class DashboardView {
  void onSuccess(String message);
  void onError(String message);
  void onVersionCheck();
}

abstract class HistoryView {
  void onSuccess(String message);
  void onError(String message);
}

abstract class MainView {
  void onSuccess(String message);
  void onError(String message);
  void onAccountCreateSuccess(String message);

  void onAccountCheck();
  void onShowTransferAccount();
}
