enum NetworkSelector { mtn, glo, airtel, n9Mobile, none }

String getServiceId(NetworkSelector non) {
  switch (non) {
    case NetworkSelector.mtn:
      return "mtn";
    case NetworkSelector.glo:
      return "glo";
    case NetworkSelector.airtel:
      return "airtel";
    default:
      return "9MOBILE";
  }
}

String getAirtimeTitle(NetworkSelector non) {
  switch (non) {
    case NetworkSelector.mtn:
      return "MTN NIGERIA";
    case NetworkSelector.glo:
      return "GLO NIGERIA";
    case NetworkSelector.airtel:
      return "AIRTEL NIGERIA";
    default:
      return "9MOBILE NIGERIA";
  }
}
