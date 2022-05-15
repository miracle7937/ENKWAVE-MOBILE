enum NetworkSelector { mtn, glo, airtel, n9Mobile, none }

String getAirtelRoute(NetworkSelector non) {
  switch (non) {
    case NetworkSelector.mtn:
      return "mtnAirtime";
    case NetworkSelector.glo:
      return "gloAirtime";
    case NetworkSelector.airtel:
      return "airtelAirtime";
    default:
      return "etisalatAirtime";
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
