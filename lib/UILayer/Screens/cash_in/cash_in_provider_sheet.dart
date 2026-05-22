import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/Screens/cash_in/cash_in_brands.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef CashInProviderCallback = void Function(String provider);

/// Opens the bank picker sheet from the current screen (e.g. home dashboard).
Future<void> openCashInFlow(BuildContext context) async {
  final dash = Provider.of<DashBoardController>(context, listen: false);
  final dashUser = dash.userData;
  final UserData? user =
      (dashUser.email != null && dashUser.email!.isNotEmpty)
          ? dashUser
          : await LocalDataStorage.getUserData();
  if (!context.mounted) return;

  showCashInProviderSheet(
    context,
    user: user,
    onSelect: (provider) => _createCashInAccount(context, provider),
  );
}

Future<void> _createCashInAccount(BuildContext context, String provider) async {
  final dash = Provider.of<DashBoardController>(context, listen: false);
  if (dash.isCreatingStaticVa) return;

  final label = CashInBrands.displayName(provider);
  try {
    final ok = await dash.createStaticVirtualAccount(provider);
    if (!context.mounted) return;
    if (ok) {
      snackBar(context, message: '$label account is ready');
    } else {
      snackBar(context, message: 'Could not create $label account');
    }
  } catch (e) {
    if (context.mounted) snackBar(context, message: e.toString());
  }
}

void showCashInProviderSheet(
  BuildContext context, {
  required UserData? user,
  required CashInProviderCallback onSelect,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) => _CashInProviderSheet(user: user, onSelect: onSelect),
  );
}

class _CashInProviderSheet extends StatelessWidget {
  final UserData? user;
  final CashInProviderCallback onSelect;

  const _CashInProviderSheet({
    required this.user,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.mutedText.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choose your bank',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Static virtual account — receive transfers anytime.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.mutedText,
                  height: 1.35,
                ),
          ),
          const SizedBox(height: 22),
          _ProviderOptionCard(
            provider: 'palmpay',
            hasAccount: user?.hasCashInProvider('palmpay') ?? false,
            onTap: () {
              Navigator.pop(context);
              onSelect('palmpay');
            },
          ),
          const SizedBox(height: 12),
          _ProviderOptionCard(
            provider: 'nomba',
            hasAccount: user?.hasCashInProvider('nomba') ?? false,
            onTap: () {
              Navigator.pop(context);
              onSelect('nomba');
            },
          ),
        ],
      ),
    );
  }
}

class _ProviderOptionCard extends StatelessWidget {
  final String provider;
  final bool hasAccount;
  final VoidCallback onTap;

  const _ProviderOptionCard({
    required this.provider,
    required this.hasAccount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNomba = provider == 'nomba';
    final accent = CashInBrands.accentFor(provider);
    final logoBg = isNomba
        ? CashInBrands.nombaPurple.withValues(alpha: 0.12)
        : CashInBrands.palmpayYellow.withValues(alpha: 0.35);

    return Material(
      color: context.cardFill,
      elevation: 0,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasAccount
                  ? EPColors.appSuccess.withValues(alpha: 0.5)
                  : accent.withValues(alpha: 0.35),
              width: hasAccount ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: logoBg,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset(
                    CashInBrands.logoFor(provider),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      isNomba
                          ? Icons.account_balance_rounded
                          : Icons.wallet_rounded,
                      color: accent,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            CashInBrands.displayName(provider),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          if (hasAccount) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: EPColors.appSuccess.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Active',
                                style: TextStyle(
                                  color: EPColors.appSuccess,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasAccount
                            ? 'Tap to regenerate or view account'
                            : 'Create static virtual account',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.mutedText,
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 16, color: context.mutedText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
