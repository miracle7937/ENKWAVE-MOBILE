import 'dart:developer';

import 'package:enk_pay_project/DataLayer/controllers/package_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';

class ProductController with ChangeNotifier, GetAllPackage {
  Map allProductMap = {};
  PageState? pageState;
  String? productFetchError;

  Future allDataProduct() async {
    if (allProductMap.isNotEmpty || pageState != null) return;
    pageState = PageState.loading;
    productFetchError = null;
    notifyListeners();
    try {
      final data = await getProduct();
      final ok = data['status'] == true || data['status']?.toString() == 'true';
      if (ok) {
        allProductMap = Map<String, dynamic>.from(data);
      } else {
        productFetchError = data['message']?.toString() ??
            'Could not load data bundles. Try again later.';
      }
    } catch (e, stack) {
      if (kDebugMode) {
        log('get-data-plan failed: $e', stackTrace: stack);
      }
      productFetchError = 'Could not load data bundles. Check your connection.';
    } finally {
      pageState = PageState.loaded;
      notifyListeners();
    }
  }

  Future allCableProduct() async {
    if (allProductMap.isEmpty) {
      pageState = PageState.loading;
      var data = await getCableProduct();
      pageState = PageState.loaded;
      notifyListeners();
      if (data["status"] == true) {
        allProductMap = data;
      } else {
        throw Exception("product fetch fails");
      }
    }
  }

  clearResponse() {
    allProductMap.clear();
    pageState = null;
    productFetchError = null;
  }
}
