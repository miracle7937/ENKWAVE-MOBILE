import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

class BillPaymentInfoBanner extends StatelessWidget {
  final IconData icon;
  final String message;

  const BillPaymentInfoBanner({
    super.key,
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EPColors.appMainColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: EPColors.appMainColor.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: EPColors.appMainColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    height: 1.35,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class BillPaymentPlanChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const BillPaymentPlanChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? EPColors.appMainColor.withValues(alpha: 0.12)
          : context.inputFill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? EPColors.appMainColor : context.borderColor,
              width: selected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: selected ? EPColors.appMainColor : context.mutedText,
            ),
          ),
        ),
      ),
    );
  }
}

class BillPaymentVerifiedBanner extends StatelessWidget {
  final String name;

  const BillPaymentVerifiedBanner({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: EPColors.appSuccess.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: EPColors.appSuccess.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_rounded, color: EPColors.appSuccess, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: EPColors.appSuccess,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle? billPaymentFieldLabel(BuildContext context) {
  return Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.mutedText,
        fontWeight: FontWeight.w600,
        fontSize: 11,
      );
}
