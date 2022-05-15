import 'package:enk_pay_project/DataLayer/abstract_class/mobile_data_fetch.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/on_mobile_data_view.dart';
import 'package:enk_pay_project/DataLayer/controllers/product_controller.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/airtel_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/glo_mobile_data.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/mtn_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/n9mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/repository/mobil_data_repository.dart';
import 'package:enk_pay_project/DataLayer/request.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/airtime_enum.dart';

//MobileDataFetch
class MobileDataController extends ProductController with MobileDataFetch {
  late OnMobileDataView _onMobileDataView;
  BasePackage? basePackage;
  PageState pageState = PageState.loaded;
  NetworkSelector? _networkSelector;
  set setNetworkSelector(NetworkSelector v) {
    _networkSelector = v;
  }

  get getNetworkSelector => _networkSelector;

  String? _mobileNumber;
  set setPhoneNumber(v) {
    _mobileNumber = v;
  }

  get mobileNumber => _mobileNumber;

  set setView(OnMobileDataView onMobileDataView) {
    _onMobileDataView = onMobileDataView;
  }

  MobileDataController() {
    allProduct(); // fetch all product
  }

  summitButton() {
    if (basePackage != null) {
      _onMobileDataView.onPreview();
    } else {
      _onMobileDataView.onError("All fields  must be selected");
    }
  }

  onBuyMobileData() {
    pageState = PageState.loading;
    notifyListeners();
    MobileDataRepository()
        .buyData(_networkSelector!, basePackage!, _mobileNumber!)
        .then((value) {
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
      if (v is HttpException) {
        _onMobileDataView.onError(v.getMessage);
        return;
      }
      _onMobileDataView.onError(v.toString());
    });
  }

  @override
  List<N9MobileDataModel>? get9mobileDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["etisalat_data"] as List)
          .map((data) => N9MobileDataModel.fromJson(data))
          .toList();
    }
  }

  @override
  List<AirtelMobileDataModel>? getAirtelDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["airtel_data"] as List)
          .map((data) => AirtelMobileDataModel.fromJson(data))
          .toList();
    }
  }

  @override
  List<GloMobileDataModel>? getGloDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["glo_data"] as List)
          .map((data) => GloMobileDataModel.fromJson(data))
          .toList();
    }
  }

  @override
  List<MtnMobileDataModel>? getMTNDataProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["mtn_data"] as List)
          .map((data) => MtnMobileDataModel.fromJson(data))
          .toList();
    }
  }

  void clearData() {
    _networkSelector = null;
    basePackage = null;
    super.dispose();
  }
}
