import 'package:flutter/cupertino.dart';

import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import '../model/location_response.dart';
import '../model/request_device_model.dart';
import '../model/request_deviec_set_data.dart';
import '../repository/auth_repository.dart';
import '../repository/setting_repository.dart';

class RequestDeviceController extends ChangeNotifier {
  PageState pageState = PageState.loaded;
  RequestDeviceView? _requestDeviceView;
  OrderDeviceView? _orderDeviceView;
  RequestDevicePerson requestDevicePerson = RequestDevicePerson();
  RequestDeviceResponse? requestDeviceResponse;
  List<LocationData>? locationData;
  LocationData? location;
  bool isLoading = false;
  setRequestDeviceView(v) {
    _requestDeviceView = v;
  }

  setRequestCompleteView(v) {
    _orderDeviceView = v;
  }

  set setNGState(LocationData v) {
    location = v;
    requestDevicePerson.state = v.name;
    notifyListeners();
  }

  requestDevice() {
    if (!requestDevicePerson.isValid()) {
      _requestDeviceView?.onError("Please ensure all field are filled");
      return;
    }
    pageState = PageState.loading;
    notifyListeners();
    SettingRepository()
        .requestDevice(requestDevicePerson.toJson())
        .then((value) {
      if (value.status == true) {
        requestDeviceResponse = value;
        _requestDeviceView?.onSuccess(value.message ?? "");
      } else {
        _requestDeviceView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      _requestDeviceView?.onError(onError.toString() ?? "");
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  orderDeviceComplete() {
    pageState = PageState.loading;
    notifyListeners();
    SettingRepository().orderDeviceComplete(
        {"ref_no": requestDeviceResponse?.paymentRef ?? ""}).then((value) {
      if (value.status == true) {
        _orderDeviceView?.onSuccess(value.message ?? "");
      } else {
        _orderDeviceView?.onError(value.message ?? "");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      _orderDeviceView?.onError(onError.toString() ?? "");
      pageState = PageState.loaded;
      notifyListeners();
    });
  }

  getAllLocation() async {
    if (locationData == null) {
      try {
        isLoading = true;
        LocationResponse locationResponse = await AuthRepository.getAllState();
        if (locationResponse.status == true) {
          locationData = locationResponse.data;
        } else {
          _orderDeviceView?.onError("Get State failed");
        }

        isLoading = false;
        notifyListeners();
      } catch (e) {
        _orderDeviceView?.onError(e.toString());
        isLoading = false;
        notifyListeners();
      }
    }
  }
}

abstract class RequestDeviceView {
  onSuccess(String message);
  onError(String message);
}

abstract class OrderDeviceView {
  onSuccess(String message);
  onError(String message);
}
