import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/controllers/branding_controller.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/DataLayer/controllers/signin_controller.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/widget/settings_ui.dart';
import 'package:enk_pay_project/UILayer/utils/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeOrganizationScreen extends StatefulWidget {
  const ChangeOrganizationScreen({super.key});

  @override
  State<ChangeOrganizationScreen> createState() =>
      _ChangeOrganizationScreenState();
}

class _ChangeOrganizationScreenState extends State<ChangeOrganizationScreen> {
  late final TextEditingController _codeController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final slug = context.read<BrandingController>().orgSlug ?? '';
    _codeController = TextEditingController(text: slug);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final slug = _codeController.text.trim();
    if (slug.isEmpty) {
      snackBar(context, message: 'Enter an organization code', forError: true);
      return;
    }

    final branding = context.read<BrandingController>();
    if (slug.toLowerCase() == (branding.orgSlug ?? '').toLowerCase()) {
      snackBar(context, message: 'This is already your organization code');
      return;
    }

    setState(() => _saving = true);
    final ok = await branding.loadBySlug(slug);
    if (!mounted) return;
    setState(() => _saving = false);

    if (!ok) {
      snackBar(
        context,
        message: branding.error ?? 'Organization not found',
        forError: true,
      );
      return;
    }

    final token = await LocalDataStorage.getToken();
    final wasLoggedIn = token != null && token.isNotEmpty;

    if (!wasLoggedIn) {
      snackBar(context, message: 'Organization updated');
      Navigator.pop(context);
      return;
    }

    if (!mounted) return;
    showAlertDialog(
      context,
      message: 'Organization updated. Please sign in again.',
      onTap: () async {
        Navigator.pop(context);
        await SignInController().logOut();
        await LocalDataStorage.clearUser();
        if (!mounted) return;
        Provider.of<DashBoardController>(context, listen: false).clearAll();
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final branding = context.watch<BrandingController>();

    return EPScaffold(
      appBar: EPAppBar(title: const Text('Organization code')),
      builder: (_) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (branding.hasOrganization) ...[
            SettingsGroupCard(
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: EPColors.appMainColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.business_rounded,
                          color: EPColors.appMainColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              branding.branding?.name ?? 'Organization',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Code: ${branding.orgSlug ?? '—'}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: context.mutedText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
          SettingsGroupCard(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'New organization code',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _codeController,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      decoration: InputDecoration(
                        hintText: 'e.g. demoorg',
                        prefixIcon: Icon(
                          Icons.tag_outlined,
                          color: context.mutedText,
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onSubmitted: (_) {
                        if (!_saving) _save();
                      },
                    ),
                    if (branding.error != null && !_saving) ...[
                      const SizedBox(height: 8),
                      Text(
                        branding.error!,
                        style: TextStyle(
                          color: EPColors.appDanger,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: EPColors.appMainColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _saving || branding.loading ? null : _save,
              child: _saving || branding.loading
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : const Text('Save organization'),
            ),
          ),
        ],
      ),
    );
  }
}
