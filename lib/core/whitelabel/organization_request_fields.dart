import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';

/// Fields sent with auth/register requests so the API scopes users per organization.
Map<String, dynamic> organizationRequestFields(BrandingController branding) {
  final fields = <String, dynamic>{};
  final businessId = branding.branding?.businessId;
  final slug = branding.orgSlug;

  if (businessId != null && businessId.isNotEmpty) {
    fields['business_id'] = businessId;
    fields['register_under_id'] = businessId;
    fields['organization_business_id'] = businessId;
  }
  if (slug != null && slug.isNotEmpty) {
    fields['organization_slug'] = slug;
  }

  return fields;
}
