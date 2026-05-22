import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/Constant/string_values.dart';
import 'package:enk_pay_project/DataLayer/model/bank_transfer_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/modern_receipt_widgets.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/transfer_status_page.dart';
import 'package:enk_pay_project/UILayer/Screens/transfers/widget/transfer_recipient_widgets.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

void showBankTransferSuccessSheet(
  BuildContext context, {
  required String message,
  required BankTransferModel transfer,
  String? refTransId,
  required VoidCallback onDone,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return _TransferSuccessSheet(
        message: message,
        transfer: transfer,
        refTransId: refTransId,
        onDone: () {
          Navigator.pop(sheetContext);
          onDone();
        },
        onViewReceipt: () {
          Navigator.pop(sheetContext);
          if (isNotEmpty(refTransId)) {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => TransferStatusPage(
                  refTransId: refTransId,
                  transactionTitle: 'Bank Transfer',
                ),
              ),
            );
          } else {
            showBankTransferReceiptSheet(context, transfer);
          }
        },
      );
    },
  );
}

class _TransferSuccessSheet extends StatelessWidget {
  final String message;
  final BankTransferModel transfer;
  final String? refTransId;
  final VoidCallback onDone;
  final VoidCallback onViewReceipt;

  const _TransferSuccessSheet({
    required this.message,
    required this.transfer,
    this.refTransId,
    required this.onDone,
    required this.onViewReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.cardFill,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.88,
            ),
            child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: context.mutedText.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: Lottie.asset(
                          EPImages.successAnimation,
                          repeat: false,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Success',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.mutedText,
                              height: 1.4,
                              fontSize: 14,
                            ),
                      ),
                      const SizedBox(height: 14),
                      TransferRecipientSummaryCard(
                        bankName: transfer.receiverBank,
                        accountNumber: transfer.accountNumber,
                        accountHolderName: transfer.customerName,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: onViewReceipt,
                          icon: const Icon(Icons.receipt_long_rounded, size: 20),
                          label: const Text('View receipt'),
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
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onDone,
                          style: FilledButton.styleFrom(
                            backgroundColor: EPColors.appMainColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

void showBankTransferReceiptSheet(
  BuildContext context,
  BankTransferModel transfer,
) {
  final now = DateTime.now();
  final dateText = DateFormat('MMM d, y • h:mm a').format(now);

  final details = <ReceiptDetailRow>[];
  void add(String label, String? value, {IconData? icon}) {
    if (isNotEmpty(value)) {
      details.add(ReceiptDetailRow(
        label: label,
        value: value!,
        icon: icon,
      ));
    }
  }

  add('Recipient name', transfer.customerName, icon: Icons.person_outline_rounded);
  add('Bank name', transfer.receiverBank, icon: Icons.account_balance_rounded);
  add('Account number', transfer.accountNumber, icon: Icons.numbers_rounded);
  add('Narration', transfer.narration, icon: Icons.notes_rounded);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(ctx).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ctx.mutedText.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      Text(
                        'Transfer receipt',
                        style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    children: [
                      ModernReceiptCard(
                        status: 1,
                        title: 'Bank Transfer',
                        amountText: amountFormatter(transfer.amount),
                        dateText: dateText,
                        details: details,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: FilledButton.styleFrom(
                            backgroundColor: EPColors.appMainColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
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
