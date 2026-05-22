/// Super Agent whitelabel API (Laravel `superagent` at tms.enkpay.com).
class SuperAgentConfig {
  /// Production host — organization branding & whitelabel lookup.
  static const String productionHost = 'tms.enkpay.com';

  static const String productionApiBase = 'https://$productionHost/api';

  /// Override for local dev only:
  /// `flutter run --dart-define=SUPERAGENT_API_URL=http://192.168.x.x:8000/api`
  static const String apiBase = String.fromEnvironment(
    'SUPERAGENT_API_URL',
    defaultValue: productionApiBase,
  );

  static String brandingBySlug(String slug) =>
      '$apiBase/v1/organizations/$slug/branding';

  static String brandingByBusinessId(String businessId) =>
      '$apiBase/v1/organizations/by-business/$businessId/branding';

  static String organizationsList = '$apiBase/v1/organizations';
}
