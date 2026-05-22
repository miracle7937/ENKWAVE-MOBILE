import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/Constant/colors.dart';
import 'package:enk_pay_project/Constant/image.dart';
import 'package:enk_pay_project/DataLayer/model/mobile_data_product_model/base_package.dart';
import 'package:enk_pay_project/UILayer/utils/money_formatter.dart';
import 'package:flutter/material.dart';

enum DataPlanPeriod { daily, weekly, monthly, yearly, other }

const kDataPlanPeriodOrder = [
  DataPlanPeriod.daily,
  DataPlanPeriod.weekly,
  DataPlanPeriod.monthly,
  DataPlanPeriod.yearly,
  DataPlanPeriod.other,
];

DataPlanPeriod classifyDataPlan(BasePackage package) {
  final text = (package.getDesc ?? '').toLowerCase();

  if (RegExp(r'\b(365|yearly|annual|12\s*months?|per\s*year)\b').hasMatch(text)) {
    return DataPlanPeriod.yearly;
  }
  if (RegExp(r'\b(30\s*days?|monthly|per\s*month)\b').hasMatch(text)) {
    return DataPlanPeriod.monthly;
  }
  if (RegExp(r'\b(7\s*days?|weekly|per\s*week)\b').hasMatch(text)) {
    return DataPlanPeriod.weekly;
  }
  if (RegExp(
    r'\b(1\s*day|2\s*days?|daily|night|hours?|24\s*hours?)\b',
  ).hasMatch(text)) {
    return DataPlanPeriod.daily;
  }
  return DataPlanPeriod.other;
}

String dataPlanShortTitle(String? description) {
  return dataPlanCompactTitle(description);
}

/// Shorter labels for list rows (period is already shown in section/chips).
String dataPlanCompactTitle(String? description) {
  var desc = description?.trim() ?? '';
  if (desc.isEmpty) return 'Data bundle';

  final dash = desc.indexOf(' - ');
  if (dash > 0) desc = desc.substring(0, dash).trim();

  desc = desc
      .replaceAll(
        RegExp(r'\s*(daily|weekly|monthly|yearly)\s*plan\s*', caseSensitive: false),
        ' ',
      )
      .replaceAll(RegExp(r'\s*plan\s*', caseSensitive: false), ' ')
      .replaceAll(
        RegExp(r'\(\s*1\s*day\s*\)', caseSensitive: false),
        '· 1d',
      )
      .replaceAllMapped(
        RegExp(r'\(\s*(\d+)\s*days?\s*\)', caseSensitive: false),
        (m) => '· ${m[1]}d',
      )
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  if (desc.length > 42) return '${desc.substring(0, 40).trim()}…';
  return desc;
}

const double _kPlanRowFontSize = 13;
const double _kPlanPriceFontSize = 13;

String dataPlanPeriodLabel(DataPlanPeriod period) {
  switch (period) {
    case DataPlanPeriod.daily:
      return 'Daily';
    case DataPlanPeriod.weekly:
      return 'Weekly';
    case DataPlanPeriod.monthly:
      return 'Monthly';
    case DataPlanPeriod.yearly:
      return 'Yearly';
    case DataPlanPeriod.other:
      return 'Other';
  }
}

IconData dataPlanPeriodIcon(DataPlanPeriod period) {
  switch (period) {
    case DataPlanPeriod.daily:
      return Icons.wb_sunny_outlined;
    case DataPlanPeriod.weekly:
      return Icons.date_range_rounded;
    case DataPlanPeriod.monthly:
      return Icons.calendar_month_outlined;
    case DataPlanPeriod.yearly:
      return Icons.event_available_outlined;
    case DataPlanPeriod.other:
      return Icons.layers_outlined;
  }
}

Map<DataPlanPeriod, List<BasePackage>> groupDataPlansByPeriod(
  List<BasePackage> packages,
) {
  final grouped = <DataPlanPeriod, List<BasePackage>>{
    for (final p in DataPlanPeriod.values) p: [],
  };
  for (final pkg in packages) {
    grouped[classifyDataPlan(pkg)]!.add(pkg);
  }
  for (final list in grouped.values) {
    list.sort((a, b) {
      final aa = double.tryParse(a.getAmount ?? '') ?? 0;
      final bb = double.tryParse(b.getAmount ?? '') ?? 0;
      return aa.compareTo(bb);
    });
  }
  return grouped;
}

Future<void> showMobileDataPlanSheet(
  BuildContext context, {
  required List<BasePackage> packages,
  required ValueChanged<BasePackage> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final height = MediaQuery.sizeOf(ctx).height * 0.92;
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: MobileDataPlanSheet(
            packages: packages,
            onSelected: (pkg) {
              Navigator.of(ctx).pop();
              onSelected(pkg);
            },
          ),
        ),
      );
    },
  );
}

