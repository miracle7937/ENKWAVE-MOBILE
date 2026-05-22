class HttpRoute {
  static HttpRoute? _instance;
  HttpRoute._();

  factory HttpRoute.getInstance() {
    _instance ??= HttpRoute._();
    return _instance!;
  }

  setBaseURL(v) {
    baseURl = v;
  }

  String baseURl = "";
  String eodSummaryReport() => "${baseURl}eod-summary-report";
  String eodFullReport() => "${baseURl}eod";
}
