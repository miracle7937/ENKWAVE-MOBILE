import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/cable_tv_view.dart';
import 'package:enk_pay_project/DataLayer/abstract_class/cablle_tv_fetch.dart';
import 'package:enk_pay_project/DataLayer/controllers/product_controller.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/cable_tv_model/dstv_response_tv.dart';
import 'package:enk_pay_project/DataLayer/model/cable_tv_model/gotv_response_model.dart';
import 'package:enk_pay_project/DataLayer/model/cable_tv_model/showmax_response.dart';
import 'package:enk_pay_project/DataLayer/model/cable_tv_model/startimes_response.dart';
import 'package:enk_pay_project/DataLayer/model/look_data.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/DataLayer/repository/cable_tv_repository.dart';
import 'package:enk_pay_project/DataLayer/repository/look_up_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/utils/cable_tv_enum.dart';

class CableTVController extends ProductController with CableTVDataFetch {
  CableTVController() {
    allCableProduct(); // fetch all product
  }
  final LookData _lookData = LookData();
  BasePackage? basePackage;
  OnCableTV? _onCableTV;
  String? customerName, phoneNumber;
  CableEnum? _cableEnum;
  UserWallet? selectedUserWallet;
  String? decoderNumber, searchName;
  String? get getProductType => _lookData.type;
  set selectWallet(UserWallet value) {
    selectedUserWallet = value;
    notifyListeners();
  }

  setDecoderNumber(String number) {
    _lookData.billerCode = number;
    notifyListeners();
  }

  setPhone(String number) {
    phoneNumber = number;
  }

  get getCableEnum => _cableEnum;
  set setCableTVSelector(CableEnum v) {
    _cableEnum = v;
    _lookData.serviceId = v.name.toLowerCase();
    notifyListeners();
  }

  set setProductType(String product) {
    _lookData.type = product;
  }

  set setView(OnCableTV onCableTV) {
    _onCableTV = onCableTV;
  }

  searchLook() {
    if (!_lookData.isValid()) {
      _onCableTV?.onError("Field are not completed for this action");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    LookUPRepository().byAirTime(_lookData).then((value) {
      if (value.status == true) {
        customerName = value.data;
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((e) {
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  payment() {
    validateForm();
    CableTvRepository()
        .processCablePayment(
            getCableEnum, basePackage!.code!, decoderNumber!, phoneNumber!)
        .then((value) {
      if (value.status == true) {
        _onCableTV!.onSuccess(value.message!);
        return;
      }
      _onCableTV!.onError(value.message!);
    }).catchError((e) {
      _onCableTV!.onError(e.toString());
    });
  }

  void validateForm() {
    if (getCableEnum == null) {
      _onCableTV!.onError("Please Select the cable type");
      return;
    } else if (basePackage == null) {
      _onCableTV!.onError("Your select package");
      return;
    } else if (isEmpty(decoderNumber)) {
      _onCableTV!.onError("Please Enter device number");
      return;
    } else if (isEmpty(phoneNumber) || phoneNumber!.length < 9) {
      _onCableTV!.onError("Please Enter a valid phone number");
      return;
    }
  }

  clearData() {
    _cableEnum = null;
    customerName = null;
    phoneNumber = null;
    clearResponse();
  }

  set selectPackage(BasePackage value) {
    basePackage = value;
    notifyListeners();
  }

  List<BasePackage>? getSelectedProduct() {
    if (_cableEnum == null) {
      return null;
    }
    switch (_cableEnum) {
      case CableEnum.dsTv:
        return getDSTVProduct();
      case CableEnum.goTv:
        return getGoTVProduct();
      case CableEnum.startTimes:
        return getStarTimeProduct();
      default:
        return getShowMaxProduct();
    }
  }

  @override
  List<DsTvResponseModel>? getDSTVProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["dstv"] as List)
          .map((data) => DsTvResponseModel.fromJson(data))
          .toList();
    }
    return [];
  }

  @override
  List<GoTvResponseModel>? getGoTVProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["gotv"] as List)
          .map((data) => GoTvResponseModel.fromJson(data))
          .toList();
    }
    return [];
  }

  @override
  List<UserWallet>? getAccount() {
    print("$allProductMap MIMI");
    if (allProductMap["status"] == true) {
      return (allProductMap["account"] as List)
          .map((data) => UserWallet.fromJson(data))
          .toList();
    }
    return <UserWallet>[];
  }

  @override
  List<ShowMaxResponseModel>? getShowMaxProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["showmax"] as List)
          .map((data) => ShowMaxResponseModel.fromJson(data))
          .toList();
    }
    return [];
  }

  @override
  List<StarTimesResponseModel>? getStarTimeProduct() {
    if (allProductMap["status"] == true) {
      return (allProductMap["startimes"] as List)
          .map((data) => StarTimesResponseModel.fromJson(data))
          .toList();
    }
    return [];
  }
}
