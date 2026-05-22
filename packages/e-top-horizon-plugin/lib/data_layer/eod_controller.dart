import 'package:etop_pos_plugin/data_layer/repository.dart';
import 'package:flutter/cupertino.dart';

import '../constant/page_state.dart';
import '../etop_pos_plugin.dart';
import '../utils/eod_enum.dart';
import '../utils/null_checker.dart';
import 'model/eod_Full_report_model.dart';
import 'model/eod_request_model.dart';

class EODController extends ChangeNotifier {
  PageState pageState = PageState.loaded;
  EODRequestModel eodRequestModel = EODRequestModel();
  late EODView _eodView;
  EODEnum? eodEnum;
  String? selectedData;

  setSelectedData(v) {
    eodRequestModel.date = v;
  }

  setView(v) {
    _eodView = v;
  }

  setEODEnum(v) {
    eodEnum = v;
    notifyListeners();
  }

  fetchFullEOD(String userID) {
    pageState = PageState.isLoading;
    notifyListeners();
    eodRequestModel.userID = userID;
    Repository()
        .fullReportEOD(eodRequestModel.toJson())
        .then((EODFullReportModel? data) async {
      if (data?.status == true) {
        if (data!.transaction!.isEmpty) {
          _eodView.onError("No transaction was recorded");
        } else {
          await EtopPosPlugin().printEOD(map: data.toJson());
        }
      } else {
        _eodView.onError("Request fails");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((e, v) {
      print(e.toString());
      print(v);
      pageState = PageState.loaded;
      notifyListeners();
      _eodView.onError("Request fails");
    });
  }

  void validateRegistrationPersonalForm() {
    if (eodEnum == null) {
      _eodView.onError("Please select report type");
      return;
    } else if (isEmpty(eodRequestModel.date)) {
      _eodView.onError("Please Enter EOD date");
      return;
    }
    _eodView.onFormValidation();
  }
}

abstract class EODView {
  onError(String message);
  onFormValidation();
  onSuccess();
}
//1519
