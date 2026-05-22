import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_enum.dart';
import 'package:flutter/material.dart';

class HistorySelectable extends StatefulWidget {
  final Function(TransactionEnum)? onSelect;

  const HistorySelectable({super.key, this.onSelect});

  @override
  State<HistorySelectable> createState() => _HistorySelectableState();
}

class _HistorySelectableState extends State<HistorySelectable> {
  TransactionEnum selectedValue = TransactionEnum.all;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: TransactionEnum.values.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, index) => _FilterChip(
        label: getEnumName(TransactionEnum.values[index]),
        selected: selectedValue == TransactionEnum.values[index],
        onTap: () {
          final value = TransactionEnum.values[index];
          widget.onSelect?.call(value);
          setState(() => selectedValue = value);
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? EPColors.appMainColor : context.cardFill,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? EPColors.appMainColor
                  : context.borderColor,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: selected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
