import 'dart:developer';

import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

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
  PageState pageState = PageState.loaded;
  bool isAccountCreationLoading = false;
  AppSettings? appSettings;

  set setView(DashboardView dashboardView) {
    _dashboardView = dashboardView;
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
    pageState = PageState.loading;
    if (refresh == true) {
      notifyListeners();
    }
    await DashboardRepository().getHistory().then((result) {
      if (result.status == true) {
        transactionData = result.transactionData!;
        queryTransactionData = result.transactionData!;
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
  }
}

abstract class DashboardView {
  void onSuccess(String message);
  void onError(String message);
  void onVersionCheck();
}

abstract class MainView {
  void onSuccess(String message);
  void onError(String message);
  void onAccountCreateSuccess(String message);

  void onAccountCheck();
  void onShowTransferAccount();
}
