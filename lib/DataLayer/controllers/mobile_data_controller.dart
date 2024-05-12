import 'dart:developer';

import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/mobile_data_fetch.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/on_mobile_data_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/product_controller.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/airtel_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/glo_mobile_data.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/mtn_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/n9mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/repository/mobil_data_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';
import 'package:enk_pay_project/UILayer/utils/format_phone_number.dart';

import '../../Constant/validation.dart';
import '../model/data_model_response.dart';
import '../model/data_request_model.dart';
import '../model/mobile_data_product_model/buy_data_model.dart';

//MobileDataFetch
class MobileDataController extends ProductController with MobileDataFetch {
  late OnMobileDataView _onMobileDataView;
  BasePackage? basePackage;
  NetworkSelector? _networkSelector;
  BuyDataModel buyDataModel = BuyDataModel();
  UserWallet? userWallet;
  List<AirtimeDataPlan>? listOfPlan;
  AirtimeDataPlan? selectedPlan;
  String? phoneNumber;
  set setSelectedPlan(v) {
    selectedPlan = v;
    notifyListeners();
  }

  pickWallet(value) {
    buyDataModel.wallet = value.key;
    userWallet = value;
    notifyListeners();
    // print(value.hashCode);
  }

  set setPin(String v) {
    buyDataModel.pin = v;
  }

  set setPackage(AirtimeDataPlan v) {
    selectedPlan = v;
    buyDataModel.productId = v.productId;
    buyDataModel.amount = v.amount;
  }

  set setNetworkSelector(NetworkSelector v) {
    _networkSelector = v;
  }

  get getNetworkSelector => _networkSelector;

  String? _mobileNumber;
  set setPhoneNumber(v) {
    _mobileNumber = v;
    buyDataModel.phone = PhoneNumber.format(v);
    getDataPlan(v);
  }

  set setNetworkType(v) {
    buyDataModel.network = getServiceId(v).toUpperCase();
  }

  get mobileNumber => _mobileNumber;

  set setView(OnMobileDataView onMobileDataView) {
    _onMobileDataView = onMobileDataView;
  }

  initialize() {
    allDataProduct(); // fetch all product
  }

  onBuyMobileData() {
    pageState = PageState.loading;
    notifyListeners();
    MobileDataRepository().buyData(buyDataModel.toJson()).then((value) {
      log(value.toString());
      if (true == value.status) {
        _onMobileDataView.onSuccess(value.message!);
      } else {
        _onMobileDataView.onError(value.message!);
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((v) {
      pageState = PageState.loaded;
      notifyListeners();
      _onMobileDataView.onError(v.toString());
    });
  }

  validateDataForm() {
    if (phoneNumber == null) {
      _onMobileDataView.onError("Please provide your phone number");
      return;
    }
    if (!ValidationController().isValidPhoneNumber(phoneNumber)) {
      _onMobileDataView.onError("Please provide a valid number");
      return;
    }
    if (selectedPlan == null) {
      _onMobileDataView.onError("Please selcet a data plan");
      return;
    }

    _onMobileDataView.onPInVerify();
  }

  validateDataForm2() {
    if (basePackage == null) {
      _onMobileDataView
          .onError("Please select the data plan you subscribing for");
      return;
    }
    if (!ValidationController().isValidPhoneNumber(buyDataModel.phone)) {
      _onMobileDataView.onError("Please provide a valid number");
      return;
    }
    if (isEmpty(buyDataModel.wallet)) {
      _onMobileDataView.onError("Please select account");
      return;
    }

    _onMobileDataView.onPInVerify();
  }

  @override
  List<N9MobileDataModel> get9mobileDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["9mobile_data"] as List)
          .map((data) => N9MobileDataModel.fromJson(data))
          .toList();
    }
    return <N9MobileDataModel>[];
  }

  @override
  List<AirtelMobileDataModel> getAirtelDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["airtel_data"] as List)
          .map((data) => AirtelMobileDataModel.fromJson(data))
          .toList();
    }
    return <AirtelMobileDataModel>[];
  }

  @override
  List<GloMobileDataModel> getGloDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["glo_data"] as List)
          .map((data) => GloMobileDataModel.fromJson(data))
          .toList();
    }
    return <GloMobileDataModel>[];
  }

  @override
  List<MtnMobileDataModel>? getMTNDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["mtn_data"] as List)
          .map((data) => MtnMobileDataModel.fromJson(data))
          .toList();
    }
    return <MtnMobileDataModel>[];
  }

  @override
  List<UserWallet> getAccount() {
    if (allProductMap["status"] == true) {
      return (allProductMap["account"] as List)
          .map((data) => UserWallet.fromJson(data))
          .toList();
    }
    return <UserWallet>[];
  }

  getDataPlan(String phone) {
    pageState = PageState.loading;
    notifyListeners();
    phoneNumber = phone;
    MobileDataRepository().getDataPlan({"phone": phone}).then((value) {
      if (value.status == true) {
        listOfPlan = value.data;
      } else {
        _onMobileDataView.onError(value.message!);
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((v, _) {
      log(_.toString());
      pageState = PageState.loaded;
      notifyListeners();
      _onMobileDataView.onError(v.toString());
    });
  }

  onBuyMobileAirtime() {
    var data = DataRequestModel();
    data.amount = selectedPlan?.amount;
    data.phoneNumber = phoneNumber;
    data.productId = selectedPlan?.productId;
    data.network = buyDataModel.network;

    pageState = PageState.loading;
    notifyListeners();
    MobileDataRepository().buyData(data.toJson()).then((value) {
      log(value.toString());
      if (true == value.status) {
        _onMobileDataView.onSuccess(value.message!);
      } else {
        _onMobileDataView.onError(value.message!);
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((v) {
      pageState = PageState.loaded;
      notifyListeners();
      _onMobileDataView.onError(v.toString());
    });
  }

  void clearData() {
    _networkSelector = null;
    basePackage = null;
    listOfPlan = null;
    clearResponse();
  }
}
