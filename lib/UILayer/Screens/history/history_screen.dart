import 'package:enk_pay_project/Constant/app_theme.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/history_list_tile.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/history_selectable.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/log_dispute_sheet.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/transaction_receipt_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/controllers/dashboard_controller.dart';
import '../../../services/navigation_service.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../utils/loader_widget.dart';
import '../v_cards_screen/widget/card_info_sheet_view.dart';

class HistoryScreen extends StatelessWidget with HistoryView {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<DashBoardController>(context, listen: false)
      ..setHistoryView = this
      ..fetchHistory();

    return Consumer<DashBoardController>(builder: (context, myProvider, child) {
      if (Provider.of<DashBoardController>(context, listen: false).pageState ==
          PageState.loading) {
        return const Center(child: LoaderWidget());
      }

      return ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: RefreshIndicator(
          color: EPColors.appMainColor,
          onRefresh: () async {
            await myProvider.fetchHistory(refresh: true);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transactions',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: EPColors.appBlackColor,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Search and filter your activity',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: EPColors.appGreyColor,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: EPForm(
                              hintText: 'Search transactions',
                              peffixIcon: Icon(
                                Icons.search_rounded,
                                color: context.mutedText,
                                size: 22,
                              ),
                              fillColor: context.cardFill,
                              enabledBorderColor: context.borderColor,
                              focusedBorderColor: EPColors.appMainColor,
                              onChange: myProvider.filterHistoryItems,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Material(
                            color: EPColors.appMainColor,
                            borderRadius: BorderRadius.circular(14),
                            elevation: 0,
                            child: InkWell(
                              onTap: () => showCustomModal(context),
                              borderRadius: BorderRadius.circular(14),
                              child: const Padding(
                                padding: EdgeInsets.all(13),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 42,
                        child: HistorySelectable(
                          onSelect: myProvider.filterByTransactionType,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              if (myProvider.queryTransactionData.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 56,
                          color: EPColors.appMuted.withValues(alpha: 0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: EPColors.appGreyColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final e = myProvider.queryTransactionData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: HistoryListTile(
                            transactionData: e,
                            onTap: () => showTransactionReceiptSheet(
                              context,
                              e,
                            ),
                            onDispute: () => showLogDisputeSheet(context, e),
                          ),
                        );
                      },
                      childCount: myProvider.queryTransactionData.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  void showCustomModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return createExtensibleDialogWidget(
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              children: [
                Text(
                  'Filter by date',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),
                EPDateForm(
                  hintText: 'Start date',
                  onChange: (v) {
                    Provider.of<DashBoardController>(context, listen: false)
                        .startDate = v;
                  },
                ),
                const SizedBox(height: 16),
                EPDateForm(
                  hintText: 'End date',
                  onChange: (v) {
                    Provider.of<DashBoardController>(context, listen: false)
                        .endDate = v;
                  },
                ),
                const SizedBox(height: 20),
                EPButton(
                  title: 'Apply filter',
                  onTap: () {
                    Provider.of<DashBoardController>(context, listen: false)
                        .fetchHistoryByDate();
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: const SizedBox(height: 15),
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.all(10),
        );
      },
    );
  }

  @override
  void onError(String message) {
    showEPStatusDialog(NavigationService.navigatorKey.currentState!.context,
        success: false, message: message, callback: () {
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
    });
  }

  @override
  void onSuccess(String message) {
    showEPStatusDialog(NavigationService.navigatorKey.currentState!.context,
        success: true, message: message, callback: () {
      Navigator.pop(NavigationService.navigatorKey.currentState!.context);
    });
  }
}
