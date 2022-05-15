import 'package:enk_pay_project/DataLayer/controllers/package_controller.dart';
import 'package:flutter/cupertino.dart';

class ProductController with ChangeNotifier, GetAllPackage {
  Map allProductMap = {};
  allProduct() async {
    if (allProductMap.isEmpty) {
      var data = await getProduct();
      if (data["status"] = true) {
        allProductMap = data;
      } else {
        throw Exception("product fetch fails");
      }
    }
  }
}
