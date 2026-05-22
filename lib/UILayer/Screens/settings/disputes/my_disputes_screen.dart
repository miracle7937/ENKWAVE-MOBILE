import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/DataLayer/model/dispute_model.dart';
import 'package:enk_pay_project/DataLayer/repository/dashboard_repository.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_appbar.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/ep_scaffold.dart';
import 'package:enk_pay_project/UILayer/Screens/history/history_screen.dart';
import 'package:enk_pay_project/UILayer/Screens/settings/disputes/dispute_status_ui.dart';
import 'package:enk_pay_project/UILayer/utils/loader_widget.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:enk_pay_project/UILayer/utils/time_ago_util.dart';
import 'package:flutter/material.dart';

class MyDisputesScreen extends StatefulWidget {
  const MyDisputesScreen({super.key});

  @override
  State<MyDisputesScreen> createState() => _MyDisputesScreenState();
}

class _MyDisputesScreenState extends State<MyDisputesScreen> {
  List<DisputeItem> _disputes = [];
  bool _loading = true;
  String? _error;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await DashboardRepository().fetchMyDisputes();
      if (!mounted) return;
      setState(() {
        _disputes = result.disputes;
        _loading = false;
        if (!result.status && result.message != null) {
          _error = result.message;
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  List<DisputeItem> get _visibleDisputes {
    if (_filter == 'open') {
      return _disputes.where((d) => DisputeStatusUi.isOpen(d.status)).toList();
    }
    if (_filter == 'closed') {
      return _disputes.where((d) => !DisputeStatusUi.isOpen(d.status)).toList();
    }
    return _disputes;
  }

  int get _openCount =>
      _disputes.where((d) => DisputeStatusUi.isOpen(d.status)).length;

  @override
  Widget build(BuildContext context) {
    return EPScaffold(
      appBar: EPAppBar(title: const Text('My disputes')),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Text(
              'Track disputes you raised from transaction history and follow their status.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.mutedText,
                    height: 1.4,
                  ),
            ),
          ),
          if (!_loading && _disputes.isNotEmpty) ...[
            const SizedBox(height: 14),
            _SummaryStrip(openCount: _openCount, total: _disputes.length),
            const SizedBox(height: 12),
            _FilterChips(
              filter: _filter,
              onChanged: (v) => setState(() => _filter = v),
            ),
          ],
          Expanded(
            child: _loading
                ? const Center(child: LoaderWidget())
                : _error != null
                    ? _ErrorState(message: _error!, onRetry: _load)
                    : _visibleDisputes.isEmpty
                        ? _EmptyState(
                            filter: _filter,
                            onGoHistory: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HistoryScreen(),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            color: EPColors.appMainColor,
                            onRefresh: _load,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                              itemCount: _visibleDisputes.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) => _DisputeCard(
                                dispute: _visibleDisputes[i],
                                onTap: () => _showDetail(_visibleDisputes[i]),
                              ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }

  void _showDetail(DisputeItem dispute) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _DisputeDetailSheet(
        disputeId: dispute.id!,
        initial: dispute,
        onUpdated: _load,
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  final int openCount;
  final int total;

  const _SummaryStrip({required this.openCount, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _SummaryChip(
              label: 'Open',
              value: '$openCount',
              color: EPColors.appWarning,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _SummaryChip(
              label: 'Total',
              value: '$total',
              color: EPColors.appMainColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.mutedText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String filter;
  final ValueChanged<String> onChanged;

  const _FilterChips({required this.filter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget chip(String id, String label) {
      final selected = filter == id;
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onChanged(id),
        showCheckmark: false,
        selectedColor: EPColors.appMainColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: selected ? Colors.white : context.mutedText,
        ),
        backgroundColor: context.cardFill,
        side: BorderSide(
          color: selected ? EPColors.appMainColor : context.borderColor,
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          chip('all', 'All'),
          const SizedBox(width: 8),
          chip('open', 'Open'),
          const SizedBox(width: 8),
          chip('closed', 'Closed'),
        ],
      ),
    );
  }
}

class _DisputeCard extends StatelessWidget {
  final DisputeItem dispute;
  final VoidCallback onTap;

  const _DisputeCard({required this.dispute, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = DisputeStatusUi.color(dispute.status);
    final opened = dispute.openedAt != null
        ? TimeUtilAgo.format(dispute.openedAt!)
        : '—';

    return Material(
      color: context.cardFill,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.borderColor.withValues(alpha: 0.85)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    DisputeStatusUi.icon(dispute.status),
                    color: statusColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              dispute.reference ?? 'Dispute #${dispute.id}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Text(
                            amountFormatter(dispute.amount?.toString()),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: EPColors.appMainColor,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dispute.reason ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.mutedText,
                              height: 1.35,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: statusColor.withValues(alpha: 0.35),
                              ),
                            ),
                            child: Text(
                              DisputeStatusUi.label(dispute.status),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              opened,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: context.mutedText),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: context.mutedText.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DisputeDetailSheet extends StatefulWidget {
  final int disputeId;
  final DisputeItem initial;
  final VoidCallback onUpdated;

  const _DisputeDetailSheet({
    required this.disputeId,
    required this.initial,
    required this.onUpdated,
  });

  @override
  State<_DisputeDetailSheet> createState() => _DisputeDetailSheetState();
}

class _DisputeDetailSheetState extends State<_DisputeDetailSheet> {
  DisputeItem? _dispute;
  bool _loading = true;
  bool _sending = false;
  String? _error;
  final _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dispute = widget.initial;
    _loadDetail();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result =
          await DashboardRepository().fetchDisputeDetail(widget.disputeId);
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (result.status && result.dispute != null) {
          _dispute = result.dispute;
        } else {
          _error = result.message ?? 'Could not load conversation';
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _sendReply() async {
    final body = _replyController.text.trim();
    if (body.length < 2) return;

    setState(() => _sending = true);
    try {
      final result = await DashboardRepository().replyToDispute(
        disputeId: widget.disputeId,
        body: body,
      );
      if (!mounted) return;
      if (result.status && result.dispute != null) {
        _replyController.clear();
        setState(() {
          _dispute = result.dispute;
          _sending = false;
        });
        widget.onUpdated();
      } else {
        setState(() {
          _sending = false;
          _error = result.message ?? 'Could not send reply';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dispute = _dispute ?? widget.initial;
    final statusColor = DisputeStatusUi.color(dispute.status);
    final canReply = dispute.canReply && DisputeStatusUi.isOpen(dispute.status);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.mutedText.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  dispute.reference ?? 'Dispute #${dispute.id}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        DisputeStatusUi.label(dispute.status),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amountFormatter(dispute.amount?.toString()),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: EPColors.appMainColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? const Center(child: LoaderWidget())
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                    children: [
                      if (_error != null) ...[
                        Text(
                          _error!,
                          style: TextStyle(
                            color: EPColors.appDanger,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        'Conversation',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: context.mutedText,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 10),
                      ..._threadMessages(dispute).map(
                        (m) => _ThreadBubble(message: m),
                      ),
                      if ((dispute.notes ?? '').trim().isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          'Team notes',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: context.mutedText,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: EPColors.appMainColor.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(dispute.notes!.trim()),
                        ),
                      ],
                    ],
                  ),
          ),
          if (canReply)
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                12 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 2000,
                      decoration: InputDecoration(
                        hintText: 'Reply to support…',
                        filled: true,
                        fillColor: context.cardFill,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: context.borderColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _sending ? null : _sendReply,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _sending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                16 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Text(
                'This dispute is closed. Replies are no longer accepted.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.mutedText,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  List<DisputeMessageItem> _threadMessages(DisputeItem dispute) {
    if (dispute.messages.isNotEmpty) return dispute.messages;
    final reason = (dispute.reason ?? '').trim();
    if (reason.isEmpty) return [];
    return [
      DisputeMessageItem(
        authorRole: 'customer',
        authorName: 'You',
        body: reason,
        createdAt: dispute.openedAt,
      ),
    ];
  }
}

class _ThreadBubble extends StatelessWidget {
  final DisputeMessageItem message;

  const _ThreadBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isCustomer = message.isFromCustomer;
    final bg = isCustomer
        ? Colors.orange.withValues(alpha: 0.1)
        : EPColors.appMainColor.withValues(alpha: 0.08);
    final align = isCustomer ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Text(
            message.authorName ?? (isCustomer ? 'You' : 'Support team'),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: context.mutedText,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.78,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              message.body ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
            ),
          ),
          if (message.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(
              TimeUtilAgo.format(message.createdAt!),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: context.mutedText,
                    fontSize: 10,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.mutedText,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String filter;
  final VoidCallback onGoHistory;

  const _EmptyState({required this.filter, required this.onGoHistory});

  @override
  Widget build(BuildContext context) {
    final noMatches = filter != 'all';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.gavel_rounded,
              size: 56,
              color: EPColors.appMainColor.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 16),
            Text(
              noMatches ? 'No disputes in this filter' : 'No disputes yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              noMatches
                  ? 'Try another filter or pull to refresh.'
                  : 'Raise a dispute from History on any transaction using the gavel icon.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.mutedText,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
            if (!noMatches) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onGoHistory,
                icon: const Icon(Icons.receipt_long_rounded),
                label: const Text('Go to History'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48, color: EPColors.appDanger),
            const SizedBox(height: 12),
            Text(
              'Could not load disputes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.mutedText,
                  ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
