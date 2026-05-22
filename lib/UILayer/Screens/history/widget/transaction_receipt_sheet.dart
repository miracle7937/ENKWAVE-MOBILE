import 'dart:io';

import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/model/history_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/transfer_status_page.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/log_dispute_sheet.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_status_ui.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:enk_pay_project/UILayer/utils/time_ago_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

void showTransactionReceiptSheet(
  BuildContext context,
  TransactionData transaction,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => TransactionReceiptSheet(transaction: transaction),
  );
}

class TransactionReceiptSheet extends StatefulWidget {
  final TransactionData transaction;

  const TransactionReceiptSheet({super.key, required this.transaction});

  @override
  State<TransactionReceiptSheet> createState() => _TransactionReceiptSheetState();
}

class _TransactionReceiptSheetState extends State<TransactionReceiptSheet> {
  final ScreenshotController _screenshotController = ScreenshotController();

  TransactionData get tx => widget.transaction;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final statusColor = TransactionStatusUi.color(tx.status);

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.45,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.mutedText.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Transaction receipt',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close_rounded),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    children: [
                      Screenshot(
                        controller: _screenshotController,
                        child: _ReceiptCard(
                          transaction: tx,
                          statusColor: statusColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            showLogDisputeSheet(context, tx);
                          },
                          icon: const Icon(Icons.gavel_rounded, size: 20),
                          label: const Text('Log dispute'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.orange.shade800,
                            side: BorderSide(color: Colors.orange.withValues(alpha: 0.5)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _shareReceipt,
                              icon: const Icon(Icons.ios_share_rounded, size: 20),
                              label: const Text('Share'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: EPColors.appMainColor,
                                side: BorderSide(color: context.borderColor),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: FilledButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => TransferStatusPage(
                                      refTransId: tx.refTransId,
                                      transactionTitle: tx.title,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.receipt_long_rounded, size: 20),
                              label: const Text('View & print'),
                              style: FilledButton.styleFrom(
                                backgroundColor: EPColors.appMainColor,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _shareReceipt() async {
    try {
      final bytes = await _screenshotController.capture(pixelRatio: 3);
      if (bytes == null || !mounted) return;
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/receipt_${tx.refTransId ?? 'txn'}.png';
      await File(path).writeAsBytes(bytes);
      await Share.shareXFiles([XFile(path)], text: 'Transaction receipt');
    } catch (_) {
      if (mounted) {
        snackBar(context, message: 'Could not share receipt');
      }
    }
  }
}

class _ReceiptCard extends StatelessWidget {
  final TransactionData transaction;
  final Color statusColor;

  const _ReceiptCard({
    required this.transaction,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      EPColors.appMainDark,
                      EPColors.appMainColor,
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(EPImages.appIcon, height: 36),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            TransactionStatusUi.icon(transaction.status),
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            TransactionStatusUi.label(transaction.status),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      transaction.title ?? 'Transaction',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        amountFormatter(transaction.amount?.toString()),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          height: 1.1,
                        ),
                      ),
                    ),
                    if (transaction.createdAt != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        TimeUtilAgo.format(transaction.createdAt!),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                child: Column(
                  children: [
                    _DashedDivider(color: context.borderColor),
                    const SizedBox(height: 16),
                    ..._buildDetailRows(context),
                    const SizedBox(height: 16),
                    _DashedDivider(color: context.borderColor),
                    const SizedBox(height: 16),
                    Text(
                      'Thank you for banking with us',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: context.mutedText,
                            fontStyle: FontStyle.italic,
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

  List<Widget> _buildDetailRows(BuildContext context) {
    final rows = <_ReceiptRow>[
      if (_hasText(transaction.note))
        _ReceiptRow('Description', transaction.note!),
      if (_hasText(transaction.receiverName))
        _ReceiptRow('Recipient name', transaction.receiverName!),
      if (_hasText(transaction.receiverBank))
        _ReceiptRow('Bank name', transaction.receiverBank!),
      if (_hasText(transaction.reveiverAccountNo))
        _ReceiptRow('Account number', transaction.reveiverAccountNo!),
      if (_hasText(transaction.senderName))
        _ReceiptRow('Sender', transaction.senderName!),
      if (_hasText(transaction.refTransId))
        _ReceiptRow('Reference', transaction.refTransId!, copyable: true),
      if (_hasText(transaction.transactionId))
        _ReceiptRow('Transaction ID', transaction.transactionId!, copyable: true),
      if (_hasText(transaction.eRef))
        _ReceiptRow('E-Ref', transaction.eRef!, copyable: true),
      if (_hasText(transaction.transactionType))
        _ReceiptRow('Type', transaction.transactionType!),
      if (transaction.fee != null && transaction.fee! > 0)
        _ReceiptRow(
          'Fee',
          amountFormatter(transaction.fee?.toString()),
        ),
      if (transaction.balance != null)
        _ReceiptRow(
          'Balance after',
          amountFormatter(transaction.balance?.toString()),
        ),
      if (_hasText(transaction.terminalId))
        _ReceiptRow('Terminal', transaction.terminalId!),
    ];

    return rows
        .map((r) => _ReceiptDetailRow(
              label: r.label,
              value: r.value,
              copyable: r.copyable,
            ))
        .toList();
  }

  bool _hasText(String? v) => v != null && v.trim().isNotEmpty;
}

class _ReceiptRow {
  final String label;
  final String value;
  final bool copyable;

  _ReceiptRow(this.label, this.value, {this.copyable = false});
}

class _ReceiptDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool copyable;

  const _ReceiptDetailRow({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
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

class _DashedDivider extends StatelessWidget {
  final Color color;

  const _DashedDivider({required this.color});

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
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            ),
          ),
        );
      },
    );
  }
}
