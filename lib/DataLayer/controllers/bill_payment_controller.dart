import 'dart:developer';

import 'package:enk_pay_project/DataLayer/controllers/product_controller.dart';
import 'package:enk_pay_project/DataLayer/model/bill_categories.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/foundation.dart';

import '../abstract_class/bill_categories_fetch.dart';
import '../model/bill_form_response.dart';
import '../model/bill_payment_request_model.dart';
import '../model/biller_response.dart';
import '../model/validate_bill_model.dart';
import '../repository/bill_repository.dart';
import '../repository/look_up_repository.dart';

class BillPaymentController extends ProductController with BillCategoriesFetch {
  OnBillPaymentView? _view;
  CategoryData? selectedCategory;
  Bill? selectedBill;
  var validateBillModel = ValidateBillModel();
  var billPaymentModel = BillPaymentModel();
  BillResponse billResponse = BillResponse();
  BillFormResponse billFormResponse = BillFormResponse();
  List<CategoryData> categoryData = [];
  String? customerName;
  Map<String, Items> items = {};
  initialize() {
    allBillCategories(); // fetch all product
  }

  Future allBillCategories() async {
    if (categoryData.isEmpty) {
      pageState = PageState.loading;
      var billData = await getBillCategories();
      if (billData["status"] == true) {
        categoryData = (billData["data"] as List)
            .map((data) => CategoryData.fromJson(data))
            .toList();
      }
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  set setView(v) {
    _view = v;
  }

  setDynamicItem(String key, Items value) {
    var billPayment = billPaymentModel.fieldsValue;
    billPayment[key] = value.itemId;
    items[key] = value;
    billPaymentModel.serviceId = value.itemId;
    notifyListeners();
  }

  setDynamicData(String key, String value) {
    print(key);
    var billPayment = billPaymentModel.fieldsValue;
    billPayment[key] = value;
    notifyListeners();
  }

  getDynamicData(String key) => items[key];

  set setSelectedCategory(CategoryData v) {
    selectedCategory = v;
    notifyListeners();
    getBill(v.id!);
  }

  set setSelectedBill(Bill v) {
    selectedBill = v;
    billPaymentModel.billerId = v.id;
    getBillForms(v.id!);
  }

  @override
  List<CategoryData>? getCategories() {
    if (allProductMap["status"] == true) {
      return (allProductMap["data"] as List)
          .map((data) => CategoryData.fromJson(data))
          .toList();
    }
    return <CategoryData>[];
  }

  void searchLook() {
    pageState = PageState.loading;
    notifyListeners();
    LookUPRepository().billCustomer(billPaymentModel.toJson()).then((value) {
      if (value.status == true) {
        billPaymentModel.fieldsValue["customerName"] = value.data?.name;
        billPaymentModel.fieldsValue["otherField"] = value.data?.otherField;
        _view?.onBillValidate("Your payment is for this, ${value.data?.name}.");
      } else {
        _view?.onError(value.message ?? "Error");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((e) {
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  validateDataForm() {
    if (!billPaymentModel.validForm) {
      _view?.onError("Please ensure all information are provided");
      return;
    }
    _view?.onPInVerify();
  }

  onBuyBill() {
    pageState = PageState.loading;
    notifyListeners();
    BillRepository().buyBill(billPaymentModel.toJson()).then((value) {
      log(value.toString());
      if (true == value.status) {
        _view?.onSuccess(value.message!);
      } else {
        _view?.onError(value.message!);
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((v) {
      pageState = PageState.loaded;
      notifyListeners();
      _view?.onError(v.toString());
    });
  }

  getBill(String id) {
    pageState = PageState.loading;
    notifyListeners();
    BillRepository().getBill(id).then((value) {
      log(value.toString());
      if (true == value.status) {
        billResponse = value;
      } else {
        _view?.onError("error fetching billers");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((v) {
      pageState = PageState.loaded;
      notifyListeners();
      _view?.onError(v.toString());
    });
  }

  getBillForms(String id) {
    pageState = PageState.loading;
    notifyListeners();
    BillRepository().getBillForm(id).then((value) {
      log(value.toString());
      if (true == value.status) {
        billFormResponse = value;
        //create field to be validated against
        billFormResponse.data?.forEach((element) {
          if (kDebugMode) {
            print("adding value ${element.fieldName}");
          }
          billPaymentModel.fieldsValue[element.fieldName!] = "";
        });
      } else {
        _view?.onError("error fetching bill forms");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((v) {
      pageState = PageState.loaded;
      notifyListeners();
      _view?.onError(v.toString());
    });
  }

  @override
  clearResponse() {
    super.clearResponse();
    validateBillModel = ValidateBillModel();
    billPaymentModel = BillPaymentModel();
    billResponse = BillResponse();
    billFormResponse = BillFormResponse();
    selectedCategory = null;
  }
}

abstract class OnBillPaymentView {
  onPInVerify();
  onBuyBill();
  onSuccess(String message);
  onBillValidate(String message);
  onError(String message);
}
