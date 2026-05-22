import 'dart:io';

import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/LocalData/local_data_storage.dart';
import 'package:enk_pay_project/DataLayer/controllers/transfer_status_controller.dart';
import 'package:enk_pay_project/DataLayer/model/transaction_status_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/modern_receipt_widgets.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/snack_bar.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_status_ui.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:enk_pay_project/UILayer/utils/time_ago_util.dart';
import 'package:etop_pos_plugin/etop_pos_plugin.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class TransferStatusPage extends StatefulWidget {
  final VoidCallback? onTap;
  final String? refTransId;
  final String? transactionTitle;

  const TransferStatusPage({
    super.key,
    this.onTap,
    this.refTransId,
    this.transactionTitle,
  });

  @override
  State<TransferStatusPage> createState() => _TransferStatusPageState();
}

class _TransferStatusPageState extends State<TransferStatusPage> {
  final ScreenshotController _screenshotController = ScreenshotController();
  TransferStatusController? _controller;

  @override
  void dispose() {
    _controller?.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransferStatusController>(
      builder: (context, provider, _) {
        _controller = provider..getTransaction(widget.refTransId!);

        final model = provider.transactionStatusModel;

        return EPScaffold(
          appBar: EPAppBar(
            title: const Text('Receipt'),
          ),
          state: AppState(
            pageState: provider.pageState,
            noDataMessage: model?.message,
          ),
          builder: (_) {
            if (model == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Screenshot(
                    controller: _screenshotController,
                    child: ModernReceiptCard(
                      status: model.status,
                      title: widget.transactionTitle ?? 'Bank transfer',
                      amountText: amountFormatter(model.amount?.toString()),
                      dateText: model.date != null
                          ? TimeUtilAgo.format2(model.date!)
                          : null,
                      subtitle:
                          "Actual credit time is subject to the recipient's bank.",
                      footerNote: model.message?.trim().isNotEmpty == true
                          ? model.message
                          : 'If the receiver is not credited within 10 minutes, '
                              'contact support with the reference below.',
                      details: _buildDetails(model),
                    ),
                  ),
                  if (model.message != null &&
                      model.message!.trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: EPColors.appMainColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: EPColors.appMainColor.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: EPColors.appMainColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              model.message!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
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
                          onPressed: () => _printReceipt(provider),
                          icon: const Icon(Icons.print_rounded, size: 20),
                          label: const Text('Print'),
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
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<ReceiptDetailRow> _buildDetails(TransactionStatusModel model) {
    final rows = <ReceiptDetailRow>[];

    void add(String label, String? value,
        {bool copy = false, IconData? icon}) {
      if (isNotEmpty(value)) {
        rows.add(ReceiptDetailRow(
          label: label,
          value: value!,
          copyable: copy,
          icon: icon,
        ));
      }
    }

    add('Recipient name', model.receiverName, icon: Icons.person_outline_rounded);
    add('Bank name', model.receiverBank, icon: Icons.account_balance_rounded);
    add(
      'Account number',
      model.receiverAccountNo,
      icon: Icons.numbers_rounded,
      copy: true,
    );
    add('Reference', model.eRef, copy: true, icon: Icons.tag_rounded);
    add('Card PAN', model.cardPan, icon: Icons.credit_card_rounded);
    add('RRN', model.rrn, copy: true, icon: Icons.receipt_long_rounded);
    add('Note', model.note, icon: Icons.notes_rounded);

    return rows;
  }

  Future<void> _shareReceipt() async {
    try {
      final bytes = await _screenshotController.capture(pixelRatio: 3);
      if (bytes == null || !mounted) return;
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/transfer_receipt.png';
      await File(path).writeAsBytes(bytes);
      await Share.shareXFiles([XFile(path)], text: 'Transaction receipt');
    } catch (_) {
      if (mounted) {
        snackBar(context, message: 'Could not share receipt');
      }
    }
  }

  Future<void> _printReceipt(TransferStatusController provider) async {
    final userData = await LocalDataStorage.getUserData();
    final map = <String, dynamic>{
      'title': widget.transactionTitle,
      'merchantName': userData?.terminalInfo?.merchantName,
      'data': _transactionPrintMap(provider),
    };
    EtopPosPlugin().reprint(map: map);
  }

  Map<String, dynamic> _transactionPrintMap(TransferStatusController provider) {
    final m = provider.transactionStatusModel;
    return {
      'Card Pan': m?.cardPan ?? '',
      'RRN': m?.rrn ?? '',
      'Recipient': m?.receiverName ?? '',
      'Recipient Bank': m?.receiverBank ?? '',
      'Recipient Account Number': m?.receiverAccountNo ?? '',
      'Transaction Amount': amountFormatter(m?.amount?.toString()) ?? '',
      'Date': m?.date != null ? TimeUtilAgo.format2(m!.date!) : '',
      'Message': TransactionStatusUi.label(m?.status),
    };
  }
}
