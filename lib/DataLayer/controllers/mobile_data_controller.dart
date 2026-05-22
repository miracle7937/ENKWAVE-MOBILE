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
import '../model/mobile_data_product_model/buy_data_model.dart';

//MobileDataFetch
class MobileDataController extends ProductController with MobileDataFetch {
  late OnMobileDataView _onMobileDataView;
  BasePackage? basePackage;
  NetworkSelector? _networkSelector;
  BuyDataModel buyDataModel = BuyDataModel();
  UserWallet? userWallet;

  pickWallet(value) {
    buyDataModel.wallet = value.key;
    userWallet = value;
    notifyListeners();
    // print(value.hashCode);
  }

  set setPin(String v) {
    buyDataModel.pin = v;
  }

  set setPackage(BasePackage v) {
    basePackage = v;
    buyDataModel.variationCode = v.serviceCode;
    buyDataModel.serviceId = v.getServiceID;
    buyDataModel.amount = v.dataAmount;
  }

  set setNetworkSelector(NetworkSelector v) {
    _networkSelector = v;
  }

  get getNetworkSelector => _networkSelector;

  String? _mobileNumber;
  set setPhoneNumber(v) {
    _mobileNumber = v;
    buyDataModel.phone = PhoneNumber.format(v);
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
    print(buyDataModel.toJson());
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

  bool get _productsLoaded {
    final s = allProductMap['status'];
    return s == true || s?.toString() == 'true';
  }

  List<T> _mapPlans<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    if (!_productsLoaded) return <T>[];
    final raw = allProductMap[key];
    if (raw is! List) return <T>[];
    return raw
        .whereType<Map>()
        .map((e) => fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  List<N9MobileDataModel> get9mobileDataProduct() {
    return _mapPlans('9mobile_data', N9MobileDataModel.fromJson);
  }

  @override
  List<AirtelMobileDataModel> getAirtelDataProduct() {
    return _mapPlans('airtel_data', AirtelMobileDataModel.fromJson);
  }

  @override
  List<GloMobileDataModel> getGloDataProduct() {
    return _mapPlans('glo_data', GloMobileDataModel.fromJson);
  }

  @override
  List<MtnMobileDataModel>? getMTNDataProduct() {
    return _mapPlans('mtn_data', MtnMobileDataModel.fromJson);
  }

  @override
  List<UserWallet> getAccount() {
    return _mapPlans('account', UserWallet.fromJson);
  }

  void clearData() {
    _networkSelector = null;
    basePackage = null;
    clearResponse();
  }
}
