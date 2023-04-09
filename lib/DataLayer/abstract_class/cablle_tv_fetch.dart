import 'package:enk_pay_project/DataLayer/model/cable_tv_model/dstv_response_tv.dart';
import 'package:enk_pay_project/DataLayer/model/cable_tv_model/gotv_response_model.dart';

import '../model/bank_list_response.dart';
import '../model/cable_tv_model/showmax_response.dart';
import '../model/cable_tv_model/startimes_response.dart';

abstract class CableTVDataFetch {
  List<GoTvResponseModel>? getGoTVProduct();
  List<DsTvResponseModel>? getDSTVProduct();
  List<StarTimesResponseModel>? getStarTimeProduct();
  List<ShowMaxResponseModel>? getShowMaxProduct();
  List<UserWallet>? getAccount();
}
