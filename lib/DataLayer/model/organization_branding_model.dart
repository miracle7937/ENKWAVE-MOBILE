import 'package:flutter/material.dart';

class OrganizationBranding {
  final String businessId;
  final String slug;
  final String name;
  final String? logoUrl;
  final String primaryColor;
  final String primaryLightColor;
  final String primaryDarkColor;
  final String accentColor;
  final String surfaceColor;
  final String? apiBaseUrl;

  const OrganizationBranding({
    required this.businessId,
    required this.slug,
    required this.name,
    this.logoUrl,
    required this.primaryColor,
    required this.primaryLightColor,
    required this.primaryDarkColor,
    required this.accentColor,
    required this.surfaceColor,
    this.apiBaseUrl,
  });

  factory OrganizationBranding.fromJson(Map<String, dynamic> json) {
    return OrganizationBranding(
      businessId: json['business_id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Agency Banking',
      logoUrl: json['logo_url']?.toString(),
      primaryColor: json['primary_color']?.toString() ?? '#6B21A8',
      primaryLightColor: json['primary_light_color']?.toString() ?? '#9333EA',
      primaryDarkColor: json['primary_dark_color']?.toString() ?? '#4C1D95',
      accentColor: json['accent_color']?.toString() ?? '#E9D5FF',
      surfaceColor: json['surface_color']?.toString() ?? '#FAF5FF',
      apiBaseUrl: json['api_base_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'business_id': businessId,
        'slug': slug,
        'name': name,
        'logo_url': logoUrl,
        'primary_color': primaryColor,
        'primary_light_color': primaryLightColor,
        'primary_dark_color': primaryDarkColor,
        'accent_color': accentColor,
        'surface_color': surfaceColor,
        'api_base_url': apiBaseUrl,
      };

  static Color _parseHex(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    return Color(int.parse(h, radix: 16));
  }

  Color get primary => _parseHex(primaryColor);
  Color get primaryLight => _parseHex(primaryLightColor);
  Color get primaryDark => _parseHex(primaryDarkColor);
  Color get accent => _parseHex(accentColor);
  Color get surface => _parseHex(surfaceColor);
}
