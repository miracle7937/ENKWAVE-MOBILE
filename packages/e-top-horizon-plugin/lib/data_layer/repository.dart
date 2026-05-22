import 'package:etop_pos_plugin/data_layer/request.dart';

import '../utils/route.dart';
import 'model/eod_Full_report_model.dart';
import 'model/summary_eod_model.dart';

class Repository {
  Future<SummaryEODModel?> summaryEOD(Map body) async {
    var data = await APIRequest().postRequest(
        route: HttpRoute.getInstance().eodSummaryReport(), body: body);
    return SummaryEODModel.fromJson(data);
  }

  Future<EODFullReportModel?> fullReportEOD(
    Map body,
  ) async {
    var data = await APIRequest().postRequest(
        route: HttpRoute.getInstance().eodFullReport(), body: body);
    return EODFullReportModel.fromJson(data);
  }
}
