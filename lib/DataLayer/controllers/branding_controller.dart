import 'dart:convert';

import 'package:enk_pay_project/Constant/routes.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/organization_branding_model.dart';
import 'package:enk_pay_project/DataLayer/repository/organization_branding_repository.dart';
import 'package:enk_pay_project/core/network/api_error_message.dart';
import 'package:enk_pay_project/core/whitelabel/branding_applicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandingController extends ChangeNotifier {
  final _repo = OrganizationBrandingRepository();

  OrganizationBranding? _branding;
  bool _loading = false;
  String? _error;

  OrganizationBranding? get branding => _branding;
  bool get loading => _loading;
  String? get error => _error;
  bool get hasOrganization => _branding != null;

  String? get orgSlug => _branding?.slug;
  String get appTitle => _branding?.name ?? 'ENKPAY';

  Future<void> bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    final slug = prefs.getString(ConstantString.orgSlugKey);
    if (slug == null || slug.isEmpty) return;

    final cached = prefs.getString(ConstantString.orgBrandingKey);
    if (cached != null) {
      try {
        _branding = OrganizationBranding.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        _apply(_branding!);
        notifyListeners();
      } catch (_) {}
    }

    await loadBySlug(slug, silent: true);
  }

  Future<bool> loadByBusinessId(String businessId, {bool silent = false}) async {
    if (businessId.trim().isEmpty) return false;
    if (!silent) {
      _loading = true;
      _error = null;
      notifyListeners();
    }
    try {
      final data = await _repo.fetchByBusinessId(businessId.trim());
      await _persist(data);
      _branding = data;
      _apply(data);
      _error = null;
      return true;
    } catch (e) {
      _error = apiErrorMessage(e);
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> loadBySlug(String slug, {bool silent = false}) async {
    if (!silent) {
      _loading = true;
      _error = null;
      notifyListeners();
    }
    try {
      final code = slug.trim();
      OrganizationBranding data;
      try {
        data = await _repo.fetchBySlug(code.toLowerCase());
      } catch (_) {
        // Allow business_id style codes (e.g. 77LIW7WJ) as well as slug (e.g. sprint).
        data = await _repo.fetchByBusinessId(code);
      }
      await _persist(data);
      _branding = data;
      _apply(data);
      _error = null;
      return true;
    } catch (e) {
      _error = apiErrorMessage(e);
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _persist(OrganizationBranding data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ConstantString.orgSlugKey, data.slug);
    await prefs.setString(ConstantString.orgBrandingKey, jsonEncode(data.toJson()));
    if (data.apiBaseUrl != null && data.apiBaseUrl!.isNotEmpty) {
      AppRoute.setBaseRoute(data.apiBaseUrl!);
    }
  }

  void _apply(OrganizationBranding data) {
    BrandingApplicator.apply(data);
  }

  Future<void> clearOrganization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ConstantString.orgSlugKey);
    await prefs.remove(ConstantString.orgBrandingKey);
    _branding = null;
    BrandingApplicator.resetToDefault();
    AppRoute.resetBaseRoute();
    notifyListeners();
  }
}