class MobileDataPlanSheet extends StatefulWidget {
  final List<BasePackage> packages;
  final ValueChanged<BasePackage> onSelected;

  const MobileDataPlanSheet({
    super.key,
    required this.packages,
    required this.onSelected,
  });

  @override
  State<MobileDataPlanSheet> createState() => _MobileDataPlanSheetState();
}

class _MobileDataPlanSheetState extends State<MobileDataPlanSheet> {
  String _query = '';
  DataPlanPeriod? _filter;

  List<BasePackage> get _filteredPackages {
    final q = _query.trim().toLowerCase();
    return widget.packages.where((pkg) {
      if (_filter != null && classifyDataPlan(pkg) != _filter) {
        return false;
      }
      if (q.isEmpty) return true;
      final haystack = [
        pkg.getDesc,
        pkg.getAmount,
        dataPlanPeriodLabel(classifyDataPlan(pkg)),
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final grouped = groupDataPlansByPeriod(_filteredPackages);
    final visiblePeriods = kDataPlanPeriodOrder
        .where((p) => grouped[p]!.isNotEmpty)
        .toList();

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetHeader(onClose: () => Navigator.of(context).pop()),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search plans',
                  prefixIcon: const Icon(Icons.search_rounded, size: 22),
                  filled: true,
                  fillColor: context.isDarkMode
                      ? const Color(0xFF1C1228)
                      : EPColors.appSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: EPColors.appMainColor,
                      width: 1.5,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: context.mutedText,
                  ),
                ),
              ),
            ),
            _PeriodFilterChips(
              selected: _filter,
              counts: {
                for (final p in DataPlanPeriod.values)
                  p: widget.packages.where((e) => classifyDataPlan(e) == p).length,
              },
              onSelected: (p) => setState(() {
                _filter = _filter == p ? null : p;
              }),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: visiblePeriods.isEmpty
                  ? Center(
                      child: Text(
                        'No plans match your search',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.mutedText,
                            ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      itemCount: visiblePeriods.length,
                      itemBuilder: (context, sectionIndex) {
                        final period = visiblePeriods[sectionIndex];
                        final plans = grouped[period]!;
                        return _PlanSection(
                          period: period,
                          plans: plans,
                          onTap: widget.onSelected,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _SheetHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Text(
              'Mobile Data',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Image.asset(EPImages.closeIcon, width: 28, height: 28),
          ),
        ],
      ),
    );
  }
}

class _PeriodFilterChips extends StatelessWidget {
  final DataPlanPeriod? selected;
  final Map<DataPlanPeriod, int> counts;
  final ValueChanged<DataPlanPeriod> onSelected;

  const _PeriodFilterChips({
    required this.selected,
    required this.counts,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chips = kDataPlanPeriodOrder
        .where((p) => (counts[p] ?? 0) > 0)
        .toList();

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final period = chips[i];
          final isSelected = selected == period;
          return FilterChip(
            label: Text(
              dataPlanPeriodLabel(period),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: isSelected ? Colors.white : context.mutedText,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onSelected(period),
            showCheckmark: false,
            selectedColor: EPColors.appMainColor,
            backgroundColor: context.isDarkMode
                ? const Color(0xFF1C1228)
                : EPColors.appSurface,
            side: BorderSide(
              color: isSelected
                  ? EPColors.appMainColor
                  : context.borderColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          );
        },
      ),
    );
  }
}

class _PlanSection extends StatelessWidget {
  final DataPlanPeriod period;
  final List<BasePackage> plans;
  final ValueChanged<BasePackage> onTap;

  const _PlanSection({
    required this.period,
    required this.plans,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Row(
            children: [
              Icon(
                dataPlanPeriodIcon(period),
                size: 16,
                color: EPColors.appMainColor,
              ),
              const SizedBox(width: 6),
              Text(
                dataPlanPeriodLabel(period),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
              ),
              const SizedBox(width: 6),
              Text(
                '· ${plans.length}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.mutedText,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
        ...plans.map(
          (plan) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PlanCard(plan: plan, onTap: () => onTap(plan)),
          ),
        ),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final BasePackage plan;
  final VoidCallback onTap;

  const _PlanCard({required this.plan, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = dataPlanCompactTitle(plan.getDesc);
    final price = amountFormatterWithoutDecimal(plan.getAmount);

    return Material(
      color: context.cardFill,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.borderColor.withValues(alpha: 0.85)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: _kPlanRowFontSize,
                          height: 1.2,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  price,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: _kPlanPriceFontSize,
                        color: EPColors.appMainColor,
                        height: 1.2,
                      ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.mutedText.withValues(alpha: 0.55),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
