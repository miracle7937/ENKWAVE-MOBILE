import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReceiptDashedDivider extends StatelessWidget {
  final Color color;

  const ReceiptDashedDivider({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dashCount,
            (_) => SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(decoration: BoxDecoration(color: color)),
            ),
          ),
        );
      },
    );
  }
}

class ReceiptDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;
  final IconData? icon;

  const ReceiptDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.copyable = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: context.mutedText),
            const SizedBox(width: 10),
          ],
          SizedBox(
            width: icon != null ? 88 : 96,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.mutedText,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    height: 1.3,
                  ),
            ),
          ),
          if (copyable)
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: value));
                snackBar(context, message: 'Copied');
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.copy_rounded,
                  size: 18,
                  color: EPColors.appMainColor.withValues(alpha: 0.9),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ModernReceiptCard extends StatelessWidget {
  final num? status;
  final String title;
  final String amountText;
  final String? dateText;
  final String? subtitle;
  final List<ReceiptDetailRow> details;
  final String? footerNote;

  const ModernReceiptCard({
    super.key,
    required this.status,
    required this.title,
    required this.amountText,
    this.dateText,
    this.subtitle,
    required this.details,
    this.footerNote,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = TransactionStatusUi.color(status);
    final isDark = context.isDarkMode;
    final paperColor = isDark ? const Color(0xFF1C1228) : Colors.white;

    return Material(
      color: paperColor,
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.borderColor),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: EPColors.appMainColor.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4C1D95),
                      Color(0xFF6B21A8),
                      Color(0xFF9333EA),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(EPImages.appIcon, height: 44),
                    const SizedBox(height: 16),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.5),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        TransactionStatusUi.icon(status),
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      TransactionStatusUi.label(status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        amountText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          height: 1.1,
                        ),
                      ),
                    ),
                    if (dateText != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dateText!,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  children: [
                    ReceiptDashedDivider(color: context.borderColor),
                    const SizedBox(height: 16),
                    ...details,
                    const SizedBox(height: 8),
                    ReceiptDashedDivider(color: context.borderColor),
                    const SizedBox(height: 16),
                    Text(
                      footerNote ??
                          'Thank you for banking with us',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.mutedText,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
