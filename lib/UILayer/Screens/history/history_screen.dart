import 'package:enk_pay_project/UILayer/CustomWidget/ReUseableWidget/ep_button.dart';
import 'package:enk_pay_project/UILayer/CustomWidget/ScaffoldsWidget/page_state.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/history_list_tile.dart';
import 'package:enk_pay_project/UILayer/Screens/history/widget/history_selectable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../Constant/colors.dart';
import '../../../DataLayer/controllers/dashboard_controller.dart';
import '../../../services/navigation_service.dart';
import '../../CustomWidget/ReUseableWidget/bottom_dialog.dart';
import '../../CustomWidget/ReUseableWidget/custom_form.dart';
import '../../CustomWidget/ReUseableWidget/transfer_status_page.dart';
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
        return const Center(
          child: LoaderWidget(),
        );
      }
      return RefreshIndicator(
        onRefresh: () async {
          myProvider.fetchHistory(refresh: true);
        },
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: EPForm(
                    hintText: "Search",
                    onChange: (query) {
                      myProvider.filterHistoryItems(query);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    showCustomModal(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: EPColors.appMainColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: const Padding(
                        padding: EdgeInsets.all(11.0),
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              child: HistorySelectable(
                onSelect: (v) {
                  myProvider.filterByTransactionType(v);
                },
              ),
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            myProvider.queryTransactionData.isNotEmpty
                ? Expanded(
                    child: ListView(
                    children: myProvider.queryTransactionData
                        .map((e) => HistoryListTile(
                              transactionData: e,
                              onTap: () {
                                print(e.transactionType);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (builder) => TransferStatusPage(
                                          refTransId: e.refTransId,
                                        )));
                                // if (getTransactionEnum(
                                //         e.transactionType!) ==
                                //     TransactionEnum.bankTransfer) {
                                //   Navigator.of(context).push(
                                //       MaterialPageRoute(
                                //           builder: (builder) =>
                                //               TransferStatusPage(
                                //                 refTransId: e.refTransId,
                                //               )));
                                // }
                              },
                            ))
                        .toList(),
                  ))
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.list,
                          size: 50,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Empty Record",
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  )
          ],
        ),
      );
    });
  }

  void showCustomModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return createExtensibleDialogWidget(
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Wrap(
              children: [
                const SizedBox(
                  height: 15,
                ),
                EPDateForm(
                  hintText: "Start date",
                  onChange: (v) {
                    Provider.of<DashBoardController>(context, listen: false)
                        .startDate = v;
                  },
                ),
                const SizedBox(height: 20),
                EPDateForm(
                  hintText: "End date",
                  onChange: (v) {
                    Provider.of<DashBoardController>(context, listen: false)
                        .endDate = v;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                EPButton(
                  title: "PROCEED".toUpperCase(),
                  onTap: () {
                    Provider.of<DashBoardController>(context, listen: false)
                        .fetchHistoryByDate();
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: const SizedBox(
                    height: 15,
                  ),
                )
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
