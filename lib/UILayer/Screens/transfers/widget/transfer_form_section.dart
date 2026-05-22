import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:flutter/material.dart';

/// Card container for a transfer form block (no title — use [TransferSectionHeader]).
class TransferFormCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const TransferFormCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardFill,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.borderColor),
          boxShadow: context.isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: EPColors.appMainColor.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// @deprecated Use [TransferSectionHeader] + [TransferFormCard].
class TransferFormSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const TransferFormSection({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.mutedText,
                  fontSize: 11,
                ),
          ),
        ],
        const SizedBox(height: 10),
        TransferFormCard(child: child),
      ],
    );
  }
}
