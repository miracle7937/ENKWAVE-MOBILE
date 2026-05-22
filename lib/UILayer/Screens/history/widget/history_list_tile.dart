import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/history_icons.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_enum.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_status_ui.dart';
import 'package:flutter/material.dart';

import '../../../../DataLayer/model/history_model.dart';
import '../../../utils/money_formatter.dart';
import '../../../utils/time_ago_util.dart';

class HistoryListTile extends StatelessWidget {
  final TransactionData? transactionData;
  final VoidCallback? onTap;
  final VoidCallback? onDispute;

  const HistoryListTile({
    super.key,
    this.transactionData,
    this.onTap,
    this.onDispute,
  });

  @override
  Widget build(BuildContext context) {
    final tx = transactionData!;
    final statusColor = TransactionStatusUi.color(tx.status);

    return Material(
      color: context.cardFill,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.borderColor.withValues(alpha: 0.85),
            ),
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
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HistoryIcon(
                  transactionEnum:
                      getTransactionEnum(tx.transactionType ?? ''),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              formatTransactionTitle(tx.title),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  amountFormatter(tx.amount?.toString()),
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: EPColors.appMainColor,
                                        fontSize: 15,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if ((tx.note ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          tx.note!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: context.mutedText,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: context.mutedText,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: tx.createdAt != null
                                ? Text(
                                    TimeUtilAgo.format(tx.createdAt!),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: context.mutedText,
                                          fontSize: 11,
                                        ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: _StatusChip(
                                  label: TransactionStatusUi.label(tx.status),
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onDispute != null) ...[
                  Material(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: onDispute,
                      borderRadius: BorderRadius.circular(10),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.gavel_rounded,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.mutedText.withValues(alpha: 0.6),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
