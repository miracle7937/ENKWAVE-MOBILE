import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/material.dart';

class TransferWalletPicker extends StatelessWidget {
  final List<UserWallet> wallets;
  final UserWallet? selected;
  final ValueChanged<UserWallet> onSelected;

  const TransferWalletPicker({
    super.key,
    required this.wallets,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: wallets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          final isSelected = selected?.key == wallet.key;
          return _WalletChip(
            wallet: wallet,
            isSelected: isSelected,
            onTap: () => onSelected(wallet),
          );
        },
      ),
    );
  }
}

class _WalletChip extends StatelessWidget {
  final UserWallet wallet;
  final bool isSelected;
  final VoidCallback onTap;

  const _WalletChip({
    required this.wallet,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 168,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: isSelected
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4C1D95),
                      Color(0xFF7C3AED),
                    ],
                  )
                : null,
            color: isSelected ? null : context.cardFill,
            border: Border.all(
              color: isSelected
                  ? EPColors.appMainLightColor
                  : context.borderColor,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: EPColors.appMainColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 16,
                    color: isSelected ? Colors.white70 : scheme.primary,
                  ),
                  const Spacer(),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    size: 18,
                    color: isSelected ? Colors.white : context.mutedText,
                  ),
                ],
              ),
              Text(
                wallet.title ?? 'Wallet',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : scheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amountFormatter(wallet.amount?.toString()),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : scheme.onSurface.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: -0.2,
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
