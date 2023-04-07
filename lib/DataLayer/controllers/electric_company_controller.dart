import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/DataLayer/model/electricity_model/buy_electricity_data.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import '../../Constant/string_values.dart';
import '../../Constant/validation.dart';
import '../../UILayer/utils/format_phone_number.dart';
import '../model/electricity_model/electric_company_model.dart';
import '../repository/electricity_repository.dart';

class ElectricCompanyController with ChangeNotifier {
  BuyElectricityModel buyElectricityModel = BuyElectricityModel();
  PageState pageState = PageState.loaded;
  List<ElectricCompanyData>? electricCompany;
  List<UserWallet>? userWallet;
  ElectricCompanyData? selectedElectricCompany;
  ElectricView? _view;
  UserWallet? setWallet;
  String? meterNo, meterAccountName;

  set selectMeterNO(String meterNo) {
    this.meterNo = meterNo;
  }

  set setElectricCompany(ElectricCompanyData v) {
    selectedElectricCompany = v;
    buyElectricityModel.serviceId = v.code;
    notifyListeners();
  }

  set selectedWallet(UserWallet wallet) {
    setWallet = wallet;
    buyElectricityModel.wallet = wallet.key;
  }

  set setPin(String pin) {
    buyElectricityModel.pin = pin;
  }

  setView(ElectricView v) {
    _view = v;
  }

  set phoneNumber(String phone) {
    buyElectricityModel.phone = PhoneNumber.format(phone);
  }

  set setAmount(String amount) {
    buyElectricityModel.amount = amount;
  }

  set company(ElectricCompanyData v) {
    selectedElectricCompany = v;
    buyElectricityModel.serviceId = v.code;
    notifyListeners();
  }

  set setProductType(String product) {
    buyElectricityModel.variationCode = product;
    notifyListeners();
  }

  Future<void> fetchElectricCompany() async {
    if (electricCompany != null) {
      return;
    }
    pageState = PageState.loading;

    try {
      var value = await ElectricityRepository().getAllCompany();
      if (value.status == true) {
        electricCompany = value.data;
        userWallet = value.userWallets;
      }
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  Future<void> buyPower() async {
    pageState = PageState.loading;
    notifyListeners();
    try {
      var value =
          await ElectricityRepository().buyPower(buyElectricityModel.toJson());
      if (value.status == true) {
        _view!.onSuccess(value.message ?? "");
      } else {
        _view!.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      pageState = PageState.loaded;
      notifyListeners();
      _view!.onError(e.toString() ?? "");
    }
  }

  onStartTransaction() {
    validateTransferForm();
  }

  validateTransferForm() {
    print(buyElectricityModel.toJson());
    if (!ValidationController().isValidPhoneNumber(buyElectricityModel.phone)) {
      _view?.onError("Please provide beneficiary phone number");
      return;
    }
    if (isEmpty(buyElectricityModel.amount)) {
      _view?.onError("Enter transaction Amount");
      return;
    }
    if (isEmpty(buyElectricityModel.wallet)) {
      _view?.onError("please select transaction wallet");
      return;
    }
    if (isEmpty(buyElectricityModel.variationCode)) {
      _view?.onError("please select the product type");
      return;
    }
    if (isEmpty(meterAccountName)) {
      _view?.onError("Please verify meter umber");
      return;
    }
    _view?.onPinVerification();
  }

  clear() {
    selectedElectricCompany = null;
    setWallet = null;
    buyElectricityModel = BuyElectricityModel();
    meterNo = null;
    meterAccountName = null;
  }

  void bankMeterNoVerification() {
    if (isNotEmpty(buyElectricityModel.serviceId) && isNotEmpty(meterNo)) {
      //clear the initial bankname
      meterAccountName = null;
      var map = <String, dynamic>{};
      map["service_id"] = buyElectricityModel.serviceId;
      map["biller_code"] = meterNo;

      pageState = PageState.loading;
      notifyListeners();
      ElectricityRepository.verifyMeterNo(map).then((value) {
        if (value.status == true) {
          meterAccountName = value.data;
        } else {
          _view?.onError(value.message ?? "");
        }
        pageState = PageState.loaded;
        notifyListeners();
      }).catchError((onError) {
        pageState = PageState.loaded;
        notifyListeners();
        _view?.onError(onError.toString());
      });
    } else {
      _view?.onError("Ensure no empty field(s) ");
    }
  }
}

abstract class ElectricView {
  onSuccess(String message);
  onError(String message);
  onPinVerification();
  onBuyPower();
}
