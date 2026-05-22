import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/UILayer/Screens/main_screens/widgets/home_widgets.dart';
import 'package:flutter/material.dart';

import '../../../utils/money_formatter.dart';

/// Two wallet cards (main + bonus) with quick actions below.
class HomeWalletsSection extends StatefulWidget {
  final String? mainAmount;
  final String? bonusAmount;
  final VoidCallback? onPayBills;
  final VoidCallback? cashIn;
  final VoidCallback? onTransfer;

  const HomeWalletsSection({
    super.key,
    this.mainAmount,
    this.bonusAmount,
    this.onPayBills,
    this.cashIn,
    this.onTransfer,
  });

  @override
  State<HomeWalletsSection> createState() => _HomeWalletsSectionState();
}

class _HomeWalletsSectionState extends State<HomeWalletsSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
  }

  double _cardHeight(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.38).clamp(148.0, 188.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<Widget> get _walletCards => [
        WalletBalanceCard(
          tag: 'Main wallet',
          label: 'Available balance',
          amount: widget.mainAmount ?? '0',
          hideFuture: LocalDataStorage.getHideBalance,
          onToggleHide: (v) {
            LocalDataStorage.saveHideBalance(v);
            setState(() {});
          },
          gradient: [
            EPColors.appMainDark,
            const Color(0xFF6B21A8),
            const Color(0xFF9333EA),
          ],
        ),
        WalletBalanceCard(
          tag: 'Bonus wallet',
          label: 'Bonus balance',
          amount: widget.bonusAmount ?? '0',
          hideFuture: LocalDataStorage.getHideBonus,
          onToggleHide: (v) {
            LocalDataStorage.saveHideBonus(v);
            setState(() {});
          },
          gradient: const [
            Color(0xFF4C1D95),
            Color(0xFF5B21B6),
            Color(0xFF7C3AED),
          ],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: _cardHeight(context),
          child: PageView.builder(
            controller: _pageController,
            itemCount: _walletCards.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _walletCards[index],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _walletCards.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentPage == index
                    ? EPColors.appMainColor
                    : EPColors.appMainColor.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                EPColors.appMainDark,
                const Color(0xFF6B21A8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: EPColors.appMainDark.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              BalanceActionChip(
                icon: Icons.receipt_long_rounded,
                label: 'PAY BILLS',
                color: EPColors.appAccent,
                onTap: widget.onPayBills,
              ),
              const SizedBox(width: 10),
              BalanceActionChip(
                icon: Icons.arrow_downward_rounded,
                label: 'CASH IN',
                color: EPColors.appSuccess,
                onTap: widget.cashIn,
              ),
              const SizedBox(width: 10),
              BalanceActionChip(
                icon: Icons.swap_horiz_rounded,
                label: 'TRANSFER',
                color: EPColors.appAccent,
                onTap: widget.onTransfer,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WalletBalanceCard extends StatefulWidget {
  final String tag;
  final String label;
  final String amount;
  final List<Color> gradient;
  final Future<bool> Function() hideFuture;
  final void Function(bool) onToggleHide;

  const WalletBalanceCard({
    super.key,
    required this.tag,
    required this.label,
    required this.amount,
    required this.hideFuture,
    required this.onToggleHide,
    required this.gradient,
  });

  @override
  State<WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<WalletBalanceCard> {
  String hideAmountString(String formatted) {
    return formatted.replaceAll(RegExp(r'[0-9]'), '*');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      initialData: true,
      future: widget.hideFuture(),
      builder: (_, snap) {
        final visible = snap.data ?? true;
        final displayText = visible
            ? amountFormatter(widget.amount)
            : hideAmountString(amountFormatter(widget.amount));

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradient,
              stops: const [0.0, 0.5, 1.0],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.first.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.tag,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: EPColors.appAccentStrong,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 0.4,
                            ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => widget.onToggleHide(!visible),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          visible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.white.withValues(alpha: 0.9),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () => widget.onToggleHide(!visible),
                  borderRadius: BorderRadius.circular(8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      displayText,
                      maxLines: 1,
                      softWrap: false,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            height: 1.1,
                            fontSize: 26,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// @deprecated Use [HomeWalletsSection] instead.
class DashBoardCard extends StatelessWidget {
  final String? amount;
  final String? bonusWallet;
  final VoidCallback? onPayBills;
  final VoidCallback? cashIn;
  final VoidCallback? enkPayTransfer;

  const DashBoardCard({
    super.key,
    this.amount,
    this.bonusWallet,
    this.onPayBills,
    this.cashIn,
    this.enkPayTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return HomeWalletsSection(
      mainAmount: amount,
      bonusAmount: bonusWallet,
      onPayBills: onPayBills,
      cashIn: cashIn,
      onTransfer: enkPayTransfer,
    );
  }
}

class CardSelectCard extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback? onTap;

  const CardSelectCard({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Image.asset(image, width: 32, height: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.primaryText,
                      ),
                ),
              ),
              Icon(Icons.chevron_right, color: EPColors.appMuted),
            ],
          ),
        ),
      ),
    );
  }
}
