enum EODEnum {
  fullReport,
  // summaryReport,
}

String getEODValue(EODEnum v) {
  switch (v) {
    case EODEnum.fullReport:
      return "Full Report";
    default:
      return "Summary Report";
  }
}
