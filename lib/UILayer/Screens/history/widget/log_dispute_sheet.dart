import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/controllers/dashboard_controller.dart';
import 'package:enk_pay_project/DataLayer/model/history_model.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_status_ui.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:enk_pay_project/UILayer/utils/time_ago_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void showLogDisputeSheet(BuildContext context, TransactionData transaction) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => LogDisputeSheet(transaction: transaction),
  );
}

class LogDisputeSheet extends StatefulWidget {
  final TransactionData transaction;

  const LogDisputeSheet({super.key, required this.transaction});

  @override
  State<LogDisputeSheet> createState() => _LogDisputeSheetState();
}

class _LogDisputeSheetState extends State<LogDisputeSheet> {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  TransactionData get tx => widget.transaction;

  @override
  void initState() {
    super.initState();
    _reasonController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (tx.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This transaction cannot be disputed.')),
      );
      return;
    }

    setState(() => _submitting = true);
    final ok = await Provider.of<DashBoardController>(context, listen: false)
        .logDispute(
      transactionId: tx.id!.toInt(),
      reason: _reasonController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _submitting = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final statusColor = TransactionStatusUi.color(tx.status);
    final ref = tx.eRef ?? tx.refTransId;
    final reasonLen = _reasonController.text.trim().length;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.92,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.orange.shade400,
                            Colors.deepOrange.shade600,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.gavel_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Log dispute',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Report an issue with this transaction',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: context.mutedText,
                                  height: 1.3,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: context.borderColor.withValues(
                          alpha: 0.35,
                        ),
                      ),
                      icon: Icon(Icons.close_rounded, color: context.mutedText),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _TransactionSummaryCard(
                        title: tx.title ?? 'Transaction',
                        amount: amountFormatter(tx.amount?.toString()),
                        reference: ref,
                        statusLabel: TransactionStatusUi.label(tx.status),
                        statusColor: statusColor,
                        dateLabel: tx.createdAt != null
                            ? TimeUtilAgo.format(tx.createdAt!)
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'What went wrong?',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 5,
                        minLines: 4,
                        maxLength: 500,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        textCapitalization: TextCapitalization.sentences,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.45,
                            ),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. Charged but data not received, wrong amount debited…',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: context.mutedText),
                          filled: true,
                          fillColor: context.isDarkMode
                              ? const Color(0xFF120A1C)
                              : EPColors.appSurface,
                          counterText: '$reasonLen / 500',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: EPColors.appMainColor,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (v) {
                          final text = (v ?? '').trim();
                          if (text.length < 10) {
                            return 'Please enter at least 10 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      _InfoBanner(
                        child: Text(
                          'Your organization will review this case. You cannot open duplicate disputes for the same transaction.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: context.mutedText,
                                height: 1.4,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  16 + MediaQuery.paddingOf(context).bottom,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(top: BorderSide(color: context.borderColor)),
                ),
                child: EPButton(
                  title: 'Submit dispute',
                  loading: _submitting,
                  onTap: _submitting ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionSummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String? reference;
  final String statusLabel;
  final Color statusColor;
  final String? dateLabel;

  const _TransactionSummaryCard({
    required this.title,
    required this.amount,
    required this.reference,
    required this.statusLabel,
    required this.statusColor,
    this.dateLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardFill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: EPColors.appMainColor.withValues(alpha: 0.15),
        ),
        boxShadow: EPColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.35)),
                ),
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: EPColors.appMainColor,
                  letterSpacing: -0.3,
                ),
          ),
          if (reference != null && reference!.isNotEmpty) ...[
            const SizedBox(height: 10),
            _MetaRow(
              icon: Icons.tag_rounded,
              label: 'Reference',
              value: reference!,
            ),
          ],
          if (dateLabel != null) ...[
            const SizedBox(height: 8),
            _MetaRow(
              icon: Icons.schedule_rounded,
              label: 'Date',
              value: dateLabel!,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.mutedText),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.mutedText,
                    height: 1.35,
                  ),
              children: [
                TextSpan(
                  text: '$label · ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final Widget child;

  const _InfoBanner({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EPColors.appMainColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: EPColors.appMainColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: EPColors.appMainColor.withValues(alpha: 0.85),
          ),
          const SizedBox(width: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}
