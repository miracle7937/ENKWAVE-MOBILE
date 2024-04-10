import 'package:enk_pay_project/DataLayer/repository/beneficiary_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import '../model/bank_list_response.dart';
import '../model/beneficiary_response_model.dart';
import '../model/generic_model_response.dart';

class BeneficiaryController extends ChangeNotifier {
  List<Beneficariy> beneficiaries = [];
  List<Beneficariy> filteredBeneficiaries = [];
  bool fetch = true;
  BeneficiaryView? _beneficiaryView;
  setView(v) {
    _beneficiaryView = v;
  }

  BeneficiaryController() {
    getBeneficiary();
  }

  PageState pageState = PageState.loaded;
  getBeneficiary() async {
    if (fetch) {
      return;
    }
    try {
      pageState = PageState.loading;
      BeneficiaryRespModel beneficiaryRespModel =
          await BeneficiaryRepository().getBeneficiary();
      if (beneficiaryRespModel.status == true) {
        beneficiaries = beneficiaryRespModel.data ?? [];
        filteredBeneficiaries = beneficiaries;
      }
      pageState = PageState.loaded;
      notifyListeners();
      fetch = true;
    } catch (e) {
      _beneficiaryView?.onError(e.toString());
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  delete(String id) async {
    try {
      pageState = PageState.loading;
      notifyListeners();
      GenericResponse beneficiaryRespModel =
          await BeneficiaryRepository().deleteBeneficiary(id);
      if (beneficiaryRespModel.status == true) {
        _beneficiaryView?.onSuccess(beneficiaryRespModel.message ?? "");
      } else {
        _beneficiaryView?.onError("Deletion fails");
      }
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      _beneficiaryView?.onError(e.toString());
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  edit(String id, String name) async {
    try {
      pageState = PageState.loading;
      notifyListeners();
      GenericResponse beneficiaryRespModel =
          await BeneficiaryRepository().editBeneficiary(id, name);
      if (beneficiaryRespModel.status == true) {
        ;
        _beneficiaryView?.onSuccess(beneficiaryRespModel.message ?? "");
      } else {
        _beneficiaryView?.onError("Fails to edit  beneficiary name");
      }
      pageState = PageState.loaded;
      notifyListeners();
    } catch (e) {
      _beneficiaryView?.onError(e.toString());
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  void filterBeneficiaries(String query) {
    if (query.isEmpty) {
      filteredBeneficiaries = beneficiaries;
    } else {
      filteredBeneficiaries = beneficiaries
          .where((beneficiary) => (beneficiary.name ?? "")
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  clear() {
    fetch = false;
  }
}

abstract class BeneficiaryView {
  onSuccess(String message);
  onError(String message);
}
