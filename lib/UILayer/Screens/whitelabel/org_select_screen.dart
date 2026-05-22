import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/sign_in.dart';
import 'package:enk_pay_project/UILayer/Screens/AuthScreen/widget/auth_ui.dart';
import 'package:enk_pay_project/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// First launch: enter organization code to load whitelabel branding from Super Agent API.
class OrgSelectScreen extends StatefulWidget {
  const OrgSelectScreen({super.key});

  @override
  State<OrgSelectScreen> createState() => _OrgSelectScreenState();
}

class _OrgSelectScreenState extends State<OrgSelectScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final slug = _codeController.text.trim();
    if (slug.isEmpty) return;

    final branding = context.read<BrandingController>();
    final ok = await branding.loadBySlug(slug);
    if (!mounted) return;

    if (ok) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MyHomePage(title: 'ENKPAY')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(branding.error ?? 'Organization not found'),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1C1228)
              : EPColors.appDanger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final branding = context.watch<BrandingController>();

    return Scaffold(
      backgroundColor: EPColors.appMainDark,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
          children: [
            const AuthHeroHeader(
              title: 'Select your organization',
              subtitle: 'Enter your organization code to continue.',
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: Padding(
                padding: const EdgeInsets.all(20),
                child: AuthFormCard(
                  children: [
                    AuthTextField(
                      label: 'Organization code',
                      hintText: 'e.g. sprint or your org code',
                      controller: _codeController,
                      prefixIcon: Icon(
                        Icons.business_outlined,
                        color: context.mutedText,
                        size: 20,
                      ),
                    ),
                    if (branding.error != null) ...[
                      Text(
                        branding.error!,
                        style: TextStyle(color: EPColors.appDanger, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                    ],
                    AuthPrimaryButton(
                      title: branding.loading ? 'Loading…' : 'Continue',
                      loading: branding.loading,
                      onTap: branding.loading ? null : _continue,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInScreen()),
                        );
                      },
                      child: const Text('Already configured — sign in'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }
}
