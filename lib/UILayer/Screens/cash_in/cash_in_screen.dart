import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/DataLayer/model/login_response_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/cash_in/cash_in_brands.dart';
import 'package:enk_pay_project/UILayer/Screens/cash_in/cash_in_provider_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../CustomWidget/ReUseableWidget/snack_bar.dart';
import '../../CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import '../../utils/loader_widget.dart';

class CashInScreen extends StatefulWidget {
  const CashInScreen({Key? key}) : super(key: key);

  @override
  State<CashInScreen> createState() => _CashInScreenState();
}

class _CashInScreenState extends State<CashInScreen> {
  UserData? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final dash = Provider.of<DashBoardController>(context, listen: false);
    UserData? user = dash.userData;
    if (user.email == null || user.email!.isEmpty) {
      user = await LocalDataStorage.getUserData();
    }
    if (mounted) {
      setState(() {
        _user = user;
        _loading = false;
      });
    }
  }

  List<VirtualBank> get _accounts {
    final list = _user?.virtualBankList ?? [];
    final cashIn = list.where((b) => b.isPalmPay || b.isNomba).toList();
    return cashIn.isNotEmpty ? cashIn : list;
  }

  Future<void> _refreshAccounts() async {
    final dash = Provider.of<DashBoardController>(context, listen: false);
    await dash.fetchDashboardData(refresh: true);
    if (mounted) {
      setState(() => _user = dash.userData);
      await LocalDataStorage.saveUserData(dash.userData);
    }
  }

  void _openCreateMore() {
    showCashInProviderSheet(
      context,
      user: _user,
      onSelect: _createAccount,
    );
  }

  Future<void> _createAccount(String provider) async {
    final dash = Provider.of<DashBoardController>(context, listen: false);
    if (dash.isCreatingStaticVa) return;

    final label = CashInBrands.displayName(provider);
    try {
      final ok = await dash.createStaticVirtualAccount(provider);
      if (!mounted) return;
      if (ok) {
        setState(() => _user = dash.userData);
        snackBar(context, message: '$label account is ready');
      } else {
        snackBar(context, message: 'Could not create $label account');
      }
    } catch (e) {
      if (mounted) snackBar(context, message: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(
        title: const Text('Cash in'),
        backgroundColor: EPColors.appMainDark,
      ),
      builder: (_) => Consumer<DashBoardController>(
        builder: (context, dash, __) {
          final accounts = _accounts;
          final busy = dash.isCreatingStaticVa;

          if (_loading) {
            return const Center(child: LoaderWidget());
          }

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: EPColors.appMainLightColor,
                      onRefresh: _refreshAccounts,
                      child: accounts.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.all(24),
                              children: [
                                _EmptyCashInState(onCreate: _openCreateMore),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                              itemCount: accounts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (_, i) => _CashInAccountCard(
                                bank: accounts[i],
                                user: _user,
                              ),
                            ),
                    ),
                  ),
                  _CreateMoreBar(
                    onPressed: busy ? null : _openCreateMore,
                    hasAccounts: accounts.isNotEmpty,
                  ),
                ],
              ),
              if (busy)
                Container(
                  color: Colors.black45,
                  child: const Center(child: LoaderWidget()),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyCashInState extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyCashInState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        Icon(
          Icons.account_balance_wallet_outlined,
          size: 72,
          color: EPColors.appMainColor.withValues(alpha: 0.35),
        ),
        const SizedBox(height: 20),
        Text(
          'No cash-in account yet',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Create a PalmPay or Nomba static account to fund your wallet from any bank.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.mutedText,
                height: 1.45,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        EPButton(
          title: 'Create account',
          onTap: onCreate,
        ),
      ],
    );
  }
}

class _CreateMoreBar extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool hasAccounts;

  const _CreateMoreBar({
    required this.onPressed,
    required this.hasAccounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        12 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: context.borderColor)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: Text(hasAccounts ? 'Create more account' : 'Create account'),
        style: OutlinedButton.styleFrom(
          foregroundColor: EPColors.appMainColor,
          side: BorderSide(color: EPColors.appMainColor.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

String _resolveAccountName(VirtualBank bank, UserData? user) {
  final fromBank = bank.accountName?.trim();
  if (fromBank != null && fromBank.isNotEmpty) return fromBank;

  final fromUser = user?.accountName?.trim();
  if (fromUser != null && fromUser.isNotEmpty) return fromUser;

  final vName = user?.vAccountName?.trim();
  if (vName != null && vName.isNotEmpty) return vName;

  final parts = [user?.firstName, user?.lastName]
      .whereType<String>()
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty);
  if (parts.isNotEmpty) return parts.join(' ');

  return '—';
}

class _CashInAccountCard extends StatelessWidget {
  final VirtualBank bank;
  final UserData? user;

  const _CashInAccountCard({required this.bank, this.user});

  String get _provider {
    if (bank.isNomba) return 'nomba';
    if (bank.isPalmPay) return 'palmpay';
    return 'palmpay';
  }

  @override
  Widget build(BuildContext context) {
    final accent = CashInBrands.accentFor(_provider);

    return Container(
      decoration: BoxDecoration(
        color: context.cardFill,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
        boxShadow: EPColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    CashInBrands.logoFor(_provider),
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.account_balance_rounded,
                      color: accent,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bank.bankName ?? CashInBrands.displayName(_provider),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AccountNameBlock(name: _resolveAccountName(bank, user)),
                const SizedBox(height: 12),
                _AccountNumberRow(accountNo: bank.accountNo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountNameBlock extends StatelessWidget {
  final String name;

  const _AccountNameBlock({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account name',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: context.mutedText,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
        ),
      ],
    );
  }
}

class _AccountNumberRow extends StatelessWidget {
  final String? accountNo;

  const _AccountNumberRow({this.accountNo});

  @override
  Widget build(BuildContext context) {
    final no = accountNo?.trim() ?? '';
    final display = no.isNotEmpty ? no : '—';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: EPColors.appSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account number',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: context.mutedText,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  display,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    fontFamily: 'monospace',
                    color: EPColors.appBlackColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          if (no.isNotEmpty)
            Material(
              color: EPColors.appMainColor,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: no));
                  snackBar(context, message: 'Account number copied');
                },
                borderRadius: BorderRadius.circular(10),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy_rounded, size: 18, color: Colors.white),
                      SizedBox(width: 6),
                      Text(
                        'Copy',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
