import 'package:enk_pay_project/DataLayer/controllers/package_controller.dart';
import 'package:flutter/cupertino.dart';

import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';

class ProductController with ChangeNotifier, GetAllPackage {
  Map allProductMap = {};
  PageState? pageState;
  Future allDataProduct() async {
    if (allProductMap.isEmpty && pageState == null) {
      pageState = PageState.loading;
      var data = await getProduct();
      pageState = PageState.loaded;
      notifyListeners();
      if (data["status"] = true) {
        allProductMap = data;
      } else {
        throw Exception("product fetch fails");
      }
    }
  }

  Future allCableProduct() async {
    if (allProductMap.isEmpty) {
      pageState = PageState.loading;
      var data = await getCableProduct();
      pageState = PageState.loaded;
      notifyListeners();
      if (data["status"] = true) {
        allProductMap = data;
      } else {
        throw Exception("product fetch fails");
      }
    }
  }

  clearResponse() {
    allProductMap.clear();
    pageState = null;
  }
}
