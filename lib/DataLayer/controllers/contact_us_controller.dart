import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:flutter/cupertino.dart';

import '../model/contact_us_model.dart';
import '../repository/setting_repository.dart';

class ContactUsController extends ChangeNotifier {
  PageState pageState = PageState.loaded;
  ContactData? contactUsData;
  ContactUseView? _view;
  set setView(v) {
    _view = v;
  }

  getContact() {
    if (contactUsData != null) {
      return;
    }
    pageState = PageState.loading;
    SettingRepository().contact().then((value) {
      if (value.status == true) {
        contactUsData = value.data;
      } else {
        _view?.onError("fails to get contact us");
      }
      pageState = PageState.loaded;
      notifyListeners();
    }).catchError((onError) {
      pageState = PageState.error;
      notifyListeners();
      _view?.onError(onError.toString());
    });
  }
}

abstract class ContactUseView {
  onSuccess();
  onError(String message);
}

enum ContactLauncher { phone, email, web }
