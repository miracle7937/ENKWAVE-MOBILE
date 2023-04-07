import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/airtel_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/glo_mobile_data.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/mtn_mobile_data_model.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/n9mobile_data_model.dart';

import '../model/bank_list_response.dart';

abstract class MobileDataFetch {
  List<N9MobileDataModel>? get9mobileDataProduct();
  List<MtnMobileDataModel>? getMTNDataProduct();
  List<GloMobileDataModel>? getGloDataProduct();
  List<AirtelMobileDataModel>? getAirtelDataProduct();
  List<UserWallet>? getAccount();
}
