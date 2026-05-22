import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/model/bank_list_response.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/bank_picker_sheet.dart';
import 'package:flutter/material.dart';

/// Tappable field that opens the modern bank picker sheet.
class BankSelectorField extends StatelessWidget {
  final Bank? selectedBank;
  final List<Bank> banks;
  final ValueChanged<Bank> onSelected;

  const BankSelectorField({
    super.key,
    required this.selectedBank,
    required this.banks,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasBank = selectedBank != null;

    return Material(
      color: context.isDarkMode ? const Color(0xFF120A1C) : EPColors.appSurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: banks.isEmpty
            ? null
            : () async {
                final bank = await showBankPickerSheet(
                  context,
                  banks: banks,
                  selected: selectedBank,
                );
                if (bank != null) onSelected(bank);
              },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasBank
                  ? scheme.primary.withValues(alpha: 0.35)
                  : context.borderColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    size: 18,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasBank ? selectedBank!.bankName! : 'Choose bank',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: hasBank ? scheme.onSurface : context.mutedText,
                        ),
                      ),
                      if (!hasBank)
                        Text(
                          'Tap to select recipient bank',
                          style: TextStyle(
                            fontSize: 11,
                            color: context.mutedText,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.unfold_more_rounded, color: context.mutedText, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows selected bank + account on the transfer form.
class TransferRecipientSummaryCard extends StatelessWidget {
  final String? bankName;
  final String? accountNumber;
  final String? accountHolderName;

  const TransferRecipientSummaryCard({
    super.key,
    this.bankName,
    this.accountNumber,
    this.accountHolderName,
  });

  bool get _hasContent =>
      (bankName?.trim().isNotEmpty ?? false) ||
      (accountNumber?.trim().isNotEmpty ?? false);

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sending to',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: context.mutedText,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 10),
          if (bankName?.trim().isNotEmpty ?? false)
            _SummaryLine(
              icon: Icons.account_balance_rounded,
              label: 'Bank',
              value: bankName!.trim(),
            ),
          if (accountNumber?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            _SummaryLine(
              icon: Icons.numbers_rounded,
              label: 'Account no.',
              value: accountNumber!.trim(),
            ),
          ],
          if (accountHolderName?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: 8),
            _SummaryLine(
              icon: Icons.verified_rounded,
              label: 'Account name',
              value: accountHolderName!.trim(),
              valueColor: EPColors.appSuccess,
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryLine({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: context.mutedText),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: context.mutedText),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? Theme.of(context).colorScheme.onSurface,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
