import 'package:enk_pay_project/UILayer/Screens/settings/widget/settings_ui.dart';
import 'package:flutter/material.dart';

/// Legacy wrapper — prefer [SettingsVerificationBanner].
class VerificationWidget extends StatelessWidget {
  final bool? isVerifyCompleted;
  final VoidCallback? onTap;

  const VerificationWidget({
    super.key,
    this.isVerifyCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsVerificationBanner(
      isVerified: isVerifyCompleted,
      onTap: onTap,
    );
  }
}
