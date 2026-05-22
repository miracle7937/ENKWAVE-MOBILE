import 'package:flutter/material.dart';

/// Brand assets and colors for cash-in providers.
abstract final class CashInBrands {
  static const palmpayLogo = 'assets/cash_in/palmpay_logo.png';
  static const nombaLogo = 'assets/cash_in/nomba_logo.png';

  static const palmpayYellow = Color(0xFFFFD400);
  static const palmpayDark = Color(0xFF1A1A1A);
  static const nombaPurple = Color(0xFF7C3AED);
  static const nombaLight = Color(0xFFA855F7);

  static String logoFor(String provider) =>
      provider == 'nomba' ? nombaLogo : palmpayLogo;

  static String displayName(String provider) =>
      provider == 'nomba' ? 'Nomba' : 'PalmPay';

  static Color accentFor(String provider) =>
      provider == 'nomba' ? nombaPurple : palmpayYellow;
}
