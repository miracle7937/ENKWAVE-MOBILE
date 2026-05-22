import 'dart:convert';

import 'package:enk_pay_project/Constant/superagent_config.dart';
import 'package:enk_pay_project/DataLayer/model/organization_branding_model.dart';
import 'package:enk_pay_project/core/network/api_error_message.dart';
import 'package:http/http.dart' as http;

class OrganizationBrandingRepository {
  Future<OrganizationBranding> fetchByBusinessId(String businessId) async {
    try {
      final res = await http
          .get(Uri.parse(SuperAgentConfig.brandingByBusinessId(businessId)))
          .timeout(const Duration(seconds: 25));
      return _parseBrandingResponse(res);
    } catch (e) {
      throw Exception(apiErrorMessage(e));
    }
  }

  Future<OrganizationBranding> fetchBySlug(String slug) async {
    try {
      final res = await http
          .get(Uri.parse(SuperAgentConfig.brandingBySlug(slug)))
          .timeout(const Duration(seconds: 25));
      return _parseBrandingResponse(res);
    } catch (e) {
      throw Exception(apiErrorMessage(e));
    }
  }

  OrganizationBranding _parseBrandingResponse(http.Response res) {
    final raw = res.body.trim();
    if (raw.isEmpty) {
      throw const FormatException('Empty response from server');
    }
    if (raw.startsWith('<') || raw.startsWith('<!')) {
      throw FormatException(
        'Server returned an error page (HTTP ${res.statusCode}). '
        'The TMS may need Redis/predis configured — contact support.',
      );
    }

    final dynamic decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Unexpected response format');
    }
    final body = decoded;

    if (res.statusCode == 404) {
      throw Exception(
        body['message']?.toString() ??
            'Organization not found. Check the code and try again.',
      );
    }
    if (res.statusCode != 200 || body['status'] != true) {
      throw Exception(
        body['message']?.toString() ?? 'Failed to load organization (HTTP ${res.statusCode})',
      );
    }
    final data = body['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Missing organization data in response');
    }
    return OrganizationBranding.fromJson(data);
  }

  Future<List<Map<String, dynamic>>> listOrganizations({String? query}) async {
    var url = SuperAgentConfig.organizationsList;
    if (query != null && query.trim().isNotEmpty) {
      url += '?q=${Uri.encodeQueryComponent(query.trim())}';
    }
    final res = await http.get(Uri.parse(url));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    if (res.statusCode != 200 || body['status'] != true) {
      return [];
    }
    return List<Map<String, dynamic>>.from(body['data'] as List);
  }
}
