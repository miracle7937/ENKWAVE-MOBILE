import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:enk_pay_project/DataLayer/model/organization_branding_model.dart';

/// Applies organization palette to global [EPColors] used across the app.
class BrandingApplicator {
  static void apply(OrganizationBranding branding) {
    EPColors.appMainColor = branding.primary;
    EPColors.appMainLightColor = branding.primaryLight;
    EPColors.appMainDark = branding.primaryDark;
    EPColors.appAccent = branding.accent;
    EPColors.appSurface = branding.surface;
    EPColors.appBorder = branding.accent.withValues(alpha: 0.85);
    EPColors.appAccentStrong = branding.primaryLight;
  }

  static void resetToDefault() {
    EPColors.appMainColor = const Color(0xFF6B21A8);
    EPColors.appMainLightColor = const Color(0xFF9333EA);
    EPColors.appMainDark = const Color(0xFF4C1D95);
    EPColors.appAccent = const Color(0xFFE9D5FF);
    EPColors.appSurface = const Color(0xFFFAF5FF);
    EPColors.appBorder = const Color(0xFFE9D5FF);
    EPColors.appAccentStrong = const Color(0xFFC084FC);
  }
}
